import 'package:flutter/material.dart';
import 'package:izees/features/admin/admin_orders/screens/admin_order_screen.dart';
import 'package:izees/resources/strings_res.dart';

import '../../../user/cart/screens/cart_screen.dart';
import '../../../user/izees/screens/izees_screen.dart';
import '../../../user/search/screens/search_screen.dart';
import '../../../user/settings/screens/settings_screen.dart';
import '../../add_product/screens/show_product_screen.dart';
import '../../category_charts/screens/tab_bar_category_charts.dart';
import '../../detailed_charts/screens/tab_bar_detailed_charts.dart';


class BottomBarNavScreen extends StatefulWidget {
  static const  routeName = '/bottom-bar-nav-screen';
  const BottomBarNavScreen({super.key});

  @override
  State<BottomBarNavScreen> createState() => _BottomBarNavScreenState();
}

class _BottomBarNavScreenState extends State<BottomBarNavScreen> {
  int _page = 0;
  List<Widget> pages =[
    const IzeesScreen(),
    const ProductSearchPage(),
    CartScreen(),
    const ShowProductScreen(),

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
      bottomNavigationBar: Container(

        decoration: const BoxDecoration(
          color: Color(0xffECEEF6), // Background color of the nav bar
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          child: BottomNavigationBar(
            backgroundColor:Color(0xffECEEF6),
            currentIndex: _page,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey[600],
            iconSize: 30,
            selectedIconTheme: IconThemeData(size: 30),
            unselectedIconTheme: IconThemeData(size: 25),
            type: BottomNavigationBarType.fixed, // show all icons
            onTap: updatePage,
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 4, bottom: 4), // reduce height
                  child: Icon(Icons.home_outlined),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 4, bottom: 4),
                  child: Icon(Icons.search),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 4, bottom: 4),
                  child: Icon(Icons.shopping_cart_outlined),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 4, bottom: 4),
                  child: Icon(Icons.person_outline_outlined),
                ),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
