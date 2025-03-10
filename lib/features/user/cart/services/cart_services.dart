import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/auth/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:izees/features/user/home/screens/home_sceen.dart';
import 'package:izees/models/auth_model.dart';
import 'package:izees/models/cart_model.dart';
import 'package:izees/models/product_model.dart';
import '../../../../common/app_exception.dart';
import '../../../../resources/strings_res.dart';

class CartServices{

  final Dio _dio = Dio();

  Future<Response> addToCart({required Product product,required String id, required BuildContext context})async {
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
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Added to Cart")));
return res;


    }
    on DioException catch (e) {
      if (e.response != null && e.response?.data is Map<String, dynamic>) {
        final message = e.response?.data['message'] ?? 'Something went wrong';
        throw AppException(message);
      } else {
        throw AppException('Network error. Please try again.');
      }
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
    on DioException catch (e) {
      if (e.response != null && e.response?.data is Map<String, dynamic>) {
        final message = e.response?.data['message'] ?? 'Something went wrong';
        throw AppException(message);
      } else {
        throw AppException('Network error. Please try again.');
      }
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
    on DioException catch (e) {
      if (e.response != null && e.response?.data is Map<String, dynamic>) {
        final message = e.response?.data['message'] ?? 'Something went wrong';
        throw AppException(message);
      } else {
        throw AppException('Network error. Please try again.');
      }
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

      return cart;
    }
    on DioException catch (e) {
      if (e.response != null) {
        // Server responded with an error
        throw Exception(e.response?.data['message'] ?? 'Something went wrong');
      } else {
        // Network error or other unexpected error
        throw Exception('Network error. Please try again.');
      }
    }
  }



  Future<Response> order({required double sum, required BuildContext context})async {

    try {
      var auth = BlocProvider.of<AuthCubit>(context);

        
      Map<String,dynamic> data = {

        'totalPrice': sum,
        'address': auth.authModel.address
      };
   Response res=   await _dio.post('${StringsRes.uri}/order',
          data:jsonEncode( data) ,
          options: Options(
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': auth.authModel.token
              }

          ));
   if(res.statusCode == 20){
     var user=  auth.authModel.copyWith(cart:[]);
     auth.setUser(user);
   }

      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
return res;


    }
    on DioException catch (e) {
      if (e.response != null && e.response?.data is Map<String, dynamic>) {
        Navigator.pop(context);
        final message = e.response?.data['message'] ?? 'Something went wrong';
        throw AppException(message);


      } else {
        Navigator.pop(context);
        throw AppException('Network error. Please try again.');
      }

    }
  }



  Future<void> addAddress({required String address,required String city, required BuildContext context})async {
    final auth = BlocProvider.of<AuthCubit>(context);

    try {
      AuthModel authModel = AuthModel(address: address, city: city);
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
    on DioException catch (e) {
      if (e.response != null && e.response?.data is Map<String, dynamic>) {
        Navigator.pop(context);
        final message = e.response?.data['message'] ?? 'Something went wrong';
        throw AppException(message);


      } else {

        throw AppException('Network error. Please try again.');
      }

    }
  }





}