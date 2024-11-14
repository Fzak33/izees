import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:izees/features/admin/category_charts/services/categories_profit.dart';
import 'package:flutter/material.dart';
import '../../../../../common/app_exception.dart';
import '../../../models/sales.dart';

part 'day_profit_state.dart';

class DayProfitCubit extends Cubit<DayProfitState> {
  DayProfitCubit(this._categoriesProfit) : super(DayProfitInitial());
  final CategoriesProfit _categoriesProfit ;

  Future<void> getCategoryProfitByDay({required BuildContext context})async{
  emit(DayProfitLoading());
  try{
    final res = await _categoriesProfit.getCategoryProfitByDay(context: context);
    emit(DayProfitSuccess(res));
  }catch (e) {
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
    getCategoryProfitByDay(context: context); // Initial fetch
    // Scheduling the fetch to repeat every hour
    Future.delayed(Duration(hours: 1), () {
      getCategoryProfitByDay(context: context);
      scheduleHourlyFetch(context: context); // Recursive call to repeat every hour
    });
  }
}
