import 'package:restart_app/restart_app.dart';
import '../models/drink_order_model.dart';
import '../shared/shared_preferences.dart';

List<String> favoriteDrinks = [];
List<DrinkOrderModel> recently = [] ;

const String appName = 'Coffee House';
const String shopLocation = 'Cairo';
const int yearOfEstablishment = 2022;

const int priceOfDelivery = 30;

String email = '';

void logout(context) {
  Shared.deleteData('Email')?.then((value) {
    Restart.restartApp();
    },
  );
}