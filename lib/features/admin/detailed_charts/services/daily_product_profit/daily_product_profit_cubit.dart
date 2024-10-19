import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/sales.dart';
import '../product_profit_services.dart';
import 'package:flutter/material.dart';
part 'daily_product_profit_state.dart';

class DailyProductProfitCubit extends Cubit<DailyProductProfitState> {
  DailyProductProfitCubit(this._productProfitServices) : super(DailyProductProfitInitial());
  ProductProfitServices _productProfitServices;

  Future<void> getDailyProductProfit({required BuildContext context})async{
    emit(DailyProductProfitLoading());
    try{
      final res = await _productProfitServices.dailyProductProfit(context: context);
      emit(DailyProductProfitSuccess(res));
    }
    catch(e){
      print(e.toString());
      emit(DailyProductProfitFailed(e.toString()));
    }
  }

  void scheduleHourlyFetch({required BuildContext context}) {
    getDailyProductProfit(context: context); // Initial fetch
    // Scheduling the fetch to repeat every hour
    Future.delayed(Duration(hours: 1), () {
      getDailyProductProfit(context: context);
      scheduleHourlyFetch(context: context); // Recursive call to repeat every hour
    });
  }

}
