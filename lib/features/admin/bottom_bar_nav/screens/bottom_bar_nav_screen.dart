import 'package:flutter/material.dart';
import 'package:izees/features/admin/admin_orders/screens/admin_order_screen.dart';
import 'package:izees/resources/strings_res.dart';

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
    const ShowProductScreen(),
    const AdminOrderScreen(),
    const TabBarCategoryCharts(),
   const TabBarDetailedCharts(),
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
        selectedItemColor: ColorManager.bottomButtonColor,
        unselectedItemColor: Colors.black,
        iconSize: 28,
        onTap: updatePage,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined,),label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add_chart_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_outlined), label: '')

        ],),
    );
  }
}
