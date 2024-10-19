import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/sales.dart';
import '../product_profit_services.dart';
import 'package:flutter/material.dart';
part 'monthly_product_profit_state.dart';

class MonthlyProductProfitCubit extends Cubit<MonthlyProductProfitState> {
  MonthlyProductProfitCubit(this._productProfitServices) : super(MonthlyProductProfitInitial());
  ProductProfitServices _productProfitServices;

  Future<void> getMonthlyProductProfit({required BuildContext context})async{
    emit(MonthlyProductProfitLoading());
    try{
      final res = await _productProfitServices.monthlyProductProfit(context: context);
      emit(MonthlyProductProfitSuccess(res));
    }
    catch(e){
      print(e.toString());
      emit(MonthlyProductProfitFailed(e.toString()));
    }
  }

  void scheduleHourlyFetch({required BuildContext context}) {
    getMonthlyProductProfit(context: context); // Initial fetch
    // Scheduling the fetch to repeat every hour
    Future.delayed(Duration(hours: 1), () {
      getMonthlyProductProfit(context: context);
      scheduleHourlyFetch(context: context); // Recursive call to repeat every hour
    });
  }

}
