import 'package:coffee_house/shared/login_and_sign_up_bloc/cubit.dart';
import 'package:coffee_house/shared/login_and_sign_up_bloc/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/components.dart';
import '../../components/constants.dart';
import '../../layout/layout_screen.dart';
import '../../shared/shared_preferences.dart';
import '../../style/colors.dart';
import '../../widgets/filter_chip_widget.dart';

class CreateAccountScreen extends StatelessWidget {
  static final userNameController = TextEditingController();
  static final phoneNumberController = TextEditingController();
  final String userEmail;
  final ScrollController controller = ScrollController();

   CreateAccountScreen({Key? key, required this.userEmail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginAndSignUpCubit, LoginAndSignUpStates>(
      listener: (context, state) {
        /// create account
        if(state is SuccessCreateAccount){
          email = userEmail;
          Shared.saveDate(key: 'Email', value: userEmail)?.then((value) =>  navigateAndFinish(context, const LayoutScreen()));
        }
      },
      builder: (context, state) {
        var cubit = LoginAndSignUpCubit.get(context);
        return SingleChildScrollView(
          controller: controller,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (state is LoadingCreateAccount ||
                  state is LoadingUploadProfileImage)
                defLinearProgressIndicator(),

              /// profile image
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: secColor,
                      backgroundImage: cubit.profileImage == null
                          ? const AssetImage(
                              'assets/images/profileImage.gif',
                            )
                          : FileImage(cubit.profileImage!) as ImageProvider,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: secColor.withOpacity(0.5),
                    radius: 20,
                    child: IconButton(
                      onPressed: () {
                        cubit.getImageFromGallery();
                      },
                      icon: const Icon(
                        Icons.photo_library,
                        color: defColor,
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),

              /// name
              defTextFormField(
                text: 'Name',
                controller: userNameController,
              ),
              /// phone number
              defTextFormField(
                text: 'Phone number',
                controller: phoneNumberController,
                keyboard: TextInputType.phone
              ),
              const SizedBox(
                height: 10,
              ),
              /// choose favorite drinks
              Align(
                alignment: Alignment.center,
                child: FittedBox(
                  child: defText(text: 'Choose your favorite drinks',fontSize: 20)
                ),
              ),

              /// drinks
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                ),
                child: Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 8,
                  children:  [
                    FilterChipWidget(name: 'Coffee',list: favoriteDrinks),
                    FilterChipWidget(name: 'Tea',list: favoriteDrinks),
                    FilterChipWidget(name: 'Espresso',list: favoriteDrinks),
                    FilterChipWidget(name: 'Latte',list: favoriteDrinks),
                    FilterChipWidget(name: 'Hot Chocolate',list: favoriteDrinks),
                    FilterChipWidget(name: 'Iced Coffee',list: favoriteDrinks),
                    FilterChipWidget(name: 'Fruit Ice Crushers',list: favoriteDrinks),
                    FilterChipWidget(name: 'Smoothies',list: favoriteDrinks),
                    FilterChipWidget(name: 'Snow Mocha',list: favoriteDrinks),
                    FilterChipWidget(name: 'Cappuccino',list: favoriteDrinks),
                  ],
                ),
              ),

              /// arrow button
              CircleAvatar(
                radius: 30,
                backgroundColor: secColor.withOpacity(0.5),
                child: IconButton(
                  onPressed: () async {
                    controller.animateTo(
                      0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                    if (userNameController.text.isNotEmpty && phoneNumberController.text.isNotEmpty ) {
                      if (cubit.profileImage != null) {
                        await cubit
                            .uploadProfileImageMethod()
                            .then((value) async {
                          await Future.delayed(const Duration(seconds: 3))
                              .then((value) async {
                            await cubit.createAccountMethod(
                                name: userNameController.text,
                                email: userEmail,
                                favoriteDrinks: favoriteDrinks,
                              phoneNumber: phoneNumberController.text
                            );
                          },
                          );
                        },
                        );
                      } else {
                        await cubit.createAccountMethod(
                            name: userNameController.text,
                            email: userEmail,
                            favoriteDrinks: favoriteDrinks,
                            phoneNumber: phoneNumberController.text,
                        );
                      }
                    } else {
                      defMaterialBanner(context, 'Please write your information.');
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_forward_sharp,
                    color: defColor,
                    size: 35,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
