part of 'cart_services_cubit.dart';

@immutable
sealed class CartServicesState {}

final class CartServicesInitial extends CartServicesState {}
final class CartServicesLoading extends CartServicesState {}
final class CartServicesSuccess extends CartServicesState {
  List<Cart> cart;

  CartServicesSuccess({ required this.cart});

  CartServicesSuccess copyWith({List<Cart>? cart}){
    return CartServicesSuccess(cart: cart?? this.cart);
  }
}
final class CartServicesFailed extends CartServicesState {
  String err;

  CartServicesFailed(this.err);
}
final class CartServicesEmpty extends CartServicesState {
  String empty;

  CartServicesEmpty(this.empty);
}

