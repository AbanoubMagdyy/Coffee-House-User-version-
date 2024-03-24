import 'package:coffee_house/components/constants.dart';
import 'package:flutter/material.dart';
import '../../components/components.dart';
import '../../style/colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

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
 $appName we operates the $appName App mobile application.

This page informs you of our policies regarding the collection, use, and disclosure of personal information we receive from users of the App.

Information Collection and Use

While using our App, we may ask you to provide certain personally identifiable information that can be used to contact or identify you. Personally identifiable information may include, but is not limited to, your name, email address, postal address, and phone number.

Log Data

Like many app operators, we collect information that your browser sends whenever you visit our App ("Log Data"). This Log Data may include information such as your computer's Internet Protocol ("IP") address, browser type, browser version, the pages of our App that you visit, the time and date of your visit, the time spent on those pages, and other statistics.

Cookies

Cookies are files with a small amount of data, which may include an anonymous unique identifier. Cookies are sent to your browser from a web site and stored on your computer's hard drive.

Security

The security of your Personal Information is important to us, but remember that no method of transmission over the Internet, or method of electronic storage, is 100% secure. While we strive to use commercially acceptable means to protect your Personal Information, we cannot guarantee its absolute security.

Changes to This Privacy Policy

This Privacy Policy is effective as of [Date] and will remain in effect except with respect to any changes in its provisions in the future, which will be in effect immediately after being posted on this page.

We reserve the right to update or change our Privacy Policy at any time and you should check this Privacy Policy periodically. Your continued use of the Service after we post any modifications to the Privacy Policy on this page will constitute your acknowledgment of the modifications and your consent to abide and be bound by the modified Privacy Policy.

Contact Us

If you have any questions about this Privacy Policy, please contact us.
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
