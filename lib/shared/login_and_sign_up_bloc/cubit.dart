import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_house/models/user_model.dart';
import 'package:coffee_house/shared/login_and_sign_up_bloc/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class LoginAndSignUpCubit extends Cubit<LoginAndSignUpStates> {
  LoginAndSignUpCubit() : super(InitialState());

  static LoginAndSignUpCubit get(context) => BlocProvider.of(context);

  int numberTheScreen = 1;

  changeSlider(int value) {
    numberTheScreen = value;
    emit(ChangeSlider());
  }

  bool hidePassword = true;
  bool hideConfirmPassword = true;

  void changePasswordVisibility() {
    hidePassword = !hidePassword;
    emit(ChangeVisibility());
  }

  void changeConfirmPasswordVisibility() {
    hideConfirmPassword = !hideConfirmPassword;
    emit(ChangeVisibility());
  }

  bool changeTheme = false;

  void changeThemeToCreateAccountScreen() {
    changeTheme = true;
    emit(ChangeTheme());
  }

  Future<void> loginMethod({
    required String email,
    required String password,
  }) async {
    emit(LoadingLogin());
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then(
      (value) {
        emit(SuccessLogin());
      },
    ).catchError(
      (error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(ErrorLogin());
      },
    );
  }


  Future<void> signUpMethod({
    required String email,
    required String password,
  }) async {
    emit(LoadingSignUp());
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then(
      (value) {
        emit(SuccessSignUp());
      },
    ).catchError(
      (error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(ErrorSignUP(error.toString()));
      },
    );
  }

  Future<void> forgotPasswordMethod({
    required String email,
  }) async {
    emit(LoadingForgotPassword());
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email).then(
      (value) {
        emit(SuccessForgotPassword());
      },
    ).catchError(
      (error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(ErrorForgotPassword());
      },
    );
  }

  final ImagePicker picker = ImagePicker();
  File? profileImage;

  Future<void> getImageFromGallery() async {
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      profileImage = File(image.path);
      emit(SuccessGetImageFromGallery());
    } else {
      emit(ErrorGetImageFromGallery());
    }
  }

  String imagePath =
      'https://i.pinimg.com/originals/9c/d0/31/9cd031e68d03d087906a11ef50ba8ee4.gif';

  Future<void> uploadProfileImageMethod() async {
    emit(LoadingUploadProfileImage());
    await FirebaseStorage.instance
        .ref()
        .child('Users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then(
      (value) {
        value.ref.getDownloadURL().then(
          (value) {
            imagePath = value;
            emit(SuccessUploadProfileImage());
          },
        ).catchError(
          (error) {
            if (kDebugMode) {
              print(error.toString());
            }
            emit(ErrorUploadProfileImage());
          },
        );
      },
    ).catchError(
      (error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(ErrorUploadProfileImage());
      },
    );
  }

  Future<void> createAccountMethod({
    required name,
    required email,
    required favoriteDrinks,
    required phoneNumber,
  }) async {
    emit(LoadingCreateAccount());
     UserModel model = UserModel(
      doYouRateUs: false,
      addresses: [],
      image: imagePath,
      name: name,
      email: email,
      favoriteDrinks: favoriteDrinks,
      phoneNumber: phoneNumber,
      theDateOfJoin: DateFormat.yMMMMd().format(DateTime.now())
    );
    FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .set(model.toMap())
        .then((value) {
      emit(SuccessCreateAccount());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorCreateAccount());
    });
  }
}
