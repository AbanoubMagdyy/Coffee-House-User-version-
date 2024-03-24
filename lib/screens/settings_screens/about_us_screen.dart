import 'package:coffee_house/components/constants.dart';
import 'package:flutter/material.dart';
import '../../components/components.dart';
import '../../style/colors.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defAppBar(
        context,
        'Privacy Policy',
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Text("""
Welcome to $appName, your go-to destination for delicious coffee and refreshing drinks!

At $appName, we're passionate about serving high-quality beverages that delight our customers' taste buds and provide a delightful experience with every sip. Our commitment to excellence drives everything we do, from sourcing the finest coffee beans to crafting unique and flavorful drinks that keep you coming back for more.

Founded $yearOfEstablishment, $appName has quickly become a beloved fixture in the community, known for our friendly service, inviting atmosphere, and dedication to serving up the perfect cup of coffee, every time. Whether you're a coffee aficionado or simply looking for a place to relax and unwind, we invite you to join us and discover why we're more than just a coffee shop – we're a gathering place for friends, family, and coffee lovers alike.

Our menu features an array of signature coffee blends, specialty drinks, teas, and other beverages to suit every palate. From classic favorites like espresso and cappuccino to indulgent treats like iced lattes and frappés, there's something for everyone to enjoy. Plus, we offer a selection of delicious pastries, snacks, and light bites to complement your drink and satisfy your cravings.

But $appName is more than just a place to grab a cup of coffee – it's a community hub where connections are made, conversations flow, and memories are created. Whether you're stopping by for your morning caffeine fix, meeting up with friends for a chat, or simply taking a moment to relax and recharge, we're here to provide you with a warm welcome and an exceptional coffee shop experience.

Thank you for choosing $appName. We look forward to serving you and being a part of your daily routine, one cup at a time.
 """,

            style: TextStyle(
              color: secColor,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
