part of 'show_category_products_cubit.dart';

@immutable
sealed class ShowCategoryProductsState {}

final class ShowCategoryProductsInitial extends ShowCategoryProductsState {}
final class ShowCategoryProductsLoading extends ShowCategoryProductsState {}
final class ShowCategoryProductsSuccess extends ShowCategoryProductsState {
  List<Product> product;

  ShowCategoryProductsSuccess({ required this.product});
}
final class ShowCategoryProductsEmpty extends ShowCategoryProductsState {
  String empty;

  ShowCategoryProductsEmpty(this.empty);
}
final class ShowCategoryProductsFailed extends ShowCategoryProductsState {
  String err;

  ShowCategoryProductsFailed(this.err);
}