import 'package:coffee_house/components/constants.dart';
import 'package:coffee_house/layout/layout_screen.dart';
import 'package:coffee_house/screens/first_screen/main_login_and_sign_up_screen.dart';
import 'package:coffee_house/shared/app_bloc/cubit.dart';
import 'package:coffee_house/shared/bloc_observer.dart';
import 'package:coffee_house/shared/profile_bloc/cubit.dart';
import 'package:coffee_house/shared/shared_preferences.dart';
import 'package:coffee_house/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';


main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Shared.init();


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Bloc.observer = MyBlocObserver();
  email = await Shared.getDate('Email') ?? '';
  Widget screen;
  if (email != '') {
    screen = const LayoutScreen();
  } else {
    screen = const MainLoginAndSignUpScreen();
  }
  runApp(MyApp(screen));
}


class MyApp extends StatelessWidget {

  final Widget screen;
  const MyApp(this.screen,{super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
    );
    return  MultiBlocProvider(
      providers: [
        BlocProvider(
        create: (context)=>AppCubit()..getAllDrinks()..getPastOrders(),
        ),
        BlocProvider(
        create: (context)=>ProfileCubit()..getUserDataMethod()..getFavoriteDrink()..getMessages()
        ),
      ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: 'Noto',primarySwatch: Colors.brown,
            scaffoldBackgroundColor: backgroundColor,
            ),
            home: screen
          ),

    );
  }
}

