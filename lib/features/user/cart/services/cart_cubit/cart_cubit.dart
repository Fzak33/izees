import 'package:bloc/bloc.dart';

import '../../../../../common/app_exception.dart';
import '../../../../../models/cart_model.dart';
import 'package:flutter/material.dart';

import '../../../../../models/product_model.dart';
import '../cart_services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../cart_socket.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this._socketUserClient,this._cartServices) : super(CartInitial());

  final CartServices _cartServices;
  final SocketUserClient _socketUserClient;
  List<Cart> _cart=[];

  double totalPrice= 0;
  int driverPrice= 0;

  void setToZero(){
    totalPrice= 0;
    driverPrice= 0;
    print("your order price is $totalPrice and your driver is $driverPrice");

  }

  Future<void> getCart({required BuildContext context})async{

    try{
      emit(CartLoading());
      final res = await _cartServices.getCart(context: context);
      if(res.isEmpty || res.length == 0){
        emit(CartEmpty("Cart is Empty "));
      }else {
        _cart.addAll(res);
        emit(CartSuccess(cart: List.from(_cart)));

      }
      emit(CartSuccess(cart: List.from(_cart)));

    }
    catch (e) {
      print("the problem of cart is ${e.toString()}");
      if (e is AppException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred')),
        );
      }
      // Keep the state as CartSuccess
      emit(CartSuccess(cart: List.from(_cart)));
    }
  }

  Future<void> addToCart({
    required Product product,
    required String id,
    required BuildContext context,
    required int quantity
  }) async {
    try {

      final res = await _cartServices.addToCart(id: id, context: context, product: product, quantity: quantity);

      if (res.statusCode == 200) {
        int index = _cart.indexWhere((cart) => cart.product?.id == id);
        if (index != -1) {
          int? q = _cart[index].quantity;
          int? newQuantity = q! + quantity;
          _cart[index] = _cart[index].copyWith(quantity: newQuantity);
          print("added old to cart");

        } else {
          Cart cart = Cart(product: product, quantity: quantity, id: res.data['cartId']);
          _cart.add(cart);
          print("added new to cart");

        }
        emit(CartSuccess(cart: List.from(_cart)));
      }
      else
      {
        print("failed added to cart");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add to cart')),
        );
        // Keep the state as CartSuccess
        emit(CartSuccess(cart: List.from(_cart)));
      }
    } catch (e) {
      print("the problem of cart is ${e.toString()}");

      if (e is AppException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
        print(e.toString());
        print(e.message);

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred')),
        );
        print(e.toString());
      }
      // Keep the state as CartSuccess
      emit(CartSuccess(cart: List.from(_cart)));
    }
  }





  Future<void> incrementQuantity({required String id,required BuildContext context,required String productId}) async {
    try {
      int index = _cart.indexWhere((cart) => cart.id == productId);
      if(index != -1){


        final currentQuantity = _cart[index].quantity;
        final newQuantity = currentQuantity! + 1;

        final res =  await _cartServices.incrementOrDecrementQuantity(
            productId: productId,
            quantity: newQuantity,
            id: id,
            context: context
        );

        if(res == newQuantity){
          _cart[index] = _cart[index].copyWith(quantity: newQuantity);
          emit(CartSuccess(cart: List.from(_cart)));

        }

      }

    }  catch (e) {
      if (e is AppException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred')),
        );
      }
      // Keep the state as CartSuccess
      emit(CartSuccess(cart: List.from(_cart)));
    }
  }

  Future<void> decrementQuantity({required String id,required BuildContext context,required String productId}) async {
    try {
      int index = _cart.indexWhere((cart) => cart.id == productId);
      if(index != -1){
        final currentQuantity = _cart[index].quantity;
        final newQuantity = currentQuantity! - 1;
        final  res= await _cartServices.incrementOrDecrementQuantity(
            productId: productId,
            quantity: newQuantity,
            id: id,
            context: context
        );
        if(res == newQuantity){
          _cart[index] = _cart[index].copyWith(quantity: newQuantity);
          emit(CartSuccess(cart: List.from(_cart)));

        }
      }

      emit(CartSuccess(cart: List.from(_cart)));
    }catch (e) {
      if (e is AppException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred')),
        );
      }
      // Keep the state as CartSuccess
      emit(CartSuccess(cart: List.from(_cart)));
    }
  }

  Future<void> deleteProductFromCart({required String productId,required BuildContext context}) async {
    try {
      await _cartServices.deleteProductFromCart(productId: productId, context: context);
      _cart.removeWhere((cart) => cart.id == productId);
      emit(CartSuccess(cart: List.from(_cart)));
    } catch (e) {
      if (e is AppException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred')),
        );
      }
      // Keep the state as CartSuccess
      emit(CartSuccess(cart: List.from(_cart)));
    }
  }


  // Future<void> order({required double sum, required BuildContext context})async{
  //  try {
  //    final localization = AppLocalizations.of(context)!;
  //
  //
  //   final res = await _cartServices.order(sum: sum, context: context);
  //   if(res.statusCode == 200){
  //     _cart = [];
  //     emit(CartSuccess(cart: List.from(_cart)));
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text(localization.successOrder),));
  //   }
  //
  //  }
  //  catch (e) {
  //    if (e is AppException) {
  //      ScaffoldMessenger.of(context).showSnackBar(
  //        SnackBar(content: Text(e.message)),
  //      );
  //    } else {
  //      ScaffoldMessenger.of(context).showSnackBar(
  //        const SnackBar(content: Text('An unexpected error occurred')),
  //      );
  //    }
  //    // Keep the state as CartSuccess
  //    emit(CartSuccess(cart: List.from(_cart)));
  //  }
  // }


  Future<void> order({required double sum, required BuildContext context}) async {
    try {
      final localization = AppLocalizations.of(context)!;

      _socketUserClient.placeOrder(
        totalPrice: sum,
        context: context,
        onSuccess: (orderId) {
          _cart = [];
          emit(CartSuccess(cart: List.from(_cart)));
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(localization.successOrder)),
          );
        },
        onError: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error)),
          );
          emit(CartSuccess(cart: List.from(_cart)));
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred')),
      );
      emit(CartSuccess(cart: List.from(_cart)));
    }
  }

  void clearCart() {
    _cart.clear();
    emit(CartEmpty("Cart is cleared"));
  }

  Future<void> addAddress({required String address,required String city, required BuildContext context, })async{
    try {
      await _cartServices.addAddress(
          city: city, address: address, context: context);
    }
    catch (e) {
      if (e is AppException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred')),
        );
      }
      // Keep the state as CartSuccess

    }
  }

}
