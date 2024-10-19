import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/auth/auth_cubit/auth_cubit.dart';
import 'package:izees/features/driver/screens/driver_order_list/driver_order_list_screen.dart';
import 'package:izees/models/admin_model.dart';
import 'package:izees/models/auth_model.dart';
import 'package:izees/resources/strings_res.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../admin/bottom_bar_nav/screens/bottom_bar_nav_screen.dart';
import '../../user/home/screens/home_sceen.dart';

class AuthService{


  Dio dio = Dio();
 // final String  _uri = 'http://192.168.1.103:3000';

Future<void> signin( {required String name, required String email, required String password,required String phoneNumber})async {

  AuthModel authModel = AuthModel(
    name: name,
    email: email,
    password: password,
      phoneNumber: phoneNumber,
  ) ;

 await dio.post('${StringsRes.uri}/user/sgin',
     data:  authModel.toJson(),
     options: Options(
   headers: {
     'Content-Type': 'application/json; charset=UTF-8',
   }

 ));


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

      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      break;
    case 'admin':
        auth.setAdmin(AdminModel.fromJson(res.data));

      Navigator.pushReplacementNamed(context, BottomBarNavScreen.routeName);
      break;
    case 'driver':
      auth.setUser(AuthModel.fromJson(res.data));

      Navigator.pushReplacementNamed(context, DriverOrderListScreen.routeName);
      break;
  }




}
catch(e){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
  print(e.toString());
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
        '${StringsRes.uri}/token-is-valid',
            options: Options(
          headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'x-auth-token':token
      }
      )
      );

      var response =tokenRes.data ;
      if(response == true){
        //get user data
        Response userRes =   await dio.get('${StringsRes.uri}/',
          options: Options(
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': token
            },
          ),
        );
        var auth = BlocProvider.of<AuthCubit>(context);
       // userProvider.setUser(userRes.body);

        switch(userRes.data['role']){
          case 'user':
            auth.setUser(AuthModel.fromJson(userRes.data));


            break;
          case 'admin':
            auth.setAdmin(AdminModel.fromJson(userRes.data));

            break;
          case 'driver':
            auth.setUser(AuthModel.fromJson(userRes.data));

            break;
        }


      }

    } catch (e){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())));
     // showSnackBar(context , e.toString() );
    }
  }


}