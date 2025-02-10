part of 'show_category_products_cubit.dart';

abstract class ShowCategoryProductsState extends Equatable {
  final List<Product> products;
  final bool hasMore;

  const ShowCategoryProductsState({this.products = const [], this.hasMore = true});

  @override
  List<Object> get props => [products, hasMore];
}

class ShowCategoryProductInitial extends ShowCategoryProductsState {}

class ShowCategoryProductLoading extends ShowCategoryProductsState {
  final List<Product> products;

  ShowCategoryProductLoading(this.products);
  @override
  List<Object> get props => [products];
}

class ShowCategoryProductLoaded extends ShowCategoryProductsState {
  final List<Product> products;
  final bool hasMore;

  ShowCategoryProductLoaded(this.products, this.hasMore);

  List<Object> get props => [products,hasMore];

}