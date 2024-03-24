import 'package:coffee_house/components/components.dart';
import 'package:coffee_house/models/user_model.dart';
import 'package:coffee_house/shared/profile_bloc/cubit.dart';
import 'package:coffee_house/shared/profile_bloc/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../style/colors.dart';
import 'models/address_model.dart';

class Tests extends StatefulWidget {
  final UserModel model;

  const Tests(this.model, {Key? key}) : super(key: key);

  @override
  State<Tests> createState() => _TestsState();
}

class _TestsState extends State<Tests> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  List<TextEditingController> controllers = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ProfileCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            titleSpacing: 0,
            backgroundColor: backgroundColor,
            leading: const Icon(Icons.arrow_back, color: secColor),
            title: defText(text: 'Test'),
            actions: [
              InkWell(
                onTap: () {
                  cubit.sendAddressesToFirebase();
                  // addresses = [];
                  // for (var element in controllers) {
                  //   addresses.add(element.text);
                  // }
                  // cubit.updateUserAddresses(addresses: addresses);
                },
                child: Container(
                  padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 15),
                  margin: const EdgeInsets.only(right: 10, top: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(30),
                      border: Border.all(color: secColor, width: 2)),
                  child: Row(
                    children: [
                      const Icon(Icons.save, color: secColor),
                      defText(text: 'Save & Edit Addresses', fontSize: 15)
                    ],
                  ),
                ),
              )
            ],
          ),
          body: Visibility(
            visible:
                controllers.isNotEmpty || widget.model.addresses.isNotEmpty,
            replacement: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Column(
                  children: [
                    const Expanded(
                      child: Icon(
                        Icons.location_on_outlined,
                        size: 300,
                        color: secColor,
                      ),
                    ),
                    defText(
                      text:
                          'There is no registered addresses here. If you want to add a address,\n click the add button',
                    ),
                    const SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  /// addresses
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) =>
                          addressItem(cubit.addresses[index], index, context),
                      itemCount: cubit.addresses.length,
                    ),
                  ),

                  /// add icon and text
                  Container(
                    margin: const EdgeInsets.all(8),
                    height: 70,
                    child: Row(
                      children: [
                        /// text
                        Expanded(
                          child: defText(
                            maxLines: 4,
                            fontSize: 15,
                            text:
                                'Don\'t forget that when adding or edit the address, you must press the Save & Edit Addresses button for the modification to be saved.',
                          ),
                        ),

                        /// add icon
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: secColor,
                          child: IconButton(
                            onPressed: () {
                              addressBottomSheet(
                                onTap: () {
                                  if (addressController.text.isEmpty) {
                                    Navigator.pop(context);
                                  } else {
                                    AddressModel model = AddressModel(
                                        title: titleController.text,
                                        address: addressController.text);
//                                              controllers = [];
                                    cubit.setNewAddress(model);
                                    Navigator.pop(context);
                                    addressController.clear();
                                    titleController.clear();
                                  }
                                },
                                title: titleController,
                                address: addressController,
                              );
                            },
                            icon: const Icon(
                              Icons.add,
                              size: 35,
                              color: defColor,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget textFieldItem(
          {required String title,
          required TextEditingController controller,
          bool enabled = true}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            defText(
                text: title, textColor: secColor.withOpacity(0.6), maxLines: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: TextFormField(
              enabled: enabled,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter some information';
                }
                return null;
              },
              controller: controller,
              style: const TextStyle(color: secColor),
              decoration: InputDecoration(
                  hintStyle: const TextStyle(color: secColor),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
          ),
        ],
      );

  Widget addressItem(AddressModel model, index, context) =>
      Builder(builder: (context) {
        final TextEditingController addressController =
            TextEditingController(text: model.address);
        final TextEditingController titleController =
        TextEditingController(text: model.title);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: textFieldItem(
                  title: model.title, controller: addressController, enabled: false),
            ),

            /// edit icon
            Container(
              height: 70,
              width: 60,
              margin: const EdgeInsets.only(left: 8, bottom: 8),
              decoration: BoxDecoration(
                color: secColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: IconButton(
                onPressed: () {
                  addressBottomSheet(onTap: (){
                    if(addressController.text.isNotEmpty){
                      ProfileCubit.get(context).updateAddress(index: index, address: addressController.text, title: titleController.text);
                      Navigator.pop(context);
                    }else{
                      Navigator.pop(context);

                    }
                  }, title: titleController, address: addressController);
                },
                icon: const Icon(
                  Icons.edit,
                  color: defColor,
                ),
              ),
            ),

            /// close icon
            Container(
              height: 70,
              width: 60,
              margin: const EdgeInsets.only(left: 8, bottom: 8),
              decoration: BoxDecoration(
                color: secColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: IconButton(
                onPressed: () {
                  ProfileCubit.get(context).removeAddress(index);
                },
                icon: const Icon(
                  Icons.delete,
                  color: defColor,
                ),
              ),
            ),
          ],
        );
      });

  void addressBottomSheet({
    required void Function() onTap,
    required TextEditingController title,
    required TextEditingController address,
  }) =>
      showModalBottomSheet(
        context: context,
        backgroundColor: defColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(50),
          ),
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  textFieldItem(controller: title, title: 'Title'),
                  textFieldItem(controller: address, title: 'Address'),
                  defButton(
                    onTap: onTap,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.done, color: defColor),
                        defText(text: 'Done', textColor: defColor)
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
}
