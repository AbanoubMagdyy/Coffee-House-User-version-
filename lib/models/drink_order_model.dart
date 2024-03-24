import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_house/models/drink_model.dart';

class DrinkOrderModel{
  late DrinkModel drink;
  late int numberOfDrinks;
  late dynamic totalOfPrice;
  late DateTime date;


  DrinkOrderModel({
    required this.drink,
    required this.numberOfDrinks,
    required this.date,
    required this.totalOfPrice,
  });

  DrinkOrderModel.fromJson(Map<String, dynamic> json){
    drink = DrinkModel.fromJsonForFavoriteAndPastOrders(json['Drink']);
    numberOfDrinks = json['Number of Drinks'];
    totalOfPrice = json['Total of Price'];
    Timestamp firestoreTimestamp = json['Date'];
    DateTime datetime = firestoreTimestamp.toDate();
    date = datetime;
  }

  Map<String, dynamic> toMap() {
    return {
      'Drink': drink.toMap(),
      'Number of Drinks': numberOfDrinks,
      'Total of Price': totalOfPrice,
      'Date': date,
    };
  }

}