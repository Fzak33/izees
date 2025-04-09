import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:izees/models/product_model.dart';

import '../../../../../common/app_exception.dart';
import '../admin_product_service.dart';

part 'admin_product_service_state.dart';

class AdminProductServiceCubit extends Cubit<AdminProductServiceState> {
  AdminProductServiceCubit(this._adminProductService) : super(AdminProductServiceInitial());
  final AdminProductService _adminProductService ;
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isFetching = false;

  final List<Product> _products =[];
Future<void> getAdminProduct({required BuildContext context})async{

  emit(AdminProductServiceLoading());

  try{

    final res = await _adminProductService.getAdminProducts(context: context);
    if(res.isEmpty || res.isEmpty){
      emit(AdminProductServiceEmpty("you don't have in product "));
    }else {
      _products.addAll(res);
      emit(AdminProductServiceSuccess( List.from(_products)));

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
    emit(AdminProductServiceSuccess( List.from(_products)));
  }
}

  // void fetchProducts({ required BuildContext context}) async {
  //   if (_isFetching ) return;  // Don't fetch if already fetching or if there's no more data.
  //
  //
  //     emit(AdminProductServiceLoading());
  //     _currentPage = 1;
  //     _products.clear();
  //
  //
  //   _isFetching = true;  // Set fetching state to true
  //
  //   try {
  //     final products = await _adminProductService.getProducts(page: _currentPage, context: context);
  //     final hasMore = await _adminProductService.hasMoreProducts(page: _currentPage, context: context);
  //
  //     _products.addAll(products);
  //     _hasMore = hasMore;
  //    _currentPage++;
  //
  //     emit(AdminProductServiceSuccess(List.from(_products), _hasMore));
  //   } catch (e) {
  //     emit(AdminProductServiceFailed(e.toString()));
  //   } finally {
  //     _isFetching = false;  // Reset fetching state
  //   }
  // }

  // void fetchMoreProducts({required BuildContext context}) async {
  //   if (_isFetching || !_hasMore) return; // Don't fetch if already fetching or no more products
  //
  //   _isFetching = true;
  //
  //   try {
  //     final products = await _adminProductService.getProducts(page: _currentPage, context: context);
  //     final hasMore = await _adminProductService.hasMoreProducts(page: _currentPage, context: context);
  //
  //     // Add fetched products to the list
  //     _products.addAll(products);
  //     _hasMore = hasMore;
  //     _currentPage++;
  //
  //     emit(AdminProductServiceSuccess(List.from(_products), _hasMore));
  //   } catch (e) {
  //     emit(AdminProductServiceFailed(e.toString()));
  //   } finally {
  //     _isFetching = false;
  //   }
  // }
  //

  bool getHasMore() {
    const int limit = 20;
    return _products.length % limit == 0;
  }

  Future<void> addProduct({required Product product,required List<File> images, required BuildContext context})async {
  try {
    final res = await _adminProductService.addProduct(
        product: product, context: context, images: images);

    _products.add(res);

    emit(AdminProductServiceSuccess( List.from(_products)));
  }
  catch (e) {
    if (e is AppException) {
      debugPrint(e.message);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(e.message)),
      // );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred')),
      );
    }
    emit(AdminProductServiceSuccess(  List.from(_products)));
  }
  }

  Future<void> updateProduct({  required String productId,
    required String description,
    required String name,
    required String category,
    required double price,
    required int quantity,
    required BuildContext context})
  async {
  try {
    final res = await _adminProductService.updateProduct(productId: productId,
        description: description,
        name: name,
        category:category,
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
      emit(AdminProductServiceSuccess( List.from(_products), ));
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
    emit(AdminProductServiceSuccess(  List.from(_products), ));
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


    emit(AdminProductServiceSuccess( List.from(_products), ));
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
    emit(AdminProductServiceSuccess(  List.from(_products), ));
  }

  }

  Future<void> startSell({ required BuildContext context})async{
    try{
      await _adminProductService.startSelling(isSell: true, context: context);
      emit(state);
    }
    catch (e){

    }
  }

  Future<String> addStoreImage({required File storeImage, required BuildContext context})async{
    try{
    String res =  await _adminProductService.addStoreImage(storeImage: storeImage, context: context);
      _products.forEach((p) {
        p.storeImage = storeImage.path.split('/').last; // Assign the full URL to storeImage
      });
      emit(AdminProductServiceSuccess(List.from(_products),));
    return res;
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
      emit(AdminProductServiceSuccess(  List.from(_products),));
      return 'Error: Unable to upload image';
    }
}

}
