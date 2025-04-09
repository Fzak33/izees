part of 'store_products_cubit.dart';

sealed class StoreProductsState extends Equatable {
  final List<Product> products;
  final bool hasMore;

  const StoreProductsState({this.products = const [], this.hasMore = true});

  @override
  List<Object> get props => [products, hasMore];
}

final class StoreProductsInitial extends StoreProductsState {
  @override
  List<Object> get props => [];
}

class ShowStoreProductLoading extends StoreProductsState {
  final List<Product> products;

  ShowStoreProductLoading(this.products);
  @override
  List<Object> get props => [products];
}

class ShowStoreProductLoaded extends StoreProductsState {
  final List<Product> products;
  final bool hasMore;

  ShowStoreProductLoaded(this.products, this.hasMore);

  List<Object> get props => [products,hasMore];

}