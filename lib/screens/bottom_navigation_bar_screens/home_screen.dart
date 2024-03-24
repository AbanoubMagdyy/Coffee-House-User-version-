import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:coffee_house/components/components.dart';
import 'package:coffee_house/screens/see_all_screen.dart';
import 'package:coffee_house/shared/app_bloc/cubit.dart';
import 'package:coffee_house/shared/app_bloc/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/items.dart';
import '../../style/colors.dart';

class HomeScreen extends StatelessWidget {
  final double minWidthForImageInBestSellerItem = 420;
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Visibility(
          visible: cubit.showContent,
          replacement: leading(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: LayoutBuilder(
              builder: (context,constraints) {
                final double availableWidth = constraints.maxWidth;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// best Seller Item
                    if(cubit.drinkWithMaxNumberOfSold().drinkName.isNotEmpty)
                    Container(
                      height: 300,
                      margin: const EdgeInsetsDirectional.symmetric(
                          horizontal: 20, vertical: 35),
                      padding: const EdgeInsetsDirectional.all(25),
                      decoration: BoxDecoration(
                        color: secColor,
                        borderRadius: BorderRadiusDirectional.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: secColor.withOpacity(0.6), // Shadow color
                            blurRadius: 5, // Blur radius
                            offset:
                                const Offset(0, 4), // Offset (horizontal, vertical)
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          /// text
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Best seller of the week',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                Text(
                                  cubit.drinkWithMaxNumberOfSold().drinkName,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                InkWell(
                                  onTap: ()=>bottomSheet(context,cubit.drinkWithMaxNumberOfSold()),
                                  child: Row(
                                    children: const [
                                      Text(
                                        'More info',
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),


                          /// image
                          if(availableWidth > minWidthForImageInBestSellerItem)
                          Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadiusDirectional.circular(20)),
                            child: networkImage(
                                cubit.drinkWithMaxNumberOfSold().image),
                          )
                        ],
                      ),
                    ),

                    /// title
                    defText(text: 'This week\'s recommendations'),

                    /// recommendations item
                    Container(
                      margin: const EdgeInsetsDirectional.symmetric(vertical: 20),
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: cubit.recommendationItems.length,
                        itemBuilder: (context, index) => recommendationItem(cubit.recommendationItems[index],context),
                      ),
                    ),

                    /// title
                    defText(text: 'What\'s in the shop?'),

                    /// new item item
                    SizedBox(
                      height: 400,
                      child: CarouselSlider(
                        items: cubit.newItems
                            .map(
                              (item) => Stack(
                                children: [
                                  /// image
                                  Container(
                                    padding: const EdgeInsets.all(16.0),
                                    margin: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30.0),
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                item.image),
                                            fit: BoxFit.fill)),
                                  ),

                                  /// shadow and title
                                  Container(
                                    height: 400.0,
                                    width: double.infinity / 2,
                                    padding: const EdgeInsets.all(16.0),
                                    margin: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.0),
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.topRight,
                                        colors: [
                                          cubit.colorsForSecondShadow.isEmpty
                                              ? Colors.transparent
                                              : cubit
                                                  .colorsForSecondShadow[
                                                      cubit.bannerIndex]!
                                                  .color,
                                          cubit.colorsForFirstShadow.isEmpty
                                              ? Colors.transparent
                                              : cubit
                                                  .colorsForSecondShadow[
                                                      cubit.bannerIndex]!
                                                  .color
                                                  .withOpacity(0.5),
                                          cubit.colorsForFirstShadow.isEmpty
                                              ? Colors.transparent
                                              : cubit
                                                  .colorsForFirstShadow[
                                                      cubit.bannerIndex]!
                                                  .color
                                                  .withOpacity(0.8),
                                        ],
                                      ),
                                    ),
                                    child: defText(
                                      text:
                                          'Introducing our \nnew ${item.drinkName}',
                                      textColor: cubit.colorsForText.isNotEmpty
                                          ? cubit.colorsForText[cubit.bannerIndex]!
                                              .color
                                          : Colors.white,
                                      fontSize: 30,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                        options: CarouselOptions(
                            onPageChanged: (index, carouselPageChangedReason) =>
                                cubit.changeBannerIndex(index),
                            autoPlayAnimationDuration: const Duration(seconds: 1),
                            autoPlay: true,
                            autoPlayCurve: Curves.fastLinearToSlowEaseIn,
                            height: 400,
                            viewportFraction: 1,
                            autoPlayInterval: const Duration(seconds: 5),
                            scrollDirection: Axis.horizontal),
                      ),
                    ),

                    /// title
                    Row(
                      children: [
                        defText(text: 'Popular menu',fontSize: 15),
                        const Spacer(),
                        TextButton(
                            onPressed: () => navigateTo(
                                context,
                                const SeeAllScreen()),
                            child: defText(text: 'See all', fontSize: 11))
                      ],
                    ),

                    /// popular menu
                    SizedBox(
                      height: 800,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => popularMenuItem(cubit.allItems[index],),
                        itemCount: cubit.allItems.length,
                      ),
                    )
                  ],
                );
              }
            ),
          ),
        );
      },
    );
  }
}
