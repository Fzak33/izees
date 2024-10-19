import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/sales.dart';
import '../categories_profit.dart';
import 'package:flutter/material.dart';
part 'profit_state.dart';

class ProfitCubit extends Cubit<ProfitState> {
  ProfitCubit(this._categoriesProfit) : super(ProfitInitial());

  CategoriesProfit _categoriesProfit ;

  Future<void> getCategoryProfit({required BuildContext context})async{
    emit(ProfitLoading());
    try{
      final res = await _categoriesProfit.getCategoryProfit(context: context);
      emit(ProfitSuccess(res));
    }
    catch(e){
      print(e.toString());
      emit(ProfitFailed(e.toString()));
    }
  }

  void scheduleHourlyFetch({required BuildContext context}) {
    getCategoryProfit(context: context); // Initial fetch
    // Scheduling the fetch to repeat every hour
    Future.delayed(Duration(hours: 1), () {
      getCategoryProfit(context: context);
      scheduleHourlyFetch(context: context); // Recursive call to repeat every hour
    });
  }

}

