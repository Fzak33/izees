import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/auth/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:izees/features/user/cart/services/cart_socket.dart';
import 'package:izees/features/user/home/screens/home_sceen.dart';
import 'package:izees/models/admin_model.dart';
import 'package:izees/models/auth_model.dart';
import 'package:izees/models/cart_model.dart';
import 'package:izees/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../common/app_exception.dart';
import '../../../../resources/strings_res.dart';

class CartServices {

  final Dio _dio = Dio();

  Future<Response> addToCart(
      {required Product product, required String id, required BuildContext context, required int quantity}) async {
    final auth = BlocProvider.of<AuthCubit>(context);
    String token = auth.authModel.token?.toString() ??
        auth.adminModel.token?.toString() ?? '';
    try {
      var data = {
        '_id': id,
        'quantity': quantity
      };
      Response res = await _dio.post('${StringsRes.uri}/add-to-cart',
          data: data,
          options: Options(
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': token
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


  Future<int> incrementOrDecrementQuantity(
      {required String cartId, required int quantity, required String id, required BuildContext context}) async {
    final auth = BlocProvider.of<AuthCubit>(context);
    String token = auth.authModel.token?.toString() ??
        auth.adminModel.token?.toString() ?? '';

    try {
      var data = {
        '_id': id,
        'quantity': quantity
      };
      Response res = await _dio.post(
          '${StringsRes.uri}/change-cart-product-qty/${cartId}',
          data: data,
          options: Options(
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': token
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

  Future<void> deleteProductFromCart(
      {required String cartId, required BuildContext context}) async {
    final auth = BlocProvider.of<AuthCubit>(context);
    String token = auth.authModel.token?.toString() ??
        auth.adminModel.token?.toString() ?? '';

    try {
      await _dio.delete(
          '${StringsRes.uri}/delete-product-from-cart/${cartId}',

          options: Options(
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': token
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


  Future<List<Cart>> getCart({required BuildContext context}) async {
    try {
      var auth = BlocProvider
          .of<AuthCubit>(context)
      ;
      String token = auth.authModel.token?.toString() ??
          auth.adminModel.token?.toString() ?? '';

      Response res = await _dio.get('${StringsRes.uri}/get-cart',
          options: Options(
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': token
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


  Future<Response> order(
      {required double sum, required BuildContext context}) async {
    try {
      var auth = BlocProvider.of<AuthCubit>(context);
      String token = auth.authModel.token?.toString() ??
          auth.adminModel.token?.toString() ?? '';


      Map<String, dynamic> data = {

        'totalPrice': sum,
        'address': auth.authModel.address
      };
      Response res = await _dio.post('${StringsRes.uri}/order',
          data: jsonEncode(data),
          options: Options(
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': token
              }

          ));
      if (res.statusCode == 20) {
        var user = auth.authModel.copyWith(cart: []);
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


  Future<void> addAddress(
      {required String address, required String city, required BuildContext context}) async {
    final auth = BlocProvider.of<AuthCubit>(context);
    String token = auth.authModel.token?.toString() ??
        auth.adminModel.token?.toString() ?? '';
    String role = auth.authModel.role?.toString() ??
        auth.adminModel.role?.toString() ?? '';

    try {
      AuthModel authModel = AuthModel(address: address, city: city);
      await _dio.post('${StringsRes.uri}/add-address',
          data: authModel.toJson(),
          options: Options(
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': token
              }
          )
      );
      if (role == 'admin') {
        AdminModel admin = auth.adminModel.copyWith(address: address);
        auth.setAdmin(admin);
      }
      else {
        AuthModel user = auth.authModel.copyWith(address: address);
        auth.setUser(user);
      }
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

  Future<Response> checkProductQuantity(
      {required String productId, required int quantity}) async {
    try {
      var data = {
        'productId':productId,
        'quantity':quantity
      };
      Response res = await  await _dio.post('${StringsRes.uri}/check-product-quantity',
          data: data,
          options: Options(
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
              }
          )
      );

      return res;
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

  Future<void> addTempUser({
    required String name ,
    required String phoneNumber ,
    required List<Cart> cart,
    required String address ,
    required String city,
    required BuildContext context
  })async {

    try{
      var auth = context.read<AuthCubit>();
      List<Map<String, dynamic>> tempCart = cart.map((item) {
        return {
          'product': item.product, // ✅ just product ID
          'quantity': item.quantity,
        };
      }).toList();
      var data = {
        'name':name,
        'phoneNumber':phoneNumber,
        'address':address,
        'city':city,
        'cart':tempCart
      };

      Response res = await  await _dio.post('${StringsRes.uri}/add-temp-user',
          data: data,
          options: Options(
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
              }
          )
      );
      if(res.statusCode == 200) {
        String token = res.data['token'];
        auth.setUser(AuthModel.fromJson(res.data));
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('x-auth-token', res.data['token']);
        prefs.setString('role', res.data['role']);
        SocketUserClient.instance.connect(token);
      }
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

}