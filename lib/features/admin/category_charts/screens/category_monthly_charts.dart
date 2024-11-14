import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

import '../services/month_profit/month_profit_cubit.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryMonthlyCharts extends StatelessWidget {
  const CategoryMonthlyCharts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return BlocBuilder<MonthProfitCubit, MonthProfitState>(
      builder: (context, state) {
        if(state is MonthProfitLoading){
          return const Center(child: CircularProgressIndicator(),);
        }
        else if(state is MonthProfitFailed){
          return Center(child: Text(state.err),);
        }else if(state is MonthProfitSuccess){
          final sales =  state.sales;
          return Column(
            children: [
              const SizedBox(height: 10,),
              SizedBox(
                height: 250,
                width: 250,
                //  color: Colors.green,
                child:
                sales[6].earning == 0 ? PieChart(
                    PieChartData(

                        sections: [
                          PieChartSectionData(value: 1, color: Colors.deepOrange,title: localization.zeroSell),
                        ]
                    )
                ) :
                PieChart(
                    PieChartData(

                        sections: [
                          PieChartSectionData(value: (sales[0].earning).toDouble(), color: Colors.green,title: '${sales[0].label} \n ${sales[0].earning}'),
                          PieChartSectionData(value: (sales[1].earning).toDouble(), color: Colors.blue,title: '${sales[1].label} \n ${sales[1].earning}'),
                          PieChartSectionData(value: (sales[2].earning).toDouble(), color: Colors.purple,title: '${sales[2].label} \n ${sales[2].earning}'),
                          PieChartSectionData(value: (sales[3].earning).toDouble(), color: Colors.yellow,title: '${sales[3].label} \n ${sales[3].earning}'),
                          PieChartSectionData(value: (sales[4].earning).toDouble(), color: Colors.teal,title:'${sales[4].label} \n ${sales[4].earning}'),
                          PieChartSectionData(value: (sales[5].earning).toDouble(), color: Colors.red,title: '${sales[5].label} \n ${sales[5].earning}'),
                          // PieChartSectionData(value: (sales[6].earning).toDouble(), color: Colors.orangeAccent,title: sales[6].label, showTitle: true),


                        ]
                    )
                ),

              ),
              const SizedBox(height: 10,),

              ListView.builder(
                shrinkWrap: true,
                itemCount: sales.length,
                itemBuilder: (BuildContext context, int index) {
                  final sii = sales[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${localization.profit} ${sii.label} ${localization.is1} ${sii.earning} ${localization.jod}',
                        style: const TextStyle(color: Colors.black, fontSize: 16)),
                  );
                },
                // child: Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Text('Your Daily Profit from mens perfume is \$50', style: TextStyle(color: Colors.black, fontSize: 14)),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Text('Your Daily Profit from womens perfume is \$50', style: TextStyle(color: Colors.black,fontSize: 14)),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Text('Your Daily Profit from unisex perfume is \$50', style: TextStyle(color: Colors.black,fontSize: 14)),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Text('Your Daily Profit from beauty  is \$50', style: TextStyle(color: Colors.black,fontSize: 14)),
                //     ),
                //     Divider(),
                //     Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Text('Your Total Profit is \$1550', style: TextStyle(color: Colors.black,fontSize: 22)),
                //     ),
                //
                //
                //   ],
                // ),
              ),
            ],
          );
        }
        else{
          return const Center(child: Text('something occurd'),);
        }




      },
    );
  }
}
