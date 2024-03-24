import 'package:coffee_house/components/components.dart';
import 'package:coffee_house/components/constants.dart';
import 'package:coffee_house/screens/popup_menu_screens/manage_account_screen.dart';
import 'package:coffee_house/screens/popup_menu_screens/support_screen.dart';
import 'package:coffee_house/screens/popup_menu_screens/settings_screen.dart';
import 'package:coffee_house/shared/app_bloc/cubit.dart';
import 'package:coffee_house/shared/app_bloc/states.dart';
import 'package:coffee_house/shared/profile_bloc/cubit.dart';
import 'package:coffee_house/shared/profile_bloc/states.dart';
import 'package:coffee_house/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);

        return Scaffold(
            appBar: AppBar(
              backgroundColor: backgroundColor,
              titleSpacing: 20,
              elevation: 0,
              title: BlocConsumer<ProfileCubit, ProfileStates>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    var cubit = ProfileCubit.get(context);
                    List<String> appBarTitle = [
                      'Good day, ${cubit.userInformation?.name}',
                      'What would you like to drink today?',
                      'Your orders',
                      'Your favorite drinks to lighten up your day'
                    ];
                    return Visibility(
                        visible: cubit.showNameTheUser,
                        replacement: Image.asset('assets/leading.gif'),
                        child: defText(
                          text: appBarTitle[cubit.currentIndex],
                        ),);
                  },),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications,
                    color: secColor,
                    size: 30,
                  ),
                ),
                PopupMenuButton(
                  icon: const Icon(
                    Icons.menu,
                    color: secColor,
                    size: 30,
                  ),
                  color: backgroundColor,
                  position: PopupMenuPosition.under,
                  onSelected: (value) {
                    switch (value) {
                      case 'Profile':
                        navigateTo(context,ManageAccountScreen(ProfileCubit.get(context).userInformation!));
                        break;
                      case 'Settings':
                        navigateTo(context, const SettingsScreen());
                        break;
                      case 'Logout':
                        logout(context);
                        break;
                      case 'Support':
                        navigateTo(context, SupportScreen());
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    popupMenuItem(
                        valueAndTitle: 'Profile',
                        profileImage: ProfileCubit.get(context).userInformation!.image),
                    popupMenuItem(
                      icon: Icons.settings_outlined,
                      valueAndTitle: 'Settings',
                    ),
                    popupMenuItem(
                      icon: Icons.support_agent_rounded,
                      valueAndTitle: 'Support',
                    ),
                    popupMenuItem(
                      icon: Icons.logout_outlined,
                      valueAndTitle: 'Logout',
                    ),
                  ],
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeCurrentIndex(index);
                ProfileCubit.get(context).changeCurrentIndex(index);
              },
              iconSize: 30,
              backgroundColor: secColor,
              unselectedItemColor: Colors.white,
              selectedItemColor: Colors.white,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    label: 'Home',
                    activeIcon: Icon(Icons.home),
                    backgroundColor: secColor),
                BottomNavigationBarItem(
                    icon: Icon(Icons.coffee_outlined),
                    label: 'Drink Menu',
                    activeIcon: Icon(Icons.coffee),
                    backgroundColor: secColor),
                BottomNavigationBarItem(
                  icon: Icon(Icons.featured_play_list_outlined),
                  label: 'Your Order',
                  activeIcon: Icon(Icons.featured_play_list),
                  backgroundColor: secColor,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_outline),
                  label: 'Drink Menu',
                  activeIcon: Icon(Icons.favorite),
                  backgroundColor: secColor,
                ),
              ],
            ),
            body: cubit.screens[cubit.currentIndex]);
      },
    );
  }
}
