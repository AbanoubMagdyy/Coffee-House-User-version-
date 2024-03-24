import 'package:coffee_house/components/components.dart';
import 'package:coffee_house/components/items.dart';
import 'package:coffee_house/screens/settings_screens/manage_addresses_screen.dart';
import 'package:coffee_house/shared/profile_bloc/cubit.dart';
import 'package:coffee_house/shared/profile_bloc/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../components/constants.dart';
import '../shared/app_bloc/cubit.dart';
import '../shared/app_bloc/states.dart';
import '../style/colors.dart';

class OrderRequestScreen extends StatefulWidget {
  final dynamic subtotal;

  const OrderRequestScreen(this.subtotal, {Key? key}) : super(key: key);

  @override
  State<OrderRequestScreen> createState() => _OrderRequestScreenState();
}

class _OrderRequestScreenState extends State<OrderRequestScreen> {
  final addressController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final double minHeightForDeliverToSection = 530;
  final double minWidthForCreateFirstAddressButton = 340;
  final double minWidthForChooseAddressButton = 400;
  final double minHeightForClosedCafeSection = 735;
  final double minHeightForOrderRequestSection= 360;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is SuccessOrderRequest) {
          AppCubit.get(context).increaseTheNumberOfDrinkSales(recently);
          recently = [];
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          body: LayoutBuilder(
              builder: (context,constraints) {
                final double availableHeight = constraints.maxHeight;
                final double availableWidth = constraints.maxWidth;
                print(availableHeight.toInt());
                return SafeArea(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state is LoadingOrderRequest ||
                          state is SuccessAfterSendingTheOrder ||
                          state is SuccessGetPastOrders)
                        defLinearProgressIndicator(),

                      /// closest cafe section
                      if(availableHeight > minHeightForClosedCafeSection)
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// icon and title
                            Row(
                              children: [
                                const Icon(
                                  Icons.directions,
                                  color: Colors.blue,
                                  size: 30,
                                ),
                                defText(text: 'Closest cafe:')
                              ],
                            ),

                            /// branch name
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: defText(
                                  text: '$appName Cairo (1.5 km)', fontSize: 15),
                            ),

                            /// address
                            defText(
                                text: '23 st. Ahmed saad, Khalfawe, Cairo',
                                fontSize: 15),
                            /// line
                            defLine(),
                          ],
                        ),
                      ),


                      if(availableHeight > minHeightForDeliverToSection)
                      /// deliver to
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            /// icon and title
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_sharp,
                                  color: Colors.red,
                                  size: 30,
                                ),
                                defText(text: 'Deliver to:')
                              ],
                            ),

                            /// address and choose address
                            BlocConsumer<ProfileCubit, ProfileStates>(
                              listener: (context, state) {},
                              builder: (context, state) {
                                var cubit = ProfileCubit.get(context);
                                return Row(
                                  children: [
                                    /// text field
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: defTextFormField(
                                            maxLines: 2,
                                            controller: addressController,
                                            text: 'Please choose your address',
                                            enabled: false),
                                      ),
                                    ),

                                    /// choose address
                                    if (cubit.addresses.isNotEmpty && availableWidth>minWidthForChooseAddressButton)
                                      Container(
                                        width: 350,
                                        padding: const EdgeInsets.only(
                                          left: 5,
                                        ),
                                        child: DropdownButtonFormField(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: const BorderSide(
                                                    color: secColor),
                                              ),
                                            ),
                                            dropdownColor: backgroundColor,
                                            borderRadius: BorderRadius.circular(20),
                                            hint: FittedBox(
                                              child: defText(
                                                text: 'Your address',
                                                fontSize: 14,
                                              ),
                                            ),
                                            items: cubit.addresses.map((e) {
                                              return DropdownMenuItem(
                                                  value: e.address,
                                                  child: SizedBox(
                                                    width: 280,
                                                    child: defText(
                                                        text: e.title.isNotEmpty
                                                            ? e.title
                                                            : e.address,
                                                        fontSize: 12,
                                                        maxLines: 1),
                                                  ));
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                addressController.text = value!;
                                              });
                                            }),
                                      ),
                                    if (cubit.addresses.isEmpty && availableWidth > minWidthForCreateFirstAddressButton)
                                      InkWell(
                                        onTap: () => navigateTo(
                                          context,
                                          ManageAddressesScreen(
                                              cubit.userInformation!),
                                        ),
                                        child: Container(
                                            width: 250,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadiusDirectional.circular(
                                                      20),
                                              border: Border.all(color: secColor),
                                            ),
                                            padding: const EdgeInsets.all(15),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: defText(
                                                      text: 'Create first address',
                                                      fontSize: 14),
                                                ),
                                                const Icon(
                                                  Icons.add,
                                                  color: secColor,
                                                ),
                                              ],
                                            )),
                                      ),
                                  ],
                                );
                              },
                            ),

                          ],
                        ),
                      ),
                      /// line
                      defLine(height: 20),

                      defText(text: 'Your order:'),
                      const SizedBox(
                        height: 8,
                      ),

                      /// your order
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) =>
                              orderRequestItem(recently[index]),
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 8,
                          ),
                          itemCount: recently.length,
                        ),
                      ),

                      /// order request section
                      if(availableHeight > minHeightForOrderRequestSection)
                      Container(
                        decoration: BoxDecoration(
                          color: defColor,
                          borderRadius: const BorderRadiusDirectional.vertical(
                            top: Radius.circular(25),
                          ),
                          border: Border.all(color: secColor),
                        ),
                        padding:
                            const EdgeInsets.only(top: 15, left: 20, right: 20),
                        child: Column(
                          children: [
                            /// subtotal
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                              child: Row(
                                children: [
                                  defText(
                                      text: 'Subtotal',
                                      textColor: secColor.withOpacity(0.7)),
                                  const Spacer(),
                                  defText(
                                      text: '${widget.subtotal} E.P',
                                      textColor: secColor.withOpacity(0.7)),
                                ],
                              ),
                            ),

                            /// delivery
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                              child: Row(
                                children: [
                                  defText(
                                      text: 'Delivery',
                                      textColor: secColor.withOpacity(0.7)),
                                  const Spacer(),
                                  defText(
                                      text: '$priceOfDelivery E.P',
                                      textColor: secColor.withOpacity(0.7)),
                                ],
                              ),
                            ),

                            /// total
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                              child: Row(
                                children: [
                                  defText(
                                    text: 'Total',
                                  ),
                                  const Spacer(),
                                  defText(
                                      text:
                                          '${widget.subtotal + priceOfDelivery} E.P'),
                                ],
                              ),
                            ),

                            /// order now button
                            GestureDetector(
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  cubit.orderRequest(
                                      address: addressController.text,
                                      totalOfPrice:
                                          widget.subtotal + priceOfDelivery);
                                }
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: secColor,
                                  borderRadius: BorderRadiusDirectional.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                padding: const EdgeInsets.all(15),
                                child: Container(
                                    height: 50,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: addressController.text.isNotEmpty
                                          ? defColor
                                          : defColor.withOpacity(0.5),
                                      borderRadius:
                                          BorderRadiusDirectional.circular(15),
                                    ),
                                    child: Center(
                                      child: defText(text: 'Order now'),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          ),
        );
      },
    );
  }
}
