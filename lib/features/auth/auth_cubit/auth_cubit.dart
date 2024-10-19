import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/auth/services/auth_service.dart';
import 'package:izees/models/admin_model.dart';
import 'package:izees/models/auth_model.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authService) : super(AuthInitial());


  AuthService authService;

  Future<void> signin({required String name, required String email, required String password,required String phoneNumber})async{
 await authService.signin(  name: name, email: email, password: password, phoneNumber: phoneNumber);

  }

  Future<void> login({ required String email, required String password, required BuildContext context})async{
    await  authService.login(email: email, password: password, context: context);

  }


  AuthModel _authModel = AuthModel() ;
  AuthModel get authModel => _authModel;
  void setUser(AuthModel user){
    _authModel = user;
  }

  AdminModel _adminModel = AdminModel() ;
  AdminModel get adminModel => _adminModel;
  void setAdmin(AdminModel admin){
    _adminModel = admin;
  }

}
