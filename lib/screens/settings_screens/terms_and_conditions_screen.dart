import 'package:coffee_house/components/constants.dart';
import 'package:flutter/material.dart';
import '../../components/components.dart';
import '../../style/colors.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defAppBar(
        context,
        'Terms And Conditions',
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            """ 
   Welcome to $appName App!

These terms and conditions outline the rules and regulations for the use of $appName 's mobile application.

By accessing this mobile application, we assume you accept these terms and conditions in full. Do not continue to use $appName App if you do not accept all of the terms and conditions stated on this page.

License
Unless otherwise stated, $appName  and/or its licensors own the intellectual property rights for all material on $appName App. All intellectual property rights are reserved. You may access this from $appName App for your own personal use subjected to restrictions set in these terms and conditions.

Restrictions
You are specifically restricted from all of the following:

. publishing any $appName App material in any other media;
. selling, sublicensing and/or otherwise commercializing any $appName App material;
. publicly performing and/or showing any $appName App material;
. using this $appName App in any way that is or may be damaging to $appName ;
. using this $appName App in any way that impacts user access to $appName ;
. using this $appName App contrary to applicable laws and regulations, or in any way may cause harm to the $appName , or to any person or business entity;
. engaging in any data mining, data harvesting, data extracting or any other similar activity in relation to $appName App;
. using this $appName App to engage in any advertising or marketing.

Certain areas of $appName App are restricted from being accessed by you and $appName  may further restrict access by you to any areas of this $appName App, at any time, in absolute discretion. Any user ID and password you may have for this $appName App are confidential and you must maintain confidentiality as well.

Your Content
In these $appName App Standard Terms and Conditions, "Your Content" shall mean any audio, video text, images or other material you choose to display on $appName App. By displaying Your Content, you grant $appName  a non-exclusive, worldwide irrevocable, sub licensable license to use, reproduce, adapt, publish, translate and distribute it in any and all media.

Your Content must be your own and must not be invading any third-party's rights. $appName  reserves the right to remove any of Your Content from $appName App at any time without notice.

No warranties
This $appName App is provided "as is," with all faults, and $appName  express no representations or warranties, of any kind related to $appName App or the materials contained on $appName App. Also, nothing contained on $appName App shall be interpreted as advising you.

Limitation of liability
In no event shall $appName , nor any of its officers, directors and employees, shall be held liable for anything arising out of or in any way connected with your use of $appName App whether such liability is under contract. $appName , including its officers, directors and employees shall not be held liable for any indirect, consequential or special liability arising out of or in any way related to your use of $appName App.

Indemnification
You hereby indemnify to the fullest extent $appName  from and against any and/or all liabilities, costs, demands, causes of action, damages and expenses arising in any way related to your breach of any of the provisions of these terms.

Severability
If any provision of these terms is found to be invalid under any applicable law, such provisions shall be deleted without affecting the remaining provisions herein.

Variation of Terms
$appName  is permitted to revise these terms at any time as it sees fit, and by using this $appName App you are expected to review these terms on a regular basis.

Assignment
$appName  is allowed to assign, transfer, and subcontract its rights and/or obligations under these terms without any notification. However, you are not allowed to assign, transfer, or subcontract any of your rights and/or obligations under these terms.

Entire Agreement
These terms constitute the entire agreement between $appName  and you in relation to your use of $appName App, and supersede all prior agreements and understandings.

Governing Law & Jurisdiction
These terms will be governed by and interpreted in accordance with the laws of the jurisdiction of $appName , and you submit to the non-exclusive jurisdiction of the state and federal courts located in $shopLocation for the resolution of any disputes.
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
