import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/admin/bottom_bar_nav/screens/bottom_bar_nav_screen.dart';
import 'package:izees/features/auth/auth_cubit/auth_cubit.dart';
import 'package:izees/features/auth/services/auth_service.dart';
import 'package:izees/features/it_support/screens/it_support_screen.dart';
import 'package:izees/features/user/home/screens/home_sceen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/screens/login_screen.dart';
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
  bool isLoading = true;

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     checkLoginStatus();
  //   });
  // }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();  // Call checkLoginStatus when the widget is initialized
  }


 void checkLoginStatus()async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();
   // await prefs.clear();
    role =   prefs.getString('role')?? '';
    user =   prefs.getString('x-auth-token')?? '';

    debugPrint(' and your role is $role ');
    debugPrint(' and your token is $user ');

    if (user != null && user!.isNotEmpty && mounted) {
      final auth = BlocProvider.of<AuthCubit>(context);
      await _authService.getuser(auth);
    }
    setState(() {
      isLoading = false;  // Set loading to false once the check is complete
    });
    //return user;

  }


 Widget goToWidget(){
    if( user == ''){
    return  const HomeScreen();
    }else{
      switch(role){
        case 'user':

          return const HomeScreen();

        case 'admin':

          return  const BottomBarNavScreen();
        case 'it-support':

          return   const ItSupportScreen();
        case 'driver':

          return   const DriverOrderListScreen();
        default:
          return const LoginScreen();
      }

    }
  }
  @override
  Widget build(BuildContext context) {
    // While data is loading, show a progress indicator
    if (isLoading) {
      return Scaffold(
        body: Center(
        child: Container(
        
          //color: Colors.green,
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width * 0.4,
          decoration:    BoxDecoration(

            // shape: BoxShape.circle,
          //  border: Border.all(color: Colors.blueGrey),
            borderRadius: BorderRadius.circular(15),
            image:  const DecorationImage(image: AssetImage("assets/images/izeesjo.jpg") ,
          //    fit: BoxFit.contain,
            )  ,
          ),
        
        ),
            ),
      );
    } else {
      return goToWidget();
    }
  }
}