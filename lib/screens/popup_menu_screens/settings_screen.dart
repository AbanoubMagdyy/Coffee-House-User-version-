import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_house/screens/popup_menu_screens/support_screen.dart';
import 'package:coffee_house/screens/popup_menu_screens/manage_account_screen.dart';
import 'package:coffee_house/screens/settings_screens/about_us_screen.dart';
import 'package:coffee_house/screens/settings_screens/feedback_screen.dart';
import 'package:coffee_house/screens/settings_screens/privacy_policy_screen.dart';
import 'package:coffee_house/screens/settings_screens/terms_and_conditions_screen.dart';
import 'package:coffee_house/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/components.dart';
import '../../components/constants.dart';
import '../../shared/profile_bloc/cubit.dart';
import '../../shared/profile_bloc/states.dart';
import '../bottom_navigation_bar_screens/favorites_screen.dart';
import '../bottom_navigation_bar_screens/order_screen.dart';
import '../settings_screens/manage_addresses_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = ProfileCubit.get(context).userInformation;
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            titleSpacing: 0,
            backgroundColor: backgroundColor,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: secColor,
              ),
            ),
            title: defText(text: 'Settings'),
            actions: [
              /// support icon
              InkWell(
                onTap: ()=>navigateTo(context, SupportScreen()),
                child: Container(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 15),
                  margin: const EdgeInsets.only(right: 10, top: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(30),
                      border: Border.all(color: secColor, width: 2,),),
                  child: Row(
                    children: [
                      const Icon(Icons.support_agent_rounded, color: secColor),
                      defText(text: 'Support', fontSize: 15)
                    ],
                  ),
                ),
              )
            ],
          ),
          body: Column(
            children: [
              /// body
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      /// image and name & date
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            /// image
                            CircleAvatar(
                              radius: 40,
                              backgroundImage:
                                  CachedNetworkImageProvider(model!.image),
                            ),

                            /// name and date
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  defText(text: model.name),
                                  defText(
                                      text:
                                          'Joined since ${model.theDateOfJoin}',
                                      fontSize: 13),
                                ],
                              ),
                            ),

                            /// edit icon
                            InkWell(
                              onTap: () => navigateTo(
                                  context, ManageAccountScreen(model)),
                              child: Container(
                                padding: const EdgeInsetsDirectional.all(5),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadiusDirectional.circular(30),
                                    border:
                                        Border.all(color: secColor, width: 2)),
                                child: const Icon(
                                    Icons.mode_edit_outline_outlined,
                                    color: secColor),
                              ),
                            )
                          ],
                        ),
                      ),

                      /// line
                      Container(
                        height: 1,
                        color: secColor,
                        margin: const EdgeInsetsDirectional.all(10),
                      ),

                      /// orders & favorites
                      Column(
                        children: [
                          bannerItem('orders & favorites'),
                          subBannerItem(
                            title: 'Order History',
                            onTap: () => navigateTo(
                              context,
                               OrderScreen(2),
                            ),
                          ),
                          subBannerItem(
                              title: 'Favorites',
                              onTap: () => navigateTo(
                                    context,
                                    const FavoritesScreen(),
                                  )),
                        ],
                      ),

                      /// payment & refunds
                      Column(
                        children: [
                          bannerItem('payments & refunds'),
                          subBannerItem(title: 'Payment Modes', onTap: () {}),
                          subBannerItem(title: 'Refund Status', onTap: () {}),
                        ],
                      ),

                      /// account settings
                      Column(
                        children: [
                          bannerItem('account settings'),
                          subBannerItem(
                            title: 'Manage Addresses',
                            onTap: () => navigateTo(
                              context,
                              ManageAddressesScreen(model),
                            ),
                          ),
                          subBannerItem(
                              title: 'Manage Account',
                              onTap: () => navigateTo(
                                  context, ManageAccountScreen(model))),
                        ],
                      ),

                      /// about
                      Column(
                        children: [
                          bannerItem('about'),
                          subBannerItem(
                            title: 'Terms and Conditions',
                            onTap: () => navigateTo(
                              context,
                              const TermsAndConditionsScreen(),
                            ),
                          ),
                          subBannerItem(
                            title: 'Feedback',
                            onTap: () => navigateTo(
                              context,
                               FeedbackScreen(model: ProfileCubit.get(context).rateModel),
                            ),
                          ),
                          subBannerItem(title: 'Privacy Policy', onTap: () =>navigateTo(context, const PrivacyPolicyScreen(),),),
                          subBannerItem(title: 'About Us', onTap: ()=>navigateTo(context, const AboutUsScreen(),),),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              /// logout
              InkWell(
                onTap: () => logout(context),
                child: Container(
                    margin: const EdgeInsetsDirectional.all(12),
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: secColor.withOpacity(0.7),
                      borderRadius: BorderRadiusDirectional.circular(25),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.logout, color: defColor),
                        defText(text: 'Logout', textColor: defColor)
                      ],
                    )),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget bannerItem(String title) => Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.symmetric(vertical: 10),
      margin: const EdgeInsets.only(bottom: 8),
      color: secColor.withOpacity(0.5),
      child: defText(text: title.toUpperCase(), fontSize: 16));

  Widget subBannerItem({
    required String title,
    required Function() onTap,
  }) =>
      InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Row(
            children: [
              Expanded(child: defText(text: title)),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: secColor,
              ),
              const SizedBox(
                width: 8,
              ),
            ],
          ),
        ),
      );
}
