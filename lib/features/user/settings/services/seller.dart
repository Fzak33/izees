import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/admin/bottom_bar_nav/screens/bottom_bar_nav_screen.dart';
import 'package:izees/features/auth/auth_cubit/auth_cubit.dart';
import 'package:izees/models/admin_model.dart';
import 'package:izees/models/auth_model.dart';
import 'package:izees/resources/strings_res.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SellerServices{


  Dio dio = Dio();
 // final String  _uri = 'http://192.168.1.103:3000';

  Future<void> seller({required String storeName,required branch,required BuildContext context})async {

try {
  var auth = BlocProvider
      .of<AuthCubit>(context)
      ;
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
    'branches': [branch]
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
   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('failed')));

 }
}
catch(e){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
print('the problem is ${e.toString()}');
}
    
    
  }

  Future<void> login({ required String email, required String password})async {

    // AuthModel authModel = AuthModel(
    //     email: email,
    //     password: password
    // ) ;
var data = {
  'email':email,
  'password':password
};
    await dio.post('${StringsRes.uri}/user/login',
        data:  data,
        options: Options(
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            }

        ));
  }



}