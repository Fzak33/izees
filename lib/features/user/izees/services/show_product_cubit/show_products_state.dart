part of 'show_products_cubit.dart';

abstract class ProductState extends Equatable {
  final List<Product> products;
  final bool hasMore;

  const ProductState({this.products = const [], this.hasMore = true});

  @override
  List<Object> get props => [products, hasMore];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {
  final List<Product> existingProducts;
  const ProductLoading(this.existingProducts);

  @override
  List<Object> get props => [existingProducts];
}

class ProductLoaded extends ProductState {
  const ProductLoaded(List<Product> products, bool hasMore)
      : super(products: products, hasMore: hasMore);
}