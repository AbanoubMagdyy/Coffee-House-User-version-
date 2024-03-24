import 'package:coffee_house/components/items.dart';
import 'package:coffee_house/shared/app_bloc/cubit.dart';
import 'package:coffee_house/shared/app_bloc/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/components.dart';
import '../style/colors.dart';

class SeeAllScreen extends StatelessWidget {


  const SeeAllScreen({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context, state) {},
    builder: (context, state) {
      var cubit = AppCubit.get(context);
      return Scaffold(
            appBar: AppBar(
              backgroundColor: backgroundColor,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: secColor),
                onPressed: () => Navigator.pop(context),
              ),
              title: defText(
                text: 'Popular menu',
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: cubit.allItems.length,
                itemBuilder: (context, index) => popularMenuItem(cubit.allItems[index],),
              ),
            ),
          );
    }
    );
  }
}
