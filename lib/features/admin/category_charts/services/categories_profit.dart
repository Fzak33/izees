import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/admin/models/sales.dart';
import 'package:izees/features/auth/auth_cubit/auth_cubit.dart';
import 'package:izees/resources/strings_res.dart';

class CategoriesProfit{
  Dio _dio = Dio();

  Future<List<Sales>> getCategoryProfitByDay({required BuildContext context})async{
    var auth = BlocProvider.of<AuthCubit>(context);
    // List<Sales> sales= [];
    Response res = await _dio.get('${StringsRes.uri}/get-profit-in-day-admin',options: Options(
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': auth.adminModel.token,
      }
    ));
    print('your profit is ${res.data}-------------------');
    List<Sales> sales = [
  Sales('Women Perfume', res.data['womenPerfume']),
  Sales('Men Perfume', res.data['menPerfume']),
  Sales('uniPerfume', res.data['uniPerfume']),
  Sales('Health And Care', res.data['healthAndCare']),
  Sales('Beauty', res.data['buety']),
  Sales('Hair Care', res.data['hairless']),
      Sales('total Earning', res.data['sum']),
];

return sales;
}
  Future<List<Sales>> getCategoryProfitByMonth({required BuildContext context})async{
    var auth = BlocProvider.of<AuthCubit>(context);
    List<Sales> sales= [];
    Response res = await _dio.get('${StringsRes.uri}/get-profit-in-month-admin',options: Options(
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': auth.adminModel.token,
        }
    ));
    sales = [

      Sales('Women Perfume', res.data['womenPerfume']),
      Sales('Men Perfume', res.data['menPerfume']),
      Sales('uniPerfume', res.data['uniPerfume']),
      Sales('Health And Care', res.data['healthAndCare']),
      Sales('Beauty', res.data['buety']),
      Sales('Hair Care', res.data['hairless']),
      Sales('total Earning', res.data['sum']),
    ];
    return sales;
  }
  Future<List<Sales>> getCategoryProfit({required BuildContext context})async{
    var auth = BlocProvider.of<AuthCubit>(context);
    List<Sales> sales= [];
    Response res = await _dio.get('${StringsRes.uri}/get-profit-admin',options: Options(
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': auth.adminModel.token,
        }
    ));
    sales = [
      Sales('Women Perfume', res.data['womenPerfume']),
      Sales('Men Perfume', res.data['menPerfume']),
      Sales('uniPerfume', res.data['uniPerfume']),
      Sales('Health And Care', res.data['healthAndCare']),
      Sales('Beauty', res.data['buety']),
      Sales('Hair Care', res.data['hairless']),
      Sales('total Earning', res.data['sum']),

    ];
    return sales;
  }

}