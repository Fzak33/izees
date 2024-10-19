import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:izees/features/admin/detailed_charts/services/product_profit_services.dart';
import 'package:izees/features/admin/models/sales.dart';
import 'package:flutter/material.dart';
part 'product_profit_state.dart';

class ProductProfitCubit extends Cubit<ProductProfitState> {
  ProductProfitCubit(this._productProfitServices) : super(ProductProfitInitial());
ProductProfitServices _productProfitServices;

  Future<void> getProductProfit({required BuildContext context})async{
    emit(ProductProfitLoading());
    try{
      final res = await _productProfitServices.productProfit(context: context);
      emit(ProductProfitSuccess(res));
    }
    catch(e){
      print(e.toString());
      emit(ProductProfitFailed(e.toString()));
    }
  }

  void scheduleHourlyFetch({required BuildContext context}) {
    getProductProfit(context: context); // Initial fetch
    // Scheduling the fetch to repeat every hour
    Future.delayed(Duration(hours: 1), () {
      getProductProfit(context: context);
      scheduleHourlyFetch(context: context); // Recursive call to repeat every hour
    });
  }

}
