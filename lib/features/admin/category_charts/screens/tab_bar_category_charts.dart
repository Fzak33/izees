import 'package:flutter/material.dart';
import 'package:izees/resources/strings_res.dart';

import 'category_all_charts.dart';
import 'category_daily_charts.dart';
import 'category_monthly_charts.dart';
import 'category_weakly_charts.dart';


class TabBarCategoryCharts extends StatelessWidget {
  const TabBarCategoryCharts({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 3, child: Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.primaryColor,
        bottom: const TabBar(tabs: [
          Tab(child: Text('Daily', style: TextStyle(color: Colors.black),),),
         // Tab(child: Text('Weakly', style: TextStyle(color: Colors.black),),),
          Tab(child: Text('Monthly', style: TextStyle(color: Colors.black),),),
          Tab(child: Text('All', style: TextStyle(color: Colors.black),),),
        ],
        ),
      ),
      body: const TabBarView(children: [
        CategoryDailyCharts(),
       // CategoryWeaklyCharts(),
        CategoryMonthlyCharts(),
        CategoryAllCharts(),
      ],),
    ));
  }
}

