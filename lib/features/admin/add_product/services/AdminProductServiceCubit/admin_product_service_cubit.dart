import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:izees/models/product_model.dart';
import 'package:meta/meta.dart';

import '../../../../../common/app_exception.dart';
import '../admin_product_service.dart';

part 'admin_product_service_state.dart';

class AdminProductServiceCubit extends Cubit<AdminProductServiceState> {
  AdminProductServiceCubit() : super(AdminProductServiceInitial());
  final AdminProductService _adminProductService = AdminProductService();
  final List<Product> _products =[];
Future<void> getAdminProduct({required BuildContext context})async{

  emit(AdminProductServiceLoding());

  try{

    final res = await _adminProductService.getAdminProducts(context: context);
    if(res.isEmpty || res.isEmpty){
      emit(AdminProductServiceEmpty("you don't have in product "));
    }else {
      _products.addAll(res);
      emit(AdminProductServiceSuccess( product: List.from(_products)));

    }
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
    emit(AdminProductServiceSuccess( product: List.from(_products)));
  }
}




  Future<void> addProduct({required Product product,required List<File> images, required BuildContext context})async {
  try {
    final res = await _adminProductService.addProduct(
        product: product, context: context, images: images);

    _products.add(res);

    emit(AdminProductServiceSuccess(product: List.from(_products)));
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
    emit(AdminProductServiceSuccess( product: List.from(_products)));
  }
  }

  Future<void> updateProduct({  required String productId,
    required String description,
    required String name,
    required double price,
    required int quantity,
    required BuildContext context})
  async {
  try {
    final res = await _adminProductService.updateProduct(productId: productId,
        description: description,
        name: name,
        price: price,
        quantity: quantity,
        context: context);
    if (res.statusCode == 200) {
      int index = _products.indexWhere((product) => product.id == productId);

      if (index != -1) {
        _products[index] = _products[index].copyWith(name: name,
            description: description,
            price: price,
            quantity: quantity);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update')),
        );
      }
      emit(AdminProductServiceSuccess(product: List.from(_products)));
    }
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
    emit(AdminProductServiceSuccess( product: List.from(_products)));
  }


  }


  Future<void> deleteProduct({  required String productId,

    required BuildContext context})
  async {
  try {
   final res= await _adminProductService.deleteProduct(
        productId: productId, context: context);
   if(res.statusCode == 200){
     _products.removeWhere((prod) => prod.id == productId);
   }else{
     ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Failed to delete')));
   }


    emit(AdminProductServiceSuccess(product: List.from(_products)));
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
    emit(AdminProductServiceSuccess( product: List.from(_products)));
  }

  }



}
