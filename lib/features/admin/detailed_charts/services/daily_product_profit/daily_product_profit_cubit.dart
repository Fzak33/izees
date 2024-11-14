import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../common/app_exception.dart';
import '../../../models/sales.dart';
import '../product_profit_services.dart';
import 'package:flutter/material.dart';
part 'daily_product_profit_state.dart';

class DailyProductProfitCubit extends Cubit<DailyProductProfitState> {
  DailyProductProfitCubit(this._productProfitServices) : super(DailyProductProfitInitial());
  final ProductProfitServices _productProfitServices;

  Future<void> getDailyProductProfit({required BuildContext context})async{
    emit(DailyProductProfitLoading());
    try{
      final res = await _productProfitServices.dailyProductProfit(context: context);
      emit(DailyProductProfitSuccess(res));
    }
    catch (e) {
      if (e is AppException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred')),
        );
      }
    }
  }

  void scheduleHourlyFetch({required BuildContext context}) {
    getDailyProductProfit(context: context); // Initial fetch
    // Scheduling the fetch to repeat every hour
    Future.delayed(const Duration(hours: 1), () {
      getDailyProductProfit(context: context);
      scheduleHourlyFetch(context: context); // Recursive call to repeat every hour
    });
  }

}
