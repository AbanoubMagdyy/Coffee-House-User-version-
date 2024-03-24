import 'package:coffee_house/shared/profile_bloc/cubit.dart';
import 'package:coffee_house/shared/profile_bloc/states.dart';
import 'package:coffee_house/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../components/components.dart';
import '../../components/constants.dart';
import '../../models/massage_model.dart';

class SupportScreen extends StatelessWidget {
  final double minHeightForHelloMassage = 390;
  final double minWidthForHelloMassage = 410;
  final TextEditingController messageController = TextEditingController();
  final ScrollController controller = ScrollController();


  SupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ProfileCubit.get(context);
        List<DateTime> getUniqueDates() {
          return cubit.messages
              .map((message) => DateTime(message.dateTime.year,
              message.dateTime.month, message.dateTime.day))
              .toSet()
              .toList();
        }

        List<MessageModel> getMessagesForDate(DateTime date) {
          return cubit.messages
              .where((message) =>
          DateTime(message.dateTime.year, message.dateTime.month,
              message.dateTime.day) ==
              date)
              .toList();
        }

        List<DateTime> uniqueDates = getUniqueDates();
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: defAppBar(context, 'Support'),
          body: LayoutBuilder(builder: (context, constraints) {
            final double availableHeight = constraints.maxHeight;
            final double availableWidth = constraints.maxWidth;
            return Column(
              children: [
                /// How can we help you Today text and icon
                if (availableHeight > minHeightForHelloMassage &&
                    availableWidth > minWidthForHelloMassage)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: secColor,
                          radius: 30,
                          child: Icon(
                            Icons.chat,
                            size: 25,
                            color: defColor,
                          ),
                        ),
                        defText(text: 'How can we help you Today?')
                      ],
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
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        /// massages
                        Expanded(
                          child: ListView.builder(
                            controller: controller,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                if (index >= uniqueDates.length) {
                                  return const SizedBox
                                      .shrink(); // Return an empty widget if index is out of bounds
                                }
                                DateTime date = uniqueDates[index];
                                List<MessageModel> messagesForDate =
                                getMessagesForDate(date);
                                return Column(
                                  children: [
                                    /// date
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      decoration: BoxDecoration(
                                        color: secColor,
                                        border: Border.all(color: defColor),
                                        borderRadius:
                                        BorderRadiusDirectional.circular(
                                            10),
                                      ),
                                      child: defText(
                                        text: formatDate(date),
                                        textColor: defColor
                                      ),
                                    ),
                                /// messages
                                ...messagesForDate.map(
                                (message) => Visibility(
                                visible: message.email == email,
                                replacement: supportMassage(message),
                                child: myMassage(message),
                                ),
                                )
                                  ],
                                );
                                },
                              itemCount: cubit.messages.length,
                          ),
                        ),
                        /// text field and send icon
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              /// text  field
                              Expanded(
                                child: Container(
                                  height: 55,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: secColor,
                                  ),
                                  padding:
                                      const EdgeInsetsDirectional.symmetric(
                                          horizontal: 10),
                                  child: TextFormField(
                                    controller: messageController,
                                    style: const TextStyle(
                                      color: defColor,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'type your massage..',
                                      hintStyle: TextStyle(
                                        color: defColor.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              /// send massage icon
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                padding: const EdgeInsetsDirectional.all(5),
                                decoration: BoxDecoration(
                                  color: secColor,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    if(messageController.text.isNotEmpty){
                                      cubit.sendMessage(message: messageController.text);
                                      messageController.clear();
                                      controller.animateTo(
                                        controller.position.maxScrollExtent,
                                        duration: const Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.send_outlined,
                                    size: 25,
                                    color: defColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }

  Widget myMassage(MessageModel message) => Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            decoration: const BoxDecoration(
              color: secColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                topLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            padding: const EdgeInsetsDirectional.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsetsDirectional.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.4),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      message.message,
                      style: const TextStyle(color: defColor),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 5),
                  child: Text(message.time,
                      style: TextStyle(
                        color: defColor.withOpacity(.6),
                      )),
                ),
              ],
            ),
          ),
        ),
      );

  Widget supportMassage(MessageModel messageModel) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.topRight,
          child: Container(
            decoration: const BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
            ),
            padding: const EdgeInsetsDirectional.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                    padding: const EdgeInsetsDirectional.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.4),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      messageModel.message,
                      style: const TextStyle(color: secColor),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 5),
                  child: Text(messageModel.time,
                      style: TextStyle(
                        color: secColor.withOpacity(.4),
                      )),
                ),
              ],
            ),
          ),
        ),
      );

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
