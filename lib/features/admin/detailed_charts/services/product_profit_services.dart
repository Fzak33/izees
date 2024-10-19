import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/auth/auth_cubit/auth_cubit.dart';

import '../../../../resources/strings_res.dart';
import '../../models/sales.dart';

class ProductProfitServices{
  Dio _dio =Dio();

  Future<List<ProductProfit>> dailyProductProfit({required BuildContext context})async{
    try {
      List<ProductProfit> productProfit = [];
      var auth = BlocProvider.of<AuthCubit>(context);
      Response res = await _dio.get(
          '${StringsRes.uri}/get-product-profit-in-day-admin', options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': auth.adminModel.token,
          }
      ));
      for (var i in res.data) {
        productProfit.add(ProductProfit.fromJson(i));
      }

      return productProfit;
    }
    catch(e){
      print(e.toString());
      throw e.toString();
    }
  }

  Future<List<ProductProfit>> monthlyProductProfit({required BuildContext context})async{
    try {
      List<ProductProfit> productProfit = [];
      var auth = BlocProvider.of<AuthCubit>(context);
      Response res = await _dio.get(
          '${StringsRes.uri}/get-product-profit-in-month-admin', options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': auth.adminModel.token,
          }
      ));
      for (var i in res.data) {
        productProfit.add(ProductProfit.fromJson(i));
      }

      return productProfit;
    }
    catch(e){
      print(e.toString());
      throw e.toString();
    }
  }

  Future<List<ProductProfit>> productProfit({required BuildContext context})async{
    try {
      List<ProductProfit> productProfit = [];
      var auth = BlocProvider.of<AuthCubit>(context);
      Response res = await _dio.get(
          '${StringsRes.uri}/get-product-profit-admin', options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': auth.adminModel.token,
          }
      ));
      for (var i in res.data) {
        productProfit.add(ProductProfit.fromJson(i));
      }

      return productProfit;
    }
    catch(e){
      print(e.toString());
      throw e.toString();
    }
  }



}