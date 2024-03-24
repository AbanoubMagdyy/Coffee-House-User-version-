import 'package:coffee_house/components/items.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../style/colors.dart';

Widget defTextFormField({
  required controller,
  required String text,
  bool forPassword = false,
  bool isPassword = false,
  bool enabled = true,
  int maxLines = 1,
  IconData? icon,
  void Function()? onPressed,
  TextInputType keyboard = TextInputType.text,
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: TextFormField(
        maxLines: maxLines,
        enabled: enabled,
        obscureText: isPassword,
        controller: controller,
        keyboardType: keyboard,
        validator: (value){
          if (value == null || value.isEmpty) {
            return 'Please inter some information';
          }
          return null;
        },
        style: const TextStyle(color: secColor),
        decoration: InputDecoration(
          errorStyle: const TextStyle(color: secColor,fontSize: 20),
          hintText: text,
          hintStyle: const TextStyle(color: secColor),
          suffixIcon: forPassword
              ? IconButton(
                  icon: Icon(icon, color: secColor),
                  onPressed: onPressed,
                )
              : null,
        ),
      ),
    );

defMaterialBanner(context, text) => ScaffoldMessenger.of(context)
  ..removeCurrentMaterialBanner()
  ..showMaterialBanner(
    MaterialBanner(
      content: Text(
        text,
      ),
      onVisible: (){
        Future.delayed(const Duration(seconds: 3),()=>ScaffoldMessenger.of(context).removeCurrentMaterialBanner());
      },
      actions: const [
        Icon(Icons.info),
      ],
    ),
  );

navigateAndFinish(context, screen) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
      (route) => false,
    );

navigateTo(context, screen) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );

Widget defLinearProgressIndicator()=> Padding(
  padding: const EdgeInsets.only(bottom: 15.0),
  child: LinearProgressIndicator(
    backgroundColor: secColor,
    color: defColor.withOpacity(0.5),
  ),
);

Widget defText({
  required String text,
  Color textColor = secColor,
  double fontSize = 18,
  int maxLines = 2
})=>Padding(
  padding: const EdgeInsets.only(left: 10.0),
  child:   Text(
    text,
    style:  TextStyle(
      color: textColor,
      fontSize: fontSize,
    ),
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,

  ),
);


PopupMenuEntry<dynamic> popupMenuItem({
   IconData? icon,
    String? profileImage,
  required String valueAndTitle,
})=>   PopupMenuItem(
  value: valueAndTitle,
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        if(valueAndTitle != 'Profile')
        Row(
          children: [
            Icon(icon,size: 35,color: secColor,),
            const SizedBox(width: 8,),
            defText(text: valueAndTitle)
          ],
        ),
        if(valueAndTitle == 'Profile')
          Row(
            children: [
               CircleAvatar(
                radius: 15,
                backgroundImage: CachedNetworkImageProvider(profileImage!),
               ),
              const SizedBox(
                width: 8,
              ),
              defText(text: 'Profile')
            ],
          ),
        Container(
          margin: const EdgeInsetsDirectional.only(top: 20),
          height: 1,
          color: secColor,
        )
      ],
    ),
  ),
);

PreferredSizeWidget defAppBar(context,text)=>AppBar(
  backgroundColor: backgroundColor,
  titleSpacing: 0,
  elevation: 0,
  leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: secColor),
    onPressed: () => Navigator.pop(context),
  ),
  title: defText(
    text: text,
  ),
);

Widget defLine({
  double height = 1,
})=>
Container(
  margin: const EdgeInsetsDirectional.symmetric(vertical: 10),
  height: height,
  width: double.infinity,
  color: secColor,
);

Widget leading()=>Lottie.asset('assets/animation/leading.json');

networkImage(file,{double? height,double? width,BoxFit fit = BoxFit.fill}) => CachedNetworkImage(
  imageUrl: file,
  height: height,
  width: width,
  fit: fit,
  placeholder: (context, url) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
      CircularProgressIndicator(),
    ],
  ),
  errorWidget: (context, url, error) => const Icon(Icons.error),
);

Future bottomSheet(context, model)=> showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(35),
      ),
    ),
    backgroundColor: defColor,
    builder: (context) => SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: bottomSheetItem(model),
    )
);

Widget defButton({
  required Function() onTap,
  required Widget child,
})=> InkWell(
  onTap: onTap,
  child: Container(
    margin: const EdgeInsetsDirectional.only(top: 35),
    height: 50,
    width: double.infinity,
    decoration: BoxDecoration(
      color: secColor,
      borderRadius: BorderRadiusDirectional.circular(25),
    ),
    child: Center(
      child: child
    ),
  ),
);