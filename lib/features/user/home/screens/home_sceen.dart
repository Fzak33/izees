import 'package:flutter/material.dart';
import 'package:izees/features/user/cart/screens/cart_screen.dart';
import 'package:izees/features/user/search/screens/search_screen.dart';

import '../../izees/screens/izees_screen.dart';
import '../../settings/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  static const  routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  List<Widget> pages =[
    IzeesScreen(),
    ProductSearchPage(),
    CartScreen(),
    SettingsScreen()
  ];

  void updatePage(int page){
    setState(() {
      _page = page;
    });
  }
  @override
  Widget build(BuildContext context) {


    return  Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(

        currentIndex: _page,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.black,
        iconSize: 28,
        onTap: updatePage,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline_outlined), label: '')

      ],),
    );
  }
}
