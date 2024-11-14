part of 'cart_cubit.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {}
final class CartLoading extends CartState {}
final class CartSuccess extends CartState {
  List<Cart> cart;

  CartSuccess({ required this.cart});


}
final class CartFailed extends CartState {
  String err;

  CartFailed(this.err);
}
final class CartEmpty extends CartState {
  String empty;

  CartEmpty(this.empty);
}

