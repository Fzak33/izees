import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../common/app_exception.dart';
import '../../../models/sales.dart';
import '../product_profit_services.dart';
import 'package:flutter/material.dart';
part 'monthly_product_profit_state.dart';

class MonthlyProductProfitCubit extends Cubit<MonthlyProductProfitState> {
  MonthlyProductProfitCubit(this._productProfitServices) : super(MonthlyProductProfitInitial());
  final ProductProfitServices _productProfitServices;

  Future<void> getMonthlyProductProfit({required BuildContext context})async{
    emit(MonthlyProductProfitLoading());
    try{
      final res = await _productProfitServices.monthlyProductProfit(context: context);
      emit(MonthlyProductProfitSuccess(res));
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
    getMonthlyProductProfit(context: context); // Initial fetch
    // Scheduling the fetch to repeat every hour
    Future.delayed(const Duration(hours: 1), () {
      getMonthlyProductProfit(context: context);
      scheduleHourlyFetch(context: context); // Recursive call to repeat every hour
    });
  }

}
