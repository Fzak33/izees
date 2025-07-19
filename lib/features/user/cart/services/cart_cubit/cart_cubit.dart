import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/auth/auth_cubit/auth_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../common/app_exception.dart';
import '../../../../../models/cart_model.dart';
import 'package:flutter/material.dart';

import '../../../../../models/product_model.dart';
import '../cart_services.dart';

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

  Future<void> addTempUser({
    required String name ,
    required String phoneNumber ,
    required String address ,
    required String city,
    required BuildContext context
  })async{
    try{

      await _cartServices.addTempUser(
          name: name,
          phoneNumber: phoneNumber,
          cart: _cart,
          address: address,
          city: city,
          context: context);



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

    }
  }

  Future<void> _saveCartLocally() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = _cart.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('local_cart', cartJson);
  }


  Future<void> getCart({required BuildContext context})async{

    try{
      emit(CartLoading());
      var auth = context.read<AuthCubit>();
      String token = auth.authModel.token ?? auth.adminModel.token ?? '';
      if(token != '') {
        final res = await _cartServices.getCart(context: context);
        if (res.isEmpty || res.length == 0) {
          emit(CartEmpty("Cart is Empty "));
        }
        else {
          _cart.addAll(res);
          emit(CartSuccess(cart: List.from(_cart)));
        }
      }else{
        final prefs = await SharedPreferences.getInstance();
      final cartJsonList = prefs.getStringList('local_cart') ?? [];

      final localCart = cartJsonList
          .map((e) => Cart.fromJson(jsonDecode(e)))
          .toList();

      _cart.clear();
      _cart.addAll(localCart);

      if (_cart.isEmpty) {
        emit(CartEmpty("Cart is Empty"));
      } else {
        emit(CartSuccess(cart: List.from(_cart)));
      }}
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
    required String colorName,
    required BuildContext context,
    required int quantity,
    required String image,
    int colorIndex = 0
  }) async {
    try {

        var auth = context.read<AuthCubit>();
        var token = auth.authModel.token ?? auth.adminModel.token ?? '';
        if(token != ''){
          final res = await _cartServices.addToCart(id: id, context: context, product: product, quantity: quantity, colorName: colorName);

          if (res.statusCode == 200) {
            int index = _cart.indexWhere((cart) => cart.product?.id == id && cart.colorName == colorName);
            if (index != -1) {
              int? q = _cart[index].quantity;
              int? newQuantity = q! + quantity;
              _cart[index] = _cart[index].copyWith(quantity: newQuantity);
              print("added old to cart");
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('added to cart')),
              );
            } else {
              Cart cart = Cart(product: product,
                quantity: quantity,
                id: res.data['cartId'], colorName: colorName,
                image: image
              );
              _cart.add(cart);
              print("added new to cart");
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('added to cart')),
              );
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
        }
        else{
          final checkQuantity = await _cartServices.checkProductQuantity(productId: id, quantity: quantity);
          if (checkQuantity.statusCode == 200) {

            int index = _cart.indexWhere((cart) => cart.product?.id == id);
            if (index != -1) {
              int? q = _cart[index].quantity;
              int? newQuantity = q! + quantity;
              _cart[index] = _cart[index].copyWith(quantity: newQuantity);
              print("added old to cart");
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('added to cart')),
              );
            } else {
              Cart cart = Cart(product: product, quantity: quantity, id: '', colorName:colorName,image: image );
              _cart.add(cart);
              print("added new to cart");
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('added to cart')),
              );
            }

           await _saveCartLocally();

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





  Future<void> incrementQuantity({required String id,required BuildContext context,required String cartId}) async {
    try {
    int index = _cart.indexWhere((cart) => cart.id == cartId);
    if(index != -1){


      final currentQuantity = _cart[index].quantity;
      final newQuantity = currentQuantity! + 1;
var auth = context.read<AuthCubit>();
String token = auth.authModel.token ?? auth.adminModel.token ?? '';

if(token != ''){
  final res =  await _cartServices.incrementOrDecrementQuantity(
      cartId: cartId,
      quantity: newQuantity,
      id: id,
      context: context
  );

  if(res == newQuantity){
    _cart[index] = _cart[index].copyWith(quantity: newQuantity);
    emit(CartSuccess(cart: List.from(_cart)));
  }
}else{


  final res =  await _cartServices.checkProductQuantity(
      quantity: newQuantity, productId: id,

  );

  if(res.data == newQuantity){
    _cart[index] = _cart[index].copyWith(quantity: newQuantity);
    emit(CartSuccess(cart: List.from(_cart)));
    await _saveCartLocally();
  }

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

  Future<void> decrementQuantity({required String id,required BuildContext context,required String cartId}) async {
    try {
      int index = _cart.indexWhere((cart) => cart.id == cartId);
      if(index != -1){
        final currentQuantity = _cart[index].quantity;
        final newQuantity = currentQuantity! - 1;

        var auth = context.read<AuthCubit>();
        String token = auth.authModel.token ?? auth.adminModel.token ?? '';

        if(token != ''){
          final res =  await _cartServices.incrementOrDecrementQuantity(
              cartId: cartId,
              quantity: newQuantity,
              id: id,
              context: context
          );

          if(res == newQuantity){
            _cart[index] = _cart[index].copyWith(quantity: newQuantity);
            emit(CartSuccess(cart: List.from(_cart)));
          }
        }else{


          final res =  await _cartServices.checkProductQuantity(
            quantity: newQuantity, productId: id,

          );

          if(res.data == newQuantity){
            _cart[index] = _cart[index].copyWith(quantity: newQuantity);
            emit(CartSuccess(cart: List.from(_cart)));
            await _saveCartLocally();
          }

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

  Future<void> deleteProductFromCart({
    required String cartId,
    required String productId,
    required BuildContext context,
  }) async {
    try {
      var auth = context.read<AuthCubit>();
      String token = auth.authModel.token ?? auth.adminModel.token ?? '';

      if (token != '') {
        await _cartServices.deleteProductFromCart(
          cartId: cartId,
          context: context,
        );
        _cart.removeWhere((cart) => cart.id == cartId);
      } else {
        _cart.removeWhere((cart) => cart.product?.id == productId);
        await _saveCartLocally();
      }

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
