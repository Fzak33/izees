import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../models/product_model.dart';
import '../store_products_services.dart';

part 'store_products_state.dart';

class StoreProductsCubit extends Cubit<StoreProductsState> {
  StoreProductsCubit(this._storeProductsServices) : super(StoreProductsInitial());

  final StoreProductsServices _storeProductsServices;

  List<Product> _products = [];
  List<String> _excludedIds = [];
  bool _hasMore = true;

  Future<void> fetchCategoryProducts(String storeName) async {
    _resetState();
    if (state is ShowStoreProductLoading || !_hasMore) return;

    emit(ShowStoreProductLoading(_products));

    try {
      List<Product> newProducts = await _storeProductsServices.showStoreProducts(storeName:  storeName,exclude:  _excludedIds);

      if (newProducts.isEmpty) {
        _hasMore = false;
      } else {
        _excludedIds.addAll(newProducts.map((e) => e.id ?? ''));
        _products.addAll(newProducts);
      }

      emit(ShowStoreProductLoaded(_products, _hasMore));
    } catch (e) {
      // emit(CategoryProductError(e.toString()));
    }
  }

  Future<void> loadmore(String storeName)async {
    if (state is ShowStoreProductLoading || !_hasMore) return;

    emit(ShowStoreProductLoading(_products));

    try {
      List<Product> newProducts = await _storeProductsServices.showStoreProducts(storeName:  storeName,exclude:  _excludedIds);

      if (newProducts.isEmpty) {
        _hasMore = false;
      } else {
        _excludedIds.addAll(newProducts.map((e) => e.id ?? ''));
        _products.addAll(newProducts);
      }

      emit(ShowStoreProductLoaded(_products, _hasMore));
    } catch (e) {
      // emit(CategoryProductError(e.toString()));
    }
  }

  void _resetState() {
    _excludedIds.clear();
    _hasMore = true;
    _products =[];
    emit(StoreProductsInitial()); // Reset state before fetching new data
  }

}
