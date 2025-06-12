import 'package:flutter/material.dart';

class ColorOption {
   final Color color;
   final String name;

   ColorOption(this.color, this.name);


  static final List<ColorOption> colorOptions = [
      ColorOption(Colors.red, 'Red'),
      ColorOption(Colors.redAccent, 'Red Accent'),
      ColorOption(Colors.pink, 'Pink'),
      ColorOption(Colors.pinkAccent, 'Pink Accent'),
      ColorOption(Colors.purple, 'Purple'),
      ColorOption(Colors.purpleAccent, 'Purple Accent'),
      ColorOption(Colors.deepPurple, 'Deep Purple'),
      ColorOption(Colors.deepPurpleAccent, 'Deep Purple Accent'),
      ColorOption(Colors.indigo, 'Indigo'),
      ColorOption(Colors.indigoAccent, 'Indigo Accent'),
      ColorOption(Colors.blue, 'Blue'),
      ColorOption(Colors.blueAccent, 'Blue Accent'),
      ColorOption(Colors.lightBlue, 'Light Blue'),
      ColorOption(Colors.lightBlueAccent, 'Light Blue Accent'),
      ColorOption(Colors.cyan, 'Cyan'),
      ColorOption(Colors.cyanAccent, 'Cyan Accent'),
      ColorOption(Colors.teal, 'Teal'),
      ColorOption(Colors.tealAccent, 'Teal Accent'),
      ColorOption(Colors.green, 'Green'),
      ColorOption(Colors.greenAccent, 'Green Accent'),
      ColorOption(Colors.lightGreen, 'Light Green'),
      ColorOption(Colors.lightGreenAccent, 'Light Green Accent'),
      ColorOption(Colors.lime, 'Lime'),
      ColorOption(Colors.limeAccent, 'Lime Accent'),
      ColorOption(Colors.yellow, 'Yellow'),
      ColorOption(Colors.yellowAccent, 'Yellow Accent'),
      ColorOption(Colors.amber, 'Amber'),
      ColorOption(Colors.amberAccent, 'Amber Accent'),
      ColorOption(Colors.orange, 'Orange'),
      ColorOption(Colors.orangeAccent, 'Orange Accent'),
      ColorOption(Colors.deepOrange, 'Deep Orange'),
      ColorOption(Colors.deepOrangeAccent, 'Deep Orange Accent'),
      ColorOption(Colors.brown, 'Brown'),
      ColorOption(Colors.grey, 'Grey'),
      ColorOption(Colors.blueGrey, 'Blue Grey'),
      ColorOption(Colors.black, 'Black'),
      ColorOption(Colors.white, 'White'),
   ];

}
