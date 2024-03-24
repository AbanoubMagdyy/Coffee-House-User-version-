import 'package:coffee_house/layout/layout_screen.dart';
import 'package:coffee_house/shared/login_and_sign_up_bloc/cubit.dart';
import 'package:coffee_house/shared/login_and_sign_up_bloc/states.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/components.dart';
import '../../components/constants.dart';
import '../../shared/shared_preferences.dart';
import '../../style/colors.dart';

class LoginAndSignUpScreen extends StatelessWidget {
  static final loginEmailController = TextEditingController();
  static final signUpEmailController = TextEditingController();
  static final loginPasswordController = TextEditingController();
  static final signUpPasswordController = TextEditingController();
  static final confirmPasswordController = TextEditingController();
  final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');

  LoginAndSignUpScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginAndSignUpCubit, LoginAndSignUpStates>(
      listener: (context, state) {
        /// sign up
        if (state is SuccessSignUp) {
          LoginAndSignUpCubit.get(context).changeThemeToCreateAccountScreen();
        } else if (state is ErrorSignUP) {
          defMaterialBanner(context,
              'Error creating your account ,${state.error.split(']')[1].trim()}');
        }

        /// login
        if (state is SuccessLogin) {
          email = loginEmailController.text;
          Shared.saveDate(key: 'Email', value: loginEmailController.text)?.then((value) =>  navigateAndFinish(context, const LayoutScreen()));
        } else if (state is ErrorLogin) {
          defMaterialBanner(context,
              'Something went wrong. Please re-type the data correctly and try again');
        }

        /// forgot password
        if (state is SuccessForgotPassword) {
          defMaterialBanner(
              context, 'The code has been sent, Check your email');
        } else if (state is ErrorForgotPassword) {
          defMaterialBanner(context, 'Something went wrong. Please try again');
        }
      },
      builder: (context, state) {
        var cubit = LoginAndSignUpCubit.get(context);
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (state is LoadingForgotPassword ||
                  state is LoadingLogin ||
                  state is LoadingSignUp)
                defLinearProgressIndicator(),

              /// slider
              Container(
                margin: const EdgeInsetsDirectional.only(bottom: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: secColor),
                  borderRadius: BorderRadiusDirectional.circular(35),
                ),
                child: CustomSlidingSegmentedControl<int>(
                  initialValue: 1,
                  innerPadding: EdgeInsets.zero,
                  isStretch: true,
                  children: {
                    1: Text(
                      'Login',
                      style: TextStyle(
                        color: cubit.numberTheScreen == 1 ? defColor : secColor,
                      ),
                    ),
                    2: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: cubit.numberTheScreen == 2 ? defColor : secColor,
                      ),
                    ),
                  },
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                  ),
                  thumbDecoration: BoxDecoration(
                    color: secColor,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutSine,
                  onValueChanged: (v) {
                    cubit.changeSlider(v);
                  },
                ),
              ),

              /// body
              /// email
              defTextFormField(
                  text: 'Email',
                  controller: cubit.numberTheScreen == 1
                      ? loginEmailController
                      : signUpEmailController,
                  keyboard: TextInputType.emailAddress),

              /// password
              defTextFormField(
                  text: 'Password',
                  controller: cubit.numberTheScreen == 1
                      ? loginPasswordController
                      : signUpPasswordController,
                  forPassword: true,
                  icon: cubit.hidePassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  isPassword: cubit.hidePassword,
                  onPressed: () => cubit.changePasswordVisibility()),

              /// change between login or sign up
              /// forgot password button or confirm password text field
              Visibility(
                visible: cubit.numberTheScreen == 1,

                /// sign up
                replacement: Column(
                  children: [
                    defTextFormField(
                      text: 'Confirm password',
                      controller: confirmPasswordController,
                      forPassword: true,
                      icon: cubit.hideConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      isPassword: cubit.hideConfirmPassword,
                      onPressed: () => cubit.changeConfirmPasswordVisibility(),
                    ),
                  ],
                ),

                /// Forgot password
                child: TextButton(
                  onPressed: () {
                    if (loginEmailController.text.isNotEmpty) {
                      cubit.forgotPasswordMethod(
                          email: loginEmailController.text);
                    } else {
                      defMaterialBanner(context, 'Please enter your email');
                    }
                  },
                  child: const Text(
                    'Forgot password?',
                  ),
                ),
              ),

              /// login or sign up button
              defButton(
                  onTap: (){
                if(cubit.numberTheScreen == 1){
                  /// login
                  if (isFormValidForLogin(context)) {
                    cubit.loginMethod(
                      email: loginEmailController.text,
                      password: loginPasswordController.text,
                    );
                  }
                }else{
                  /// sign up
                  if (isFormValidForSignUp(context)) {
                    cubit.signUpMethod(
                      email: signUpEmailController.text,
                      password: signUpPasswordController.text,
                    );
                  }
                }
              },
                  child:  defText(text:cubit.numberTheScreen == 1 ? 'Login' :  'Sign Up',textColor: defColor)
              ),
            ],
          ),
        );
      },
    );
  }

  bool isFormValidForSignUp(context) {
    if (!areAllFieldsFilledForSignUp()) {
      showErrorMessage('Please enter all required information.', context);
      return false;
    }

    if (!isEmailValidForSignUp()) {
      showErrorMessage('Please enter a valid email address.', context);
      return false;
    }

    if (!doPasswordsMatch()) {
      showErrorMessage(
          'Password and confirm password are not identical.', context);
      return false;
    }

    if (!arePasswordsSufficient()) {
      showErrorMessage('Password must be longer than 7 characters.', context);
      return false;
    }

    return true;
  }

  bool isFormValidForLogin(context) {
    if (!areAllFieldsFilledForLogin()) {
      showErrorMessage('Please enter all required information.', context);
      return false;
    }

    if (!isEmailValidForLogin()) {
      showErrorMessage('Please enter a valid email address.', context);
      return false;
    }
    return true;
  }

  bool areAllFieldsFilledForSignUp() {
    return signUpEmailController.text.isNotEmpty &&
        signUpPasswordController.text.isNotEmpty;
  }

  bool areAllFieldsFilledForLogin() {
    return loginEmailController.text.isNotEmpty &&
        loginPasswordController.text.isNotEmpty;
  }

  bool isEmailValidForSignUp() {
    return emailRegExp.hasMatch(signUpEmailController.text);
  }

  bool isEmailValidForLogin() {
    return emailRegExp.hasMatch(loginEmailController.text);
  }

  bool doPasswordsMatch() {
    return signUpPasswordController.text == confirmPasswordController.text;
  }

  bool arePasswordsSufficient() {
    return signUpPasswordController.text.length > 7;
  }

  void showErrorMessage(String message, context) {
    defMaterialBanner(context, message);
  }
}
