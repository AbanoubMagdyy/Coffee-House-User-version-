import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_house/models/drink_model.dart';
import 'package:coffee_house/models/drink_order_model.dart';
import 'package:coffee_house/shared/app_bloc/cubit.dart';
import 'package:coffee_house/shared/app_bloc/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../shared/profile_bloc/cubit.dart';
import '../style/colors.dart';
import 'components.dart';
import 'constants.dart';

Widget recommendationItem(DrinkModel model, context) => GestureDetector(
      onTap: () => bottomSheet(context, model),
      child: Container(
        width: 200,
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsetsDirectional.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(20),
        ),
        child: Stack(
          children: [
            /// image

            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                /// image

                Container(
                  height: 248,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(model.image),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),

                /// shadow

                Container(
                  height: 130.0,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [
                        secColor.withOpacity(0.8),
                        secColor.withOpacity(0.5),
                        secColor.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            /// title and price

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  /// title

                  defText(
                      text: model.drinkName,
                      textColor: const Color(0xfff8e3b6)),

                  const SizedBox(height: 8),

                  /// price

                  defText(
                      text: '${model.price} E.B',
                      textColor: const Color(0xfff8e3b6)),
                ],
              ),
            )
          ],
        ),
      ),
    );

Widget popularMenuItem(DrinkModel model) => LayoutBuilder(
      builder: (context, constraints) {
        const double minWidthForImage = 390;
        final double availableWidth = constraints.maxWidth;

        return GestureDetector(
          onTap: () => bottomSheet(context, model),
          child: Container(
            margin: const EdgeInsetsDirectional.all(
              10,
            ),
            padding: const EdgeInsetsDirectional.all(15),
            decoration: BoxDecoration(
              color: secColor,
              borderRadius: BorderRadiusDirectional.circular(20),
            ),
            child: Row(
              children: [
                /// image
                if (availableWidth > minWidthForImage)
                  Container(
                    height: 150,
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsetsDirectional.only(
                      end: 15,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(20)),
                    child: networkImage(model.image, width: 150),
                  ),

                /// name and description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// name
                      FittedBox(
                          child: defText(
                              text: model.drinkName, textColor: defColor)),

                      /// description
                      defText(
                          text: model.description,
                          textColor: defColor.withOpacity(0.5)),
                    ],
                  ),
                ),

                defText(text: '${model.price} E.P', textColor: defColor),
              ],
            ),
          ),
        );
      },
    );

Widget drinkItem({
  required DrinkModel model,
}) =>
    LayoutBuilder(builder: (context, constraints) {
      const double minWidthForImage = 380;
      final double availableWidth = constraints.maxWidth;
      return Container(
        margin: const EdgeInsets.only(bottom: 15),
        height: 230,
        child: Row(
          children: [
            /// image
            if (availableWidth > minWidthForImage)
              Container(
                height: 220,
                width: 150,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: secColor.withOpacity(0.6),
                      blurRadius: 2,
                      offset:
                          const Offset(0, 4), // Offset (horizontal, vertical)
                    ),
                  ],
                ),
                child: networkImage(
                  model.image,
                ),
              ),

            /// title and description and price
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    defText(text: model.drinkName, fontSize: 20),
                    defText(
                        text: model.description,
                        textColor: secColor.withOpacity(0.6)),
                    defText(text: '${model.price} E.P', fontSize: 20),
                  ],
                ),
              ),
            ),

            /// add icon
            Container(
              decoration: BoxDecoration(
                color: secColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: IconButton(
                onPressed: () => bottomSheet(context, model),
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      );
    });

Widget orderItem(DrinkOrderModel model) => LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth;
        const double minWidthForImage = 350;
        return Container(
          height: 210,
          margin: const EdgeInsetsDirectional.only(
            top: 10,
          ),
          padding: const EdgeInsetsDirectional.all(10),
          decoration: BoxDecoration(
            color: defColor,
            border: Border.all(color: secColor, width: 2),
            borderRadius: BorderRadiusDirectional.circular(20),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// image
              if (availableWidth > minWidthForImage)
                Container(
                  height: 190,
                  width: 150,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: secColor.withOpacity(0.6),
                        blurRadius: 8,
                        offset: const Offset(
                          0,
                          4,
                        ), // Offset (horizontal, vertical)
                      ),
                    ],
                  ),
                  child: networkImage(model.drink.image),
                ),

              /// number of drink and name drink
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ///  number of drink and name drink
                    Row(
                      children: [
                        ///  number of drink
                        defText(text: '${model.numberOfDrinks}X'),
                        const SizedBox(
                          width: 15,
                        ),

                        /// name drink
                        Expanded(child: defText(text: model.drink.drinkName)),
                      ],
                    ),
                    const Spacer(),
                    defText(
                      text: 'Details',
                    ),
                  ],
                ),
              ),

              /// date
              // defText(text: '${model.date.day}/${model.date.month}'),
            ],
          ),
        );
      },
    );

Widget favoriteDrinkItem(DrinkModel model) =>
    LayoutBuilder(builder: (context, constraints) {
      final double availableWidth = constraints.maxWidth;
      const double minWidthForPriceAndIcon = 120;
      return GestureDetector(
        onTap: () => bottomSheet(context, model),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            /// image
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: secColor.withOpacity(0.6),

                    blurRadius: 8,

                    offset: const Offset(
                      0,
                      4,
                    ), // Offset (horizontal, vertical)
                  ),
                ],
                borderRadius: BorderRadiusDirectional.circular(15),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(model.image),
                  fit: BoxFit.fill,
                ),
              ),
            ),

            /// shadow
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    secColor.withOpacity(0.8),
                    secColor.withOpacity(0.3),
                    Colors.transparent,
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            /// icon and price and drink name

            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// drink name
                FittedBox(
                  child: defText(
                    text: model.drinkName,
                    textColor: defColor,
                  ),
                ),
                /// price and favorite icon
                if(availableWidth > minWidthForPriceAndIcon)
                Row(
                  children: [
                    /// price

                    Expanded(
                      child: defText(
                        text: '${model.price.toString()} E.B',
                        textColor: defColor,
                      ),
                    ),

                    /// favorite icon

                    IconButton(
                      onPressed: () =>
                          ProfileCubit.get(context).removeFavoriteDrink(model),
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 35,
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      );
    });

Widget bottomSheetItem(DrinkModel model) => LayoutBuilder(
  builder: (context, constraints) {
      final double availableHeight = constraints.maxHeight;
      const double minHeightForFavoriteAndCloseIcons = 330;
      const double minHeightForWidgetToWorking = 285;
      const double minHeightForDescription = 415;
      AppCubit.get(context).numberOfDrinks = 1;
        List isFavorite = ProfileCubit.get(context)
            .favorites
            .where((drink) => drink.drinkName.contains(model.drinkName))
            .toList();
        if (isFavorite.isEmpty) {
          AppCubit.get(context).isFavorite = false;
        } else {
          AppCubit.get(context).isFavorite = true;
        }
        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = AppCubit.get(context);
            DrinkOrderModel drink = DrinkOrderModel(
                totalOfPrice: cubit.numberOfDrinks * model.price,
                drink: model,
                numberOfDrinks: cubit.numberOfDrinks,
                date: DateTime.now());
            List<DrinkOrderModel> foundModels = recently
                .where((orderModel) =>
                    orderModel.drink.drinkName == model.drinkName)
                .toList();
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                /// background image
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: double.infinity,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadiusDirectional.vertical(
                      top: Radius.circular(35),
                    ),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(model.image),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                /// shadow
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.white.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                /// body
                if(availableHeight > minHeightForWidgetToWorking)
                Container(
                  padding: const EdgeInsetsDirectional.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// favorite and close icon
                      if(availableHeight > minHeightForFavoriteAndCloseIcons)
                      Row(
                        children: [
                          /// close icon
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.close,
                              size: 40,
                              color: defColor,
                            ),
                          ),
                          const Spacer(),

                          /// favorite icon
                          IconButton(
                            onPressed: () {
                              if (cubit.isFavorite) {
                                ProfileCubit().removeFavoriteDrink(model);
                              } else {
                                ProfileCubit().setFavoriteDrink(model);
                              }
                              cubit.changeFavoriteState();
                            },
                            icon: Icon(
                              cubit.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              size: 40,
                              color: cubit.isFavorite ? Colors.red : defColor,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      /// drink name and price and description
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            defText(
                              text: model.drinkName,
                              fontSize: 20,
                            ),

                            /// description
                            if(availableHeight > minHeightForDescription)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15.0),
                              child: defText(
                                text: model.description,
                                textColor: secColor.withOpacity(0.6),
                              ),
                            ),


                            /// price and favorite icon

                            defText(
                              text: '${model.price} E.P',
                              fontSize: 20,
                            ),
                          ],
                        ),
                      ),

                      /// add or subtract icons
                      Row(
                        children: [
                          /// subtract
                          Container(
                            decoration: BoxDecoration(
                              color: cubit.numberOfDrinks > 0
                                  ? secColor
                                  : secColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                if (cubit.numberOfDrinks > 0) {
                                  cubit.reduceTheNumberOfDrinks();
                                }
                              },
                            ),
                          ),

                          /// number of drinks
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child:
                                defText(text: cubit.numberOfDrinks.toString()),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: secColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              onPressed: () =>
                                  cubit.increaseTheNumberOfDrinks(),
                            ),
                          ),
                        ],
                      ),

                      /// add now button and favorite icon
                      Row(
                        children: [
                          /// favorite icon
                          if(availableHeight < minHeightForFavoriteAndCloseIcons)
                            IconButton(
                            onPressed: () {
                              if (cubit.isFavorite) {
                                ProfileCubit().removeFavoriteDrink(model);
                              } else {
                                ProfileCubit().setFavoriteDrink(model);
                              }
                              cubit.changeFavoriteState();
                            },
                            icon: Icon(
                              cubit.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              size: 40,
                              color: cubit.isFavorite ? Colors.red : defColor,
                            ),
                          ),
                          const Spacer(),
                          /// add now button
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              padding: const EdgeInsetsDirectional.symmetric(
                                  vertical: 5, horizontal: 25),
                              margin: const EdgeInsetsDirectional.only(
                                  bottom: 20, top: 10),
                              decoration: BoxDecoration(
                                color: cubit.numberOfDrinks != 0
                                    ? secColor
                                    : secColor.withOpacity(0.5),
                                borderRadius: BorderRadiusDirectional.circular(15),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  if (cubit.numberOfDrinks != 0) {
                                    if (foundModels.isEmpty) {
                                      recently.add(drink);
                                    } else {
                                      recently.removeWhere((model) =>
                                          model.drink.drinkName ==
                                          drink.drink.drinkName);
                                      recently.add(drink);
                                    }
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text(
                                  foundModels.isNotEmpty
                                      ? 'This drink has already been added. If you want more, select the number you want and then click here'
                                      : 'Add Now',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );

Widget orderRequestItem(DrinkOrderModel model) =>
    LayoutBuilder(builder: (context, constraints) {
      final double availableWidth = constraints.maxWidth;
      const double minWidthForTotal = 245;
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// number Of Drinks
          defText(
            text: '${model.numberOfDrinks}X',
            fontSize: 15,
            textColor: secColor.withOpacity(0.5),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// drink Name
              defText(
                text: model.drink.drinkName,
                fontSize: 15,
                textColor: secColor.withOpacity(0.5),
              ),
              Row(
                children: [
                  defText(
                    text: '${model.drink.price} E.P',
                    fontSize: 15,
                    textColor: secColor.withOpacity(0.5),
                  ),

                  /// total
                  if (availableWidth > minWidthForTotal)
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: defText(
                        text: 'Total' '  ${model.totalOfPrice} E.P' '',
                        fontSize: 15,
                        textColor: secColor.withOpacity(0.5),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      );
    });

