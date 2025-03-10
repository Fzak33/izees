import 'package:flutter/material.dart';

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


class ColorManager{
  static const primaryColor = Color(0xff56f133);
  static const secondaryColor = Color(0xff5f6738);
  static const bottomButtonColor = Color(0xffc2769c);
  static const choiceColor = Color(0xff6f3450);

}