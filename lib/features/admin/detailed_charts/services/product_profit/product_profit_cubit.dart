import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:izees/features/admin/detailed_charts/services/product_profit_services.dart';
import 'package:izees/features/admin/models/sales.dart';
import 'package:flutter/material.dart';

import '../../../../../common/app_exception.dart';
part 'product_profit_state.dart';

class ProductProfitCubit extends Cubit<ProductProfitState> {
  ProductProfitCubit(this._productProfitServices) : super(ProductProfitInitial());
final ProductProfitServices _productProfitServices;

  Future<void> getProductProfit({required BuildContext context})async{
    emit(ProductProfitLoading());
    try{
      final res = await _productProfitServices.productProfit(context: context);
      emit(ProductProfitSuccess(res));
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
    getProductProfit(context: context); // Initial fetch
    // Scheduling the fetch to repeat every hour
    Future.delayed(const Duration(hours: 1), () {
      getProductProfit(context: context);
      scheduleHourlyFetch(context: context); // Recursive call to repeat every hour
    });
  }

}
