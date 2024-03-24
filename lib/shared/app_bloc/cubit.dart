import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_house/components/constants.dart';
import 'package:coffee_house/models/drink_model.dart';
import 'package:coffee_house/models/drink_order_model.dart';
import 'package:coffee_house/models/order_request_model.dart';
import 'package:coffee_house/shared/app_bloc/states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';
import '../../screens/bottom_navigation_bar_screens/drink_menu_screen.dart';
import '../../screens/bottom_navigation_bar_screens/favorites_screen.dart';
import '../../screens/bottom_navigation_bar_screens/home_screen.dart';
import '../../screens/bottom_navigation_bar_screens/order_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  void changeCurrentIndex(int index) {
    currentIndex = index;
    emit(ChangeCurrentIndex());
  }

  int numberTheScreen = 1;

  changeSlider(int value) {
    numberTheScreen = value;
    emit(ChangeSlider());
  }

  List<Widget> screens = [
    const HomeScreen(),
    DrinkMenuScreen(),
    OrderScreen(1),
    const FavoritesScreen(),
  ];

  final List<String> imagesUrl = [];
  final List<String> newDrinkName = [];
  late List<PaletteColor?> colorsForFirstShadow = [];
  late List<PaletteColor?> colorsForText = [];
  late List<PaletteColor?> colorsForSecondShadow = [];
  int bannerIndex = 0;

  void addColor() async {
    for (String image in imagesUrl) {
      final PaletteGenerator pg = await PaletteGenerator.fromImageProvider(
        CachedNetworkImageProvider(image),
      );
      colorsForFirstShadow
          .add(pg.lightVibrantColor ?? PaletteColor(Colors.white, 2));
      colorsForSecondShadow
          .add(pg.vibrantColor ?? PaletteColor(Colors.white, 2));
      colorsForText.add(pg.darkVibrantColor ?? PaletteColor(Colors.white, 2));
    }
  }

  void changeBannerIndex(int index) {
    bannerIndex = index;
    emit(ChangeBannerIndex());
  }

  List<DrinkModel> coffeeMenu = [];

  List<DrinkModel> chocolateMenu = [];

  List<DrinkModel> othersMenu = [];

  List<DrinkModel> allItems = [];

  List<DrinkOrderModel> pastOrder = [];

  List<DrinkModel> newItems = [];

  List<DrinkModel> recommendationItems = [];

  Future<void> getCoffeeMenu() async {
    emit(LoadingGetCoffeeMenu());
    await FirebaseFirestore.instance
        .collection('Menu')
        .doc('Sections')
        .collection('Coffee')
        .get()
        .then((value) {
      for (var element in value.docs) {
        coffeeMenu.add(DrinkModel.fromJson(element.data()));
        allItems.add(DrinkModel.fromJson(element.data()));
      }
      emit(SuccessGetCoffeeMenu());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorGetCoffeeMenu());
    });
  }

  Future<void> getChocolateMenu() async {
    emit(LoadingGetChocolateMenu());
    await FirebaseFirestore.instance
        .collection('Menu')
        .doc('Sections')
        .collection('Chocolate')
        .get()
        .then((value) {
      for (var element in value.docs) {
        chocolateMenu.add(DrinkModel.fromJson(element.data()));
        allItems.add(DrinkModel.fromJson(element.data()));
      }
      emit(SuccessGetChocolateMenu());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorGetChocolateMenu());
    });
  }

  Future<void> getOthersMenu() async {
    emit(LoadingGetOthersMenu());
    await FirebaseFirestore.instance
        .collection('Menu')
        .doc('Sections')
        .collection('Others')
        .get()
        .then((value) async {
      for (var element in value.docs) {
        othersMenu.add(DrinkModel.fromJson(element.data()));
        allItems.add(DrinkModel.fromJson(element.data()));
      }
      await Future.delayed(const Duration(seconds: 2), () {
        extractTheNewAndRecommendationItem();
      });
      showContent = true;
      emit(SuccessGetOthersMenu());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorGetOthersMenu());
    });
  }

  List<DrinkModel> theListIWant() {
    List<DrinkModel> list = [];
    switch (numberTheScreen) {
      case 1:
        list = coffeeMenu;
        break;
      case 2:
        list = chocolateMenu;
        break;
      case 3:
        list = othersMenu;
        break;
    }
    return list;
  }

  void extractTheNewAndRecommendationItem() {
    for (var item in allItems) {
      if (item.isNew) {
        imagesUrl.add(item.image);
        newItems.add(item);
        newDrinkName.add(item.drinkName);
      }
      if (item.isRecommendation) {
        recommendationItems.add(item);
      }
    }
    allItems.sort((a, b) => b.rate.compareTo(a.rate));
    addColor();
  }

  bool showContent = false;

  Future<void> getAllDrinks() async {
    await getChocolateMenu().then((value) async {
      await getCoffeeMenu().then((value) async {
        await getOthersMenu().then((value) {
          drinkWithMaxNumberOfSold();
        });
      });
    });
  }

  DrinkModel drinkWithMaxNumberOfSold() {
    if (allItems.isNotEmpty) {
      DrinkModel model = allItems
          .reduce((a, b) => a.numberOfTimesSold > b.numberOfTimesSold ? a : b);
      return model;
    }
    return DrinkModel(drinkName: '');
  }

  int numberOfDrinks = 1;

  void increaseTheNumberOfDrinks() {
    numberOfDrinks++;
    emit(IncreaseTheNumberOfDrinks());
  }

  void reduceTheNumberOfDrinks() {
    numberOfDrinks--;
    emit(ReduceTheNumberOfDrinks());
  }

  List<DrinkModel> searchResult = [];

  void findTheDrink(String query) {
    searchResult = [];
    switch (numberTheScreen) {
      case 1:
        searchResult = coffeeMenu.where((drink) {
          return drink.drinkName.contains(query) ||
              drink.drinkName.contains(query.toUpperCase()) ||
              drink.drinkName.contains(query.toLowerCase());
        }).toList();
        break;
      case 2:
        searchResult = chocolateMenu.where((drink) {
          return drink.drinkName.contains(query) ||
              drink.drinkName.contains(query.toUpperCase()) ||
              drink.drinkName.contains(query.toLowerCase());
        }).toList();
        break;
      case 3:
        searchResult = othersMenu.where((drink) {
          return drink.drinkName.contains(query) ||
              drink.drinkName.contains(query.toUpperCase()) ||
              drink.drinkName.contains(query.toLowerCase());
        }).toList();
        break;
    }
    emit(SuccessSearchDrink());
  }

  bool search = false;

  void activeSearch() {
    search = true;
    emit(ActiveSearch());
  }

  void deactivatedSearch() {
    search = false;
    emit(DeactivatedSearch());
  }

  bool isFavorite = false;

  void changeFavoriteState() {
    isFavorite = !isFavorite;
    emit(ChangeFavoriteState());
  }

  Future<void> orderRequest({
    required String address,
    required dynamic totalOfPrice,
  }) async {
    List<Map<String, dynamic>> drinks =
    recently.map(
            (item) {
              OrderRequestModel model = OrderRequestModel(
                drink:item.drink.drinkName ,
                numberOfDrinks: item.numberOfDrinks,
                priceOfDrinks: item.drink.price,
                totalPriceOfDrinks:  item.drink.price * item.numberOfDrinks
              );
             return  model.toMap();
            }
    ).toList();
    emit(LoadingOrderRequest());
    await FirebaseFirestore.instance
        .collection('Orders')
        .doc()
        .set({
      'Address': address,
      'Total of price': totalOfPrice,
      'Order': drinks,
      'Datetime': DateTime.now().toString(),
    })
        .then((value) async {
          await afterSendingTheOrder();
      emit(SuccessOrderRequest());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorOrderRequest());
    });
  }

  Future<void> afterSendingTheOrder() async {
    List<Map<String, dynamic>> orders =
    recently.map(
            (item) {
          DrinkOrderModel model = DrinkOrderModel(
            totalOfPrice:item.totalOfPrice ,
              date:item.date ,
              drink: item.drink ,
              numberOfDrinks: item.numberOfDrinks,
          );
          return  model.toMap();
        }
    ).toList();
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
    .collection('Past orders')
        .add({
      'Orders': orders,
    })
        .then((value) async {
          await getPastOrders();
      emit(SuccessAfterSendingTheOrder());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorAfterSendingTheOrder());
    });

  }


  Future<void> getPastOrders() async {
    pastOrder = [];
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .collection('Past orders')
        .get()
        .then((value) async {
      for (var element in value.docs) {
        for(var i in element.data()['Orders'] ){
          pastOrder.add(DrinkOrderModel.fromJson(i));
        }
      }
      emit(SuccessGetPastOrders());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorGetPastOrders());
    });
  }


  Future<void> increaseTheNumberOfDrinkSales(List <DrinkOrderModel> drinks) async {
    for(var item in drinks){
      await FirebaseFirestore.instance
          .collection('Menu')
          .doc('Sections')
          .collection(item.drink.category)
          .doc(item.drink.drinkName)
          .update({
        'Number of times sold': FieldValue.increment(item.numberOfDrinks),
      })
          .then((value) async {
        await getPastOrders();
        emit(SuccessIncreaseTheNumberOfDrinkSales());
      }).catchError((error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(ErrorIncreaseTheNumberOfDrinkSales());
      });
    }
  }


}
