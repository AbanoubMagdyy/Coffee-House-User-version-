import 'package:coffee_house/components/components.dart';
import 'package:coffee_house/models/drink_order_model.dart';
import 'package:coffee_house/screens/order_request_screen.dart';
import 'package:coffee_house/shared/app_bloc/cubit.dart';
import 'package:coffee_house/shared/app_bloc/states.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../components/constants.dart';
import '../../components/items.dart';
import '../../style/colors.dart';

class OrderScreen extends StatelessWidget {
  final int numberTheScreen;
  final double minHeightForButton = 400;
  final double minWidthForSlider = 330;
  dynamic subtotal = 0;

  OrderScreen(
    this.numberTheScreen, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppCubit.get(context).numberTheScreen = numberTheScreen;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        List<DateTime> getUniqueDates() {
          return cubit.pastOrder
              .map((message) => DateTime(
                  message.date.year, message.date.month, message.date.day))
              .toSet()
              .toList();
        }

        List<DrinkOrderModel> getMessagesForDate(DateTime date) {
          return cubit.pastOrder
              .where((message) =>
                  DateTime(message.date.year, message.date.month,
                      message.date.day) ==
                  date)
              .toList();
        }

        List<DateTime> uniqueDates = getUniqueDates();

        return Scaffold(
          body: SafeArea(
            child: LayoutBuilder(
                builder: (context,constraints) {
                  final double availableHeight = constraints.maxHeight;
                  final double availableWidth = constraints.maxWidth;
                  return Column(
                  children: [
                    /// slider and items
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 10.0, right: 15, left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// slider
                            if(availableWidth > minWidthForSlider)
                            Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                color: defColor,
                                border: Border.all(color: secColor),
                                borderRadius: BorderRadiusDirectional.circular(10),
                              ),
                              child: CustomSlidingSegmentedControl<int>(
                                padding: 30,
                                initialValue: numberTheScreen,
                                innerPadding: EdgeInsets.zero,
                                children: {
                                  1: Text(
                                    'Recently',
                                    style: TextStyle(
                                      color: cubit.numberTheScreen == 1
                                          ? defColor
                                          : secColor,
                                    ),
                                  ),
                                  2: Text(
                                    'Past Orders',
                                    style: TextStyle(
                                      color: cubit.numberTheScreen == 2
                                          ? defColor
                                          : secColor,
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

                            /// items
                            Expanded(
                              child: Visibility(
                                visible: cubit.numberTheScreen == 1,

                                /// past orders
                                replacement: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: cubit.pastOrder.length,
                                    itemBuilder: (context, index) {
                                      if (index >= uniqueDates.length) {
                                        return const SizedBox
                                            .shrink(); // Return an empty widget if index is out of bounds
                                      }
                                      DateTime date = uniqueDates[index];
                                      List<DrinkOrderModel> messagesForDate =
                                          getMessagesForDate(date);
                                      return Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            decoration: BoxDecoration(
                                              color: defColor,
                                              border: Border.all(color: secColor),
                                              borderRadius:
                                                  BorderRadiusDirectional.circular(
                                                      10),
                                            ),
                                            child: defText(
                                              text: formatDate(date),
                                            ),
                                          ),
                                          ...messagesForDate.map(
                                            (e) => orderItem(e),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      );
                                    }),

                                /// recently
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: recently.length,
                                  itemBuilder: (context, index) =>
                                      Dismissible(
                                        background: Container(
                                          margin: const EdgeInsetsDirectional.only(
                                            top: 10,
                                          ),
                                          padding: const EdgeInsetsDirectional.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            border: Border.all(color: secColor, width: 2),
                                            borderRadius: BorderRadiusDirectional.circular(20),
                                          ),
                                          child: const Icon(Icons.delete_outline),
                                        ),
                                          key: ValueKey<DrinkOrderModel>(recently[index]),
                                          child: orderItem(recently[index]),
                                        onDismissed: (direction){
                                          recently.removeAt(index);
                                        },
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (cubit.numberTheScreen == 1 && recently.isNotEmpty && availableHeight > minHeightForButton)
                      /// order now button
                      GestureDetector(
                        onTap: () {
                          subtotal = 0;
                          for (var drink in recently) {
                            subtotal = subtotal + drink.totalOfPrice;
                          }
                          navigateTo(context, OrderRequestScreen(subtotal));
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: secColor,
                            borderRadius: BorderRadiusDirectional.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          padding: const EdgeInsets.all(25),
                          child: Container(
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: defColor,
                                borderRadius: BorderRadiusDirectional.circular(15),
                              ),
                              child: Center(child: defText(text: 'Order now'))),
                        ),
                      ),
                  ],
                );
              }
            ),
          ),
        );
      },
    );
  }

  String formatDate(DateTime date) {
    DateTime now = DateTime.now();
    var formattedDate = DateFormat('MMM d, yyyy').format(date);

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    } else if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day - 1) {
      return 'Yesterday';
    } else {
      return formattedDate;
    }
  }
}
