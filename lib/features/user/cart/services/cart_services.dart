import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/auth/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:izees/models/auth_model.dart';
import 'package:izees/models/cart_model.dart';
import '../../../../resources/strings_res.dart';

class CartServices{

  final Dio _dio = Dio();

  Future<void> addToCart({required String id, required BuildContext context})async {
    final auth = BlocProvider.of<AuthCubit>(context);

    try {
      var data = {'_id': id};
  Response res = await _dio.post('${StringsRes.uri}/add-to-cart',
          data: data ,
          options: Options(
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': auth.authModel.token
              }
          )
   );

   //
   // List<Cart> cart =[];
   //    if (res.statusCode == 200) {
   //      for (var i in res.data['cart']) {
   //
   //        cart.add(Cart.fromJson(i));
   //      }
   //    }


  //print("------------------ the cart is ${res.data['cart']}");

var user=  auth.authModel.copyWith(cart: res.data['cart']);
  auth.setUser(user);


    }
    catch(e){
      print(e.toString());

    }
  }

  Future<int> getQuantity({required String productId, required BuildContext context})async {
    final auth = BlocProvider.of<AuthCubit>(context);

    try {

     Response res = await _dio.get('${StringsRes.uri}/get-cart-product-qty/${productId}',

          options: Options(
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': auth.authModel.token
              }
          )
      );
int qty = 1;
qty = res.data;
return qty;


    }
    catch(e){
      print(e.toString());
  throw e.toString();
    }
  }

  Future<int> incrementOrDecrementQuantity({required String productId, required int quantity, required String id, required BuildContext context})async {
    final auth = BlocProvider.of<AuthCubit>(context);

    try {
var data = {
  '_id': id,
  'quantity':quantity
};
      Response res = await _dio.post('${StringsRes.uri}/change-cart-product-qty/${productId}',
data: data,
          options: Options(
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': auth.authModel.token
              }
          )
      );
      int qty = 1;
      qty = res.data;
      return qty;
    }
    catch(e){
      print(e.toString());
      throw e.toString();
    }
  }
  Future<void> deleteProductFromCart({required String productId, required BuildContext context})async {
    final auth = BlocProvider.of<AuthCubit>(context);

    try {

       await _dio.delete('${StringsRes.uri}/delete-product-from-cart/${productId}',

          options: Options(
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': auth.authModel.token
              }
          )
      );

    }
    catch(e){
      print(e.toString());

    }
  }





  Future< List<Cart> > getCart({required BuildContext context})async{


    try {
      var auth = BlocProvider
          .of<AuthCubit>(context)
      ;

      Response res = await _dio.get('${StringsRes.uri}/get-cart',
          options: Options(
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': auth.authModel.token
              }

          )
      );
      List<Cart> cart = [];
      if (res.statusCode == 200) {
        for (var i in res.data) {

          cart.add(Cart.fromJson(i));
        }
      }
    //  print('ypur cart is ------------------------------------ ${res.data}');
    //  AuthModel user =  auth.authModel.copyWith(cart: cart);
    //   auth.setUser(user);

      return cart;
    }
    catch(e){
      print(e.toString());
      throw e.toString();
    }
  }



  Future<void> order({required double sum, required BuildContext context})async {

    try {
      var auth = BlocProvider.of<AuthCubit>(context);

      var cart =  auth.authModel.cart;
        
      Map<String,dynamic> data = {
        'cart':  cart,
        'totalPrice': sum,
        'address': auth.authModel.address
      };
      await _dio.post('${StringsRes.uri}/order',
          data:jsonEncode( data) ,
          options: Options(
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': auth.authModel.token
              }

          ));


      var user=  auth.authModel.copyWith(cart:[]);
      auth.setUser(user);

print(auth.authModel.cart?.isEmpty);
      Navigator.pop(context);
    }
    catch(e){
      print(e.toString());
    }
  }



  Future<void> addAddress({required String address, required BuildContext context})async {
    final auth = BlocProvider.of<AuthCubit>(context);

    try {
      AuthModel authModel = AuthModel(address: address);
      await _dio.post('${StringsRes.uri}/add-address',
          data: authModel.toJson() ,
          options: Options(
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': auth.authModel.token
              }
          )
      );

      AuthModel user =  auth.authModel.copyWith(address: address);
      auth.setUser(user);

    }
    catch(e){
      print(e.toString());

    }
  }





}