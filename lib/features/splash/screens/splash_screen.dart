import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/common/widgets/category_widget.dart';
import 'package:izees/features/admin/bottom_bar_nav/screens/bottom_bar_nav_screen.dart';
import 'package:izees/features/auth/auth_cubit/auth_cubit.dart';
import 'package:izees/features/auth/services/auth_service.dart';
import 'package:izees/features/user/home/screens/home_sceen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../driver/screens/driver_order_list/driver_order_list_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService =AuthService();
   String? user;
   String? role ;

  @override
  void initState() {
    super.initState();
    _authService.getUserData(context);
     getToken();
  }

  getToken()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    user =  prefs.getString('x-auth-token') ;
    role =   prefs.getString('role');
    print('your token is $user and your role is $role ');
    //return user;
  }



  @override
  Widget build(BuildContext context) {



    goToWidget(){
      if( user == ''){
        Navigator.pushNamed(context, HomeScreen.routeName);
      }else{
        switch(role){
          case 'user':

            Navigator.pushNamed(context, HomeScreen.routeName);
            break;
          case 'admin':

            Navigator.pushNamed(context, BottomBarNavScreen.routeName);
            break;
          case 'driver':

            Navigator.pushNamed(context, DriverOrderListScreen.routeName);
            break;
        }

      }
    }


    return  Scaffold(
      body: goToWidget()
    );
  }
}
