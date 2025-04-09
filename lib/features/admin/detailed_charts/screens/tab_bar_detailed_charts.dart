import 'package:flutter/material.dart';
import 'package:izees/features/admin/detailed_charts/screens/All_%20detailed_charts.dart';
import 'package:izees/features/admin/detailed_charts/screens/daily_%20detailed_charts.dart';
import 'package:izees/features/admin/detailed_charts/screens/monthly_%20detailed_charts.dart';
import 'package:izees/resources/strings_res.dart';

class TabBarDetailedCharts extends StatelessWidget {
  const TabBarDetailedCharts({super.key});

  static const String routeName = '/charts';
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
        DailyDetailedCharts(),
       // WeaklyDetailedCharts(),
        MonthlyDetailedCharts(),
        AllDetailedCharts(),
      ],),
    ));
  }
}
