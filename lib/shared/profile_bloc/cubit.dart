import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_house/models/address_model.dart';
import 'package:coffee_house/models/rating_model.dart';
import 'package:coffee_house/shared/profile_bloc/states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../components/constants.dart';
import '../../models/drink_model.dart';
import '../../models/massage_model.dart';
import '../../models/user_model.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit() : super(InitialState());

  static ProfileCubit get(context) => BlocProvider.of(context);

  UserModel? userInformation;

  int currentIndex = 0;

  void changeCurrentIndex(int index) {
    currentIndex = index;
    emit(ChangeCurrentIndex());
  }

  bool showNameTheUser = false;

  Future<void> getUserDataMethod() async {
    addresses = [];
    emit(LoadingGetUserData());
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .get()
        .then((value) async {
      userInformation = UserModel.fromJson(value.data()!);
      showNameTheUser = true;
      for (var element in userInformation!.addresses) {
        addresses.add(AddressModel.fromJson(element));
      }
      if(userInformation!.doYouRateUs){
        await getUserRating();
      }
      emit(SuccessGetUserData());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorGetUserData());
    });
  }


  RatingModel rateModel = RatingModel(comment: '', name: '', email: email, rate: 1, phoneNumber: '', goodThings: []);

  Future<void> getUserRating() async {
    emit(LoadingGetUserRating());
    await FirebaseFirestore.instance
        .collection('Rates')
        .doc(email)
        .get()
        .then((value) {
      rateModel = RatingModel.fromJson(value.data()!);
      emit(SuccessGetUserRating());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(SuccessGetUserRating());
    });
  }



  List<DrinkModel> favorites = [];

  Future<void> setFavoriteDrink(DrinkModel drink) async {
    emit(LoadingSetFavoriteDrink());
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .collection('Favorites')
        .doc(drink.drinkName)
        .set(drink.toMap())
        .then((value) {
      emit(SuccessSetFavoriteDrink());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorSetFavoriteDrink());
    });
  }

  void getFavoriteDrink() {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .collection('Favorites')
        .snapshots()
        .listen((event) {
      favorites = [];
      for (var element in event.docs) {
        favorites.add(DrinkModel.fromJsonForFavoriteAndPastOrders(element.data()));
      }
      emit(SuccessGetFavoriteDrink());
    });
  }

  void removeFavoriteDrink(DrinkModel drink) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .collection('Favorites')
        .doc(drink.drinkName)
        .delete()
        .then((value) {
      emit(SuccessRemoveFavoriteDrink());
    });
  }

  Future<void> updateUser({
    required String name,
    required String phoneNumber,
  }) async {
    emit(LoadingUpdateUserData());
    await FirebaseFirestore.instance.collection('Users').doc(email).update({
      'Name': name,
      'Phone number': phoneNumber,
    }).then((value) {
      getUserDataMethod();
      emit(SuccessUpdateUserData());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorUpdateUserData());
    });
  }

  Future<void> sendAddressesToFirebase() async {
    emit(LoadingSendAddressesToFirebase());

    /// first delete the list
    await FirebaseFirestore.instance.collection('Users').doc(email).update(
      {
        'Addresses': [],
      },
    ).then(
      (value) async {
        /// then update
        List<Map<String, dynamic>> modelDataList =
            addresses.map((model) => model.toJson()).toList();
        await FirebaseFirestore.instance.collection('Users').doc(email).update({
          'Addresses': modelDataList,
        }).then((value) async {
          await getUserDataMethod();
          emit(SuccessSendAddressesToFirebase());
        }).catchError((error) {
          if (kDebugMode) {
            print(error.toString());
          }
          emit(ErrorSendAddressesToFirebase());
        });
      },
    ).catchError(
      (error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(ErrorSendAddressesToFirebase());
      },
    );
  }

  List<AddressModel> addresses = [];

  void setNewAddress(model) {
    addresses.add(model);
    emit(SetNewAddress());
  }

  void removeAddress(index) {
    addresses.removeAt(index);
    emit(RemoveAddress());
  }

  void updateAddress({
    required int index,
    required String address,
    required String title,
  }) {
    addresses[index].address = address;
    addresses[index].title = title;
    emit(UpdateAddress());
  }

  String ratingText = 'Excellent';
  int valueOfRate = 1;

  void rateTextMethod(int rate) {
    valueOfRate = rate;
    switch (rate) {
      case 1:
        ratingText = 'Worst';
        break;
      case 2:
        ratingText = 'Bad';
        break;
      case 3:
        ratingText = 'Neutral';
        break;
      case 4:
        ratingText = 'Good';
        break;
      case 5:
        ratingText = 'Excellent';
    }
    emit(ChangeRateText());
  }



  List goodThings = [];
  Future<void> sentUserRating({
    required String comment,
  }) async {
    RatingModel model = RatingModel(
        comment: comment,
        name: userInformation!.name,
        email: email,
        rate: valueOfRate,
        phoneNumber: userInformation!.phoneNumber,
        goodThings: goodThings,
    );
    emit(LoadingSentUserRating());
    await FirebaseFirestore.instance
        .collection('Rates')
        .doc(email)
        .set(model.toMap())
        .then((value) async {
          getUserRating();
      if(!userInformation!.doYouRateUs){
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(email)
            .update({
          'Do you rate us' : true
        }
        );
      }
      emit(SuccessSentUserRating());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorSentUserRating());
    });
  }


  void sendMessage({
    required String message,
  }) {
    DateTime now = DateTime.now();
    String time = DateFormat.jm().format(now);
    MessageModel model = MessageModel(
      email: email,
      dateTime: now,
      message: message,
      time: time,
      userName: userInformation?.name ?? 'Null'
    );
    FirebaseFirestore.instance
        .collection('Support')
        .doc(email)
        .collection('Chat')
        .add(model.toMap())
        .then((value) {
      emit(SuccessSendMessage());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorSendMessage());
    });
  }

  List<MessageModel> messages =[];

  Future<void> getMessages() async {
    FirebaseFirestore.instance.
    collection('Support')
        .doc(email)
        .collection('Chat')
        .orderBy('datetime')
        .snapshots()
        .listen((event) async {
      messages =[];
      for (var element in event.docs) {
        messages.add(MessageModel.fromJson(element.data()));
      }
      emit(SuccessGetMessages());
    });
  }
}
