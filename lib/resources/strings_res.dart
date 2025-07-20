import 'package:flutter/material.dart';

import 'language_cubit/locale_cubit.dart';

class StringsRes{
  static const uri = 'https://api.izeesjo.com';
//http://192.168.1.103:4000;
  //https://api.izeesjo.com
 static List<String> jordanCities(){
    List<String> cities = [
      "Amman",
       "Irbid",
       "Ajloun",
       "Jerash",
       "Mafraq",
     "Salt",
       "Zarqa",
      "Madaba",
       "Al Karak",
      "Tafilah",
      "Ma'an",
       "Aqaba"
    ];
    return cities;
  }


}

//2196F3FF
class ColorManager{
  static const checkoutColor = Color(0xff56f133);

  static const primaryColor = Color(0xff4A0C71);
  static const secondaryColor = Color(0xffE0F400);
  static const priceColor = Color(0xff7300ff);

  static const bottomButtonColor = Color(0xffc2769c);
  static const choiceColor = Color(0xff6f3450);
  static const blackColor = Color(0xff000000);

}

class FontStyles{
  static bool get isArabic => LocaleCubit.currentLanguage == 'ar';


  static TextStyle get homeName => TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: ColorManager.primaryColor,
    fontFamily: isArabic ? FontFamilies.tajawal : FontFamilies.raleway,
  );

  static TextStyle get categoryName => TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 13,
    color: ColorManager.secondaryColor,
    fontFamily: isArabic ? FontFamilies.tajawal : FontFamilies.raleway,
  );

  static TextStyle get appBarName => TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 24,
    color: ColorManager.secondaryColor,
    fontFamily: isArabic ? FontFamilies.tajawal : FontFamilies.raleway,
  );

  static TextStyle get categoryLabel => TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 28,
    color: ColorManager.secondaryColor,
    fontFamily: isArabic ? FontFamilies.tajawal : FontFamilies.raleway,
  );

  static TextStyle get stuffName => TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: ColorManager.primaryColor,
    fontFamily: isArabic ? FontFamilies.ibm : FontFamilies.nunitoSans,
  );

  static TextStyle get allItems => TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 27,
    color: ColorManager.primaryColor,
    fontFamily: isArabic ? FontFamilies.tajawal : FontFamilies.raleway,
  );

  static TextStyle get storeName => TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 18,
    color: ColorManager.primaryColor,
    fontFamily: isArabic ? FontFamilies.tajawal : FontFamilies.raleway,
  );

  static TextStyle get addToCart => TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 18,
    color: ColorManager.secondaryColor,
    fontFamily: isArabic ? FontFamilies.tajawal : FontFamilies.raleway,
  );

  static const buttonText = TextStyle(fontWeight: FontWeight.bold , fontSize: 18 , color: ColorManager.secondaryColor,fontFamily: 'Raleway');
  static const appBarText = TextStyle(fontWeight: FontWeight.bold , fontSize: 22 , color: ColorManager.secondaryColor);
  static TextStyle get priceText => TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 22,
    color: ColorManager.primaryColor,
    fontFamily: isArabic ? FontFamilies.tajawal : FontFamilies.raleway,
  );  static const nameText = TextStyle(fontWeight: FontWeight.bold , fontSize: 20 , color: ColorManager.blackColor);
  static const descriptionText = TextStyle(fontWeight: FontWeight.bold , fontSize: 18 , color: ColorManager.choiceColor);

}

class FontFamilies{
  static const String raleway = 'Raleway';
  static const String tajawal = 'Tajawal';
  static const String nunitoSans = 'NunitoSans';
  static const String ibm = 'IBMPlexSansArabic';

}

class Padd{
 static const pad = EdgeInsets.symmetric(horizontal: 8, vertical: 16);
}