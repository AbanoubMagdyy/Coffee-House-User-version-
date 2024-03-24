import 'package:coffee_house/components/components.dart';
import 'package:coffee_house/components/constants.dart';
import 'package:coffee_house/shared/login_and_sign_up_bloc/cubit.dart';
import 'package:coffee_house/shared/login_and_sign_up_bloc/states.dart';
import 'package:coffee_house/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'create_account_screen.dart';
import 'login_and_sign_up_screen.dart';

class MainLoginAndSignUpScreen extends StatelessWidget {

   const MainLoginAndSignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => LoginAndSignUpCubit(),
      child: BlocConsumer<LoginAndSignUpCubit, LoginAndSignUpStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = LoginAndSignUpCubit.get(context);
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: secColor,
            /// background
            body: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image:
                      AssetImage('assets/images/loginAndSignUpBackground.jfif'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      /// app name and bio
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: FittedBox(
                          child: Column(
                            children: [
                              Text(
                                appName.toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 20,
                                    letterSpacing: 3,
                                    color: secColor,
                                ),
                              ),
                            defText(text:  'A way to enjoy bitter and sweet of life',fontSize: 18)
                            ],
                          ),
                        ),
                      ),

                      /// body
                      Container(
                        margin: const EdgeInsetsDirectional.all(30),
                        padding: const EdgeInsetsDirectional.symmetric(
                            vertical: 20, horizontal: 50,
                        ),
                        height: screenHeight / 1.5,
                        width: 500,
                        decoration: BoxDecoration(
                          color: defColor,
                          border: Border.all(color: secColor),
                          borderRadius: BorderRadiusDirectional.circular(35),
                        ),
                        child: Visibility(
                          visible: cubit.changeTheme,
                          replacement: LoginAndSignUpScreen(),
                          child: CreateAccountScreen(userEmail: LoginAndSignUpScreen.signUpEmailController.text),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}