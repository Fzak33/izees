import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/admin/admin_orders/services/admin_order_socket.dart';
import 'package:izees/features/auth/services/auth_service.dart';
import 'package:izees/models/admin_model.dart';
import 'package:izees/models/auth_model.dart';
import 'package:flutter/material.dart';

import '../../../common/app_exception.dart';
import '../../driver/services/driver_socket.dart';
import '../../user/cart/services/cart_socket.dart';
import '../screens/login_screen.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authService , this.resetApp) : super(AuthInitial());

  final VoidCallback resetApp;
  AuthService authService;

  Future<void> signin({required String name, required String email, required String password,required String phoneNumber,required BuildContext context})async{
 try {
   await authService.signin(
       name: name, email: email, password: password, phoneNumber: phoneNumber);
   Navigator.pushNamed(context, LoginScreen.routeName);
   ScaffoldMessenger.of(context).showSnackBar(
     const SnackBar(content: Text('sign in success, now log in')),
   );
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

  Future<void> login({ required String email, required String password, required BuildContext context})async{
    try {
      await authService.login(
          email: email, password: password, context: context
      );

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

  Future  <void> logOut({ required BuildContext context})async {
    try {
      resetApp();
      authService.logOut(context);
      SocketAdminClient.instance.dispose();
      SocketUserClient.instance.dispose();
      SocketDriverClient.instance.dispose();
      clearModels();
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
Future<void> getUser({ required BuildContext context}) async{
   try {
    // await authService.getuser(context);
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
     // Keep the state as CartSuccess

   }
}

  AuthModel _authModel = AuthModel() ;
  AuthModel get authModel => _authModel;
  void setUser(AuthModel user){
    _authModel = user;
  //  emit(AuthUser(user));
  }

  AdminModel _adminModel = AdminModel() ;
  AdminModel get adminModel => _adminModel;
  void setAdmin(AdminModel admin){
    _adminModel = admin;
 //   emit(AuthAdmin(admin));
  }

  void clearModels() {
    _authModel = AuthModel(); // Reset AuthModel
    _adminModel = AdminModel(); // Reset AdminModel
  }
}
