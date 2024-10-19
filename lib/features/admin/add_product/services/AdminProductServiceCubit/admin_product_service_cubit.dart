import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:izees/models/product_model.dart';
import 'package:meta/meta.dart';

import '../admin_product_service.dart';

part 'admin_product_service_state.dart';

class AdminProductServiceCubit extends Cubit<AdminProductServiceState> {
  AdminProductServiceCubit() : super(AdminProductServiceInitial());
  final AdminProductService _adminProductService = AdminProductService();

Future<void> getAdminProduct({required BuildContext context})async{

  emit(AdminProductServiceLoding());

  try{

    final res = await _adminProductService.getAdminProducts(context: context);
    if(res.isEmpty || res.length == 0){
      emit(AdminProductServiceEmpty("you don't have in product "));
    }else {
      emit(AdminProductServiceSuccess(res));
      print(res);
    }
  }
  catch(e){
emit(AdminProductServiceFailed(e.toString()));
  }
}




  Future<void> addProduct({required Product product,required List<File> images, required BuildContext context})async {
    _adminProductService.addProduct(product: product, context: context, images: images);
    final res = await _adminProductService.getAdminProducts(context: context) ;
   await getAdminProduct(context: context);
   // emit(AdminProductServiceSuccess(res));
  }
}
