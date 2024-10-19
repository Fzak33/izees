part of 'show_products_cubit.dart';

@immutable
sealed class ShowProductsState {}

final class ShowProductsInitial extends ShowProductsState {}
final class ShowProductsLoading extends ShowProductsState {}
final class ShowProductsSuccess extends ShowProductsState {
  List<Product> product;

  ShowProductsSuccess({ required this.product});
}
final class ShowProductsEmpty extends ShowProductsState {
  String empty;

  ShowProductsEmpty(this.empty);
}
final class ShowProductsFailed extends ShowProductsState {
  String err;

  ShowProductsFailed(this.err);
}