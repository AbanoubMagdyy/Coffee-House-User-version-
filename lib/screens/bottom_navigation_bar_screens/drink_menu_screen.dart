import 'package:coffee_house/components/components.dart';
import 'package:coffee_house/shared/app_bloc/cubit.dart';
import 'package:coffee_house/shared/app_bloc/states.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/items.dart';
import '../../style/colors.dart';

class DrinkMenuScreen extends StatelessWidget {
  final double minHeightForSearch = 490;
  final double minHeightForSlider = 200;
  final TextEditingController searchController = TextEditingController();

  DrinkMenuScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppCubit.get(context).numberTheScreen = 1;
    AppCubit.get(context).searchResult = AppCubit.get(context).coffeeMenu ;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        var cubit = AppCubit.get(context);
        if(state is ChangeSlider){
          switch (cubit.numberTheScreen){
            case 1 :
             cubit.searchResult = cubit.coffeeMenu;
              break ;
            case 2 :
              cubit.searchResult = cubit.chocolateMenu;
              break ;
            case 3 :
              cubit.searchResult = cubit.othersMenu;
              break ;
          }
        }
        if(state is ChangeCurrentIndex){
          cubit.search = false;
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Visibility(
          visible: state is! LoadingGetCoffeeMenu,
          replacement: leading(),
          child: LayoutBuilder(
              builder: (context,constraints) {
                final double availableHeight = constraints.maxHeight;
                return Column(
                children: [
                  /// search field and close icon
                  if(availableHeight > minHeightForSearch)
                  Row(
                    children: [
                      /// search field
                      Expanded(
                        child: Container(
                          margin: const EdgeInsetsDirectional.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: defColor,
                            border: Border.all(color: secColor),
                          ),
                          padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
                          child: TextFormField(
                            readOnly: cubit.search ? false : true,
                            onTap: () =>cubit.activeSearch(),
                             onChanged: (value)=>cubit.findTheDrink(value),
                            controller: searchController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search..',
                              hintStyle: TextStyle(
                                color: secColor.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if(cubit.search)
                      /// close icon
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: secColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: IconButton(
                          onPressed: () {
                            searchController.clear();
                            cubit.deactivatedSearch();
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  /// slider
                  if(availableHeight > minHeightForSlider)
                    Container(
                    margin: const EdgeInsetsDirectional.all(25),
                    decoration: BoxDecoration(
                      color: defColor,
                      border: Border.all(color: secColor),
                      borderRadius: BorderRadiusDirectional.circular(10),
                    ),
                    child: CustomSlidingSegmentedControl<int>(
                      initialValue: 1,
                      innerPadding: EdgeInsets.zero,
                      isStretch: true,
                      children: {
                        1: FittedBox(
                          child: Text(
                            'Coffee',
                            style: TextStyle(
                              color: cubit.numberTheScreen == 1 ? defColor : secColor,
                            ),
                          ),
                        ),
                        2: Row(
                              children: [
                                Container(
                                  width: 2,
                                  height: 30,
                                  color: secColor,
                                ),
                                Expanded(
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    'Chocolate',
                                    style: TextStyle(
                                      color: cubit.numberTheScreen == 2
                                          ? defColor
                                          : secColor,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 2,
                                  height: 30,
                                  color: secColor,
                                ),
                              ],
                            ),
                        3: FittedBox(
                          child: Text(
                            'Others',
                            style: TextStyle(
                              color: cubit.numberTheScreen == 3 ? defColor : secColor,
                            ),
                          ),
                        ),
                      },
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      thumbDecoration: BoxDecoration(
                        color: secColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutSine,
                      onValueChanged: (v) {
                        cubit.changeSlider(v);
                      },
                    ),
                  ),
                  /// body
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: defColor,
                        borderRadius: const BorderRadiusDirectional.vertical(
                          top: Radius.circular(40),
                        ),
                        border: Border.all(color: secColor),
                      ),
                      padding: const EdgeInsets.only(top: 8, left: 20, right: 20),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => drinkItem(
                            model: cubit.search
                                ? cubit.searchResult[index]
                                : cubit.theListIWant()[index],
                        ),
                        itemCount: cubit.search
                            ? cubit.searchResult.length
                            : cubit.theListIWant().length,
                      ),
                    ),
                  ),

                ],
              );
            }
          ),
        );
      },
    );
  }
}
