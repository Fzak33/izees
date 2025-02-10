import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../../common/app_exception.dart';
import '../../../../../models/product_model.dart';
import '../show_product_services.dart';
import 'package:flutter/material.dart';
part 'show_category_products_state.dart';

class ShowCategoryProductsCubit extends Cubit<ShowCategoryProductsState> {

  ShowCategoryProductsCubit(this._showProductServices, ) : super(ShowCategoryProductInitial());


  final ShowProductServices _showProductServices;

  List<Product> _products = [];
  List<String> _excludedIds = [];
  bool _hasMore = true;

  Future<void> fetchCategoryProducts(String category) async {
    _resetState();
    if (state is ShowCategoryProductLoading || !_hasMore) return;

    emit(ShowCategoryProductLoading(_products));

    try {
      List<Product> newProducts = await _showProductServices.showCategoryProducts(category:  category,exclude:  _excludedIds);

      if (newProducts.isEmpty) {
        _hasMore = false;
      } else {
        _excludedIds.addAll(newProducts.map((e) => e.id ?? ''));
        _products.addAll(newProducts);
      }

      emit(ShowCategoryProductLoaded(_products, _hasMore));
    } catch (e) {
     // emit(CategoryProductError(e.toString()));
    }
  }


//   void fetchCategoryProducts(String category) async {
//     _resetState();
//     currentCategory = category;
//     emit(ShowCategoryProductLoading());
//     try {
//       final products = await _showProductServices.showCategoryProducts(category: category,exclude:  excludeIds);
//       excludeIds.addAll(products.map((p) => p.id ?? ''));
//
//       emit(ShowCategoryProductLoaded( products,  products.isNotEmpty));
//     } catch (e) {
//      // emit(ProductError("Failed to load category products"));
//     }
//   }
//




  Future<void> loadmore(String category)async {
    if (state is ShowCategoryProductLoading || !_hasMore) return;

    emit(ShowCategoryProductLoading(_products));

    try {
      List<Product> newProducts = await _showProductServices.showCategoryProducts(category:  category,exclude:  _excludedIds);

      if (newProducts.isEmpty) {
        _hasMore = false;
      } else {
        _excludedIds.addAll(newProducts.map((e) => e.id ?? ''));
        _products.addAll(newProducts);
      }

      emit(ShowCategoryProductLoaded(_products, _hasMore));
    } catch (e) {
      // emit(CategoryProductError(e.toString()));
    }
  }

//   void loadMore() async {
//     if (!hasMore || state is ShowCategoryProductLoading) return;
//
//     try {
//       List<Product> newProducts = [];
//       if (currentCategory.isEmpty) {
// return ;
//       } else {
//         newProducts = await _showProductServices.showCategoryProducts(category:  currentCategory,exclude:  excludeIds);
//       }
//
//       excludeIds.addAll(newProducts.map((p) => p.id ?? ''));
//
//       if (state is ShowCategoryProductLoaded) {
//         final updatedProducts = (state as ShowCategoryProductLoaded).products + newProducts;
//         hasMore = newProducts.isNotEmpty;
//         emit(ShowCategoryProductLoaded( updatedProducts,  hasMore));
//       }
//     } catch (e) {
//      // emit(ProductError("Failed to load more products"));
//     }
//   }
//
  void _resetState() {
    _excludedIds.clear();
    _hasMore = true;
    _products =[];
    emit(ShowCategoryProductInitial()); // Reset state before fetching new data
  }

}

  // void scheduleHourlyFetch({required BuildContext context, required String category }) {
  //   showCategoryProducts(category: category); // Initial fetch
  //   // Scheduling the fetch to repeat every hour
  //   Future.delayed(const Duration(minutes: 15), () {
  //     products =[];
  //     showCategoryProducts(category:category );
  //     scheduleHourlyFetch(context: context, category: category); // Recursive call to repeat every hour
  //   });
  // }


