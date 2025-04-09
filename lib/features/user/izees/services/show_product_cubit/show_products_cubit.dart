import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../common/app_exception.dart';
import '../../../../../models/product_model.dart';
import '../show_product_services.dart';
import 'package:flutter/material.dart';

part 'show_products_state.dart';


class ShowProductsCubit extends Cubit<ProductState> {
  final ShowProductServices _showProductServices;
  List<String> _excludedIds = [];
  bool _hasMore = true;
  List<Product> newProducts = [];
  List<Product> _products = [];

  ShowProductsCubit(this._showProductServices) : super(ProductInitial());

  Future<void> fetchProducts() async {
   if (state is ProductLoading || !_hasMore) return;
    //
     emit(ProductLoading(_products)); // Keep existing products while loading

    try {
      List<Product> newProducts = await _showProductServices.fetchProducts(_excludedIds);

      if (newProducts.isEmpty) {
        _hasMore = false;
        print("No more products to fetch."); // 🔍 Debug log

      } else {
        print("Total products in state: ${_products.length}"); // 🔍 Debug log

        _excludedIds.addAll(newProducts.map((e) => e.id ?? ''));
        _products.addAll(newProducts);
      }

      emit(ProductLoaded(_products, _hasMore));
    } catch (e) {
      print("Error fetching products: $e"); // 🔍 Debug log

      // emit(ProductError(e.toString()));
    }
  }
}



  // void fetchProducts({bool isLoadMore = false}) async {
  //   _resetState();
  //   if (!isLoadMore) emit(ProductLoading());
  //
  //   if (!hasMore) return; // Stop if no more products
  //
  //   // Clear newProducts before fetching data
  //   newProducts.clear();
  //
  //   // Fetch new products
  //   final res = await _showProductServices.fetchProducts(excludeIds);
  //
  //   // Add new products to the list
  //   newProducts.addAll(res);
  //
  //   hasMore = newProducts.isNotEmpty;  // Check if there are more products
  //
  //   // Store fetched IDs to exclude them in future requests
  //   excludeIds.addAll(newProducts.map((p) => p.id ?? ''));
  //
  //   // Emit the updated state
  //   if (isLoadMore) {
  //     emit(ProductLoaded(List.from(newProducts), hasMore)); // Make sure to use List.from() to create a new list
  //   } else {
  //     emit(ProductLoaded(newProducts, hasMore)); // For the first fetch
  //   }
  // }
  //
  // void loadMore() async {
  //   if (!hasMore || state is ProductLoading) return;
  //
  //   try {
  //     // Clear newProducts before fetching data
  //     // newProducts.clear();
  //
  //     // Fetch more products
  //     final res = await _showProductServices.fetchProducts(excludeIds);
  //
  //     // Add the new products to newProducts
  //     newProducts.addAll(res);
  //
  //     // Store the fetched IDs to exclude them in the next fetch
  //     excludeIds.addAll(newProducts.map((p) => p.id ?? ''));
  //
  //     // Check if there are more products to load
  //     hasMore = newProducts.isNotEmpty;
  //
  //     // If the state is already ProductLoaded, append the new products
  //     if (state is ProductLoaded) {
  //       final updatedProducts = (state as ProductLoaded).products + newProducts;
  //
  //       // Emit the updated state with the new products
  //       emit(ProductLoaded(List.from(updatedProducts), hasMore));
  //     }
  //   } catch (e) {
  //     // Optionally handle errors here, e.g. emit(ProductError('Failed to load more products'));
  //   }
  // }
  //
  // void _resetState() {
  //   excludeIds.clear();
  //   hasMore = true;
  //   emit(ProductInitial()); // Reset state before fetching new data
  // }

