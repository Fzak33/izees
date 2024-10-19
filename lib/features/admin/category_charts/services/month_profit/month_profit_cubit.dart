import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/sales.dart';
import '../categories_profit.dart';
import 'package:flutter/material.dart';
part 'month_profit_state.dart';

class MonthProfitCubit extends Cubit<MonthProfitState> {
  MonthProfitCubit(this._categoriesProfit) : super(MonthProfitInitial());
  CategoriesProfit _categoriesProfit ;

  Future<void> getCategoryProfitByMonth({required BuildContext context})async{
    emit(MonthProfitLoading());
    try{
      final res = await _categoriesProfit.getCategoryProfitByMonth(context: context);
      emit(MonthProfitSuccess(res));
    }
    catch(e){
      print(e.toString());
      emit(MonthProfitFailed(e.toString()));
    }
  }

  void scheduleHourlyFetch({required BuildContext context}) {
    getCategoryProfitByMonth(context: context); // Initial fetch
    // Scheduling the fetch to repeat every hour
    Future.delayed(Duration(hours: 1), () {
      getCategoryProfitByMonth(context: context);
      scheduleHourlyFetch(context: context); // Recursive call to repeat every hour
    });
  }
}
