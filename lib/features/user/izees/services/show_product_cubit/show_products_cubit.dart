import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../common/app_exception.dart';
import '../../../../../models/product_model.dart';
import '../show_product_services.dart';
import 'package:flutter/material.dart';

part 'show_products_state.dart';


class ShowProductsCubit extends Cubit<ShowProductsState> {

  ShowProductsCubit(this._showProductServices) : super(ShowProductsInitial());

  final ShowProductServices _showProductServices;
  bool isLoading = false;

  List<Product> products =[];

  Future<void> showProducts()async{
    if(isLoading)return;
    emit(ShowProductsLoading());
    try{
      isLoading =true;
    var res =await  _showProductServices.showProducts();
    products.addAll(res);
    emit(ShowProductsSuccess(product: List.from(products)));
    }
    catch (e) {
      if (e is AppException) {
        emit(ShowProductsFailed(e.toString()));
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(e.message)),
        // );
      } else {
        emit(ShowProductsFailed(e.toString()));
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('An unexpected error occurred')),
        // );
      }
    }finally{
      isLoading =false;
    }
  }

  void scheduleHourlyFetch({required BuildContext context}) {
    showProducts(); // Initial fetch
    // Scheduling the fetch to repeat every hour
    Future.delayed(const Duration(minutes: 15), () {
      products =[];
      showProducts();
      scheduleHourlyFetch(context: context); // Recursive call to repeat every hour
    });
  }

}
