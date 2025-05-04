import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/auth/auth_cubit/auth_cubit.dart';
import 'package:izees/features/driver/screens/driver_order_list/driver_order_list_screen.dart';
import 'package:izees/features/it_support/screens/it_support_screen.dart';
import 'package:izees/models/admin_model.dart';
import 'package:izees/models/auth_model.dart';
import 'package:izees/resources/strings_res.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/app_exception.dart';
import '../../admin/admin_orders/services/admin_order_socket.dart';
import '../../admin/bottom_bar_nav/screens/bottom_bar_nav_screen.dart';
import '../../driver/services/driver_socket.dart';
import '../../user/cart/services/cart_socket.dart';
import '../../user/home/screens/home_sceen.dart';

class AuthService{


  Dio dio = Dio();

Future<void> signin( {required String name, required String email, required String password,required String phoneNumber})async {
try {
  AuthModel authModel = AuthModel(
    name: name,
    email: email,
    password: password,
    phoneNumber: phoneNumber,
  );

 await dio.post('${StringsRes.uri}/user/sgin',
      data: authModel.toJson(),
      options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          }

      ));

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

  Future<void> login({ required String email, required String password, required BuildContext context})async {
    try {
      AuthModel authModel = AuthModel(
          email: email,
          password: password
      );

      Response res = await dio.post('${StringsRes.uri}/user/login',
          data: authModel.toJson(),
          options: Options(
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
              }

          ));
      var auth = BlocProvider.of<AuthCubit>(context);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('x-auth-token', res.data['token']);
      prefs.setString('role', res.data['role']);

      switch(res.data['role']){
        case 'user':
          auth.setUser(AuthModel.fromJson(res.data));
          SocketUserClient.instance.connect(auth.authModel.token!);


          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          break;
        case 'admin':
          auth.setAdmin(AdminModel.fromJson(res.data));
          SocketAdminClient.instance.connect(auth.adminModel.token!);  // This accesses the singleton instance and calls connect.

          Navigator.pushReplacementNamed(context, BottomBarNavScreen.routeName);
          break;
        case 'it-support':
          auth.setUser(AuthModel.fromJson(res.data));

          Navigator.pushReplacementNamed(context, ItSupportScreen.routeName);
        case 'driver':
          auth.setUser(AuthModel.fromJson(res.data));
          SocketDriverClient.instance.connect();
          Navigator.pushReplacementNamed(context, DriverOrderListScreen.routeName);
          break;
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

  void getUserData(
      BuildContext context,
      ) async{

    try{
      SharedPreferences prefs =await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if(token == null){
        prefs.setString('x-auth-token', '');
      }
      var tokenRes =  await dio.post(
        '${StringsRes.uri}/tokenIsValid',
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token!
          }
        ),

      );

      var response =tokenRes.data ;
      if(response == true){
//await getuser(context);
      }

    } on DioException catch (e) {
      if (e.response != null && e.response?.data is Map<String, dynamic>) {
        final message = e.response?.data['message'] ?? 'Something went wrong';
        throw AppException(message);
      } else {
        throw AppException('Network error. Please try again.');
      }
    }
  }




  Future<void> getuser(
      AuthCubit auth
      )
  async
  {
    try{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('x-auth-token');
    if (token != null && token != '') {
      Response userRes = await dio.get('${StringsRes.uri}/get-user-data',
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        ),
      );

      print("the user data is -------------------${userRes.data}");


      switch (userRes.data['role']) {
        case 'user':
          auth.setUser(AuthModel.fromJson(userRes.data));

          print("your tokkkkin is -------------- ${auth.authModel.token}");
          break;
        case 'admin':
          auth.setAdmin(AdminModel.fromJson(userRes.data));

          break;
        case 'driver':
          auth.setUser(AuthModel.fromJson(userRes.data));

          break;
      }
    }
  }
    on DioException catch (e) {
      if (e.response != null && e.response?.data is Map<String, dynamic>) {
        final message = e.response?.data['message'] ?? 'Something went wrong';
        throw AppException(message);
      } else {
        throw AppException('the socket error is  ${e.toString()}' );
      }
    }
  }

  void logOut(BuildContext context) async{
    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.remove('x-auth-token');
      await sharedPreferences.remove('role');

    //  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false);


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