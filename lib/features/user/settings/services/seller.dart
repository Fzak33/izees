import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/admin/bottom_bar_nav/screens/bottom_bar_nav_screen.dart';
import 'package:izees/features/auth/auth_cubit/auth_cubit.dart';
import 'package:izees/models/admin_model.dart';
import 'package:izees/resources/strings_res.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/app_exception.dart';

class SellerServices{


  Dio dio = Dio();


  Future<void> seller({required String storeName,required String address,required String cityStore ,required BuildContext context})async {

try {
  var auth = BlocProvider
      .of<AuthCubit>(context)
      ;
  Branch branch = Branch(address: address, cityStore: cityStore);
  AdminModel adminModel =  AdminModel(
      id: auth.authModel.id,
    name: auth.authModel.name,
    email: auth.authModel.email,
    password: auth.authModel.password,
    token: auth.authModel.token,
    storeName: storeName,
    branches: [branch], cart: []
  );
  var data = {
    'storeName': storeName,
    'address': address,
    'cityStore':cityStore
  };
 Response res = await dio.put('${StringsRes.uri}/seller',
      data: data,
      options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': auth.authModel.token
          }

      ));
 if(res.statusCode == 200){
   Navigator.pushReplacementNamed(context, BottomBarNavScreen.routeName);
   final SharedPreferences prefs = await SharedPreferences.getInstance();
   prefs.setString('role', res.data['role']);
   auth.setAdmin(adminModel);
   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('success and your role is ${auth.adminModel.role}')));
 }
 else{
   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('failed')));

 }
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

  Future<Response> deleteMyAccount(
      { required String password, required BuildContext context})async{
    try{
      var auth = BlocProvider
          .of<AuthCubit>(context)
      ;
      String token = auth.authModel.token?.toString() ?? auth.adminModel.token?.toString() ?? '';
      String email = auth.authModel.email?.toString() ?? auth.adminModel.email?.toString() ?? '';
print('your email is ======== $email');
      var data = {
        'email':email,
        'password': password
      };

    Response res =  await dio.delete("${StringsRes.uri}/delete-account",
      data: data,
        options: Options(
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': token
            }
        )
      );
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



}