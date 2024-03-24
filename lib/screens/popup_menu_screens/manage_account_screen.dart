import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_house/components/components.dart';
import 'package:coffee_house/shared/profile_bloc/cubit.dart';
import 'package:coffee_house/shared/profile_bloc/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user_model.dart';
import '../../style/colors.dart';

class ManageAccountScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final UserModel model;
   ManageAccountScreen(this.model,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    nameController.text = model.name;
    emailController.text = model.email;
    phoneNumberController.text = model.phoneNumber;
    return BlocConsumer<ProfileCubit, ProfileStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = ProfileCubit.get(context);
          return Scaffold(
            appBar: defAppBar(context, 'Manage Account'),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    if(state is LoadingUpdateUserData)
                    defLinearProgressIndicator(),
                    /// body
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            /// image
                            CircleAvatar(
                              radius: 90,
                              backgroundImage: CachedNetworkImageProvider(model.image),
                            ),
                            /// name
                            textFieldItem(title: 'Name', controller: nameController),
                            /// phone number
                            textFieldItem(title: 'Phone number', controller: phoneNumberController,keyboard: TextInputType.phone,),
                            /// email
                            textFieldItem(title: 'Email', controller: emailController,enabled: false),
                            ///  favorites drink
                            if(cubit.favorites.isNotEmpty)
                              Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    defText(text: 'Favorites drink',textColor: secColor.withOpacity(0.6)),
                                    const SizedBox(height: 10,),
                                    Wrap(
                                      spacing: 8.0, // Horizontal spacing between items
                                      runSpacing: 8.0, // Vertical spacing between lines
                                      children: cubit.favorites
                                          .map((item) => Chip(
                                          backgroundColor: secColor,
                                          padding: const EdgeInsetsDirectional.all(8),
                                          label: defText(text:item.drinkName,textColor: defColor)
                                      ),
                                      )
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    /// save edit
                    defButton(
                        onTap: (){
                          if(formKey.currentState!.validate()){
                            if(nameController.text != model.name || phoneNumberController.text != model.phoneNumber){
                              cubit.updateUser(name: nameController.text,phoneNumber: phoneNumberController.text);
                            }
                          }
                        },
                        child: defText(text: 'Save Edit',textColor: defColor),
                    )
                  ],
                ),
              ),
            ),
          );
        },
    );
  }

  Widget textFieldItem({
  required String title,
  required TextEditingController controller,
    bool enabled = true,
    TextInputType keyboard = TextInputType.text,
})=>Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      defText(text: title,textColor: secColor.withOpacity(0.6)),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter some information';
            }
            return null;
          },
          controller: controller,
          keyboardType: keyboard,
          style: const TextStyle(color: secColor),
          enabled: enabled,
          decoration:  InputDecoration(
            suffixIcon:enabled ? null : const Icon(Icons.lock,color: secColor,),
              hintStyle: const TextStyle(color: secColor),
              border: OutlineInputBorder(
                  borderRadius:BorderRadius.circular(20)
              )
          ),
        ),
      ),
    ],
  );
}
