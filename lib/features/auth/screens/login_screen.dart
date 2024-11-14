import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/common/widgets/text_field.dart';
import 'package:izees/features/admin/bottom_bar_nav/screens/bottom_bar_nav_screen.dart';
import 'package:izees/features/auth/screens/signin_screen.dart';
import 'package:izees/features/user/home/screens/home_sceen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../auth_cubit/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
 // final VoidCallback resetAppKey;
  const LoginScreen({super.key, });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailEditingController = TextEditingController();
  TextEditingController _passEditingController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailEditingController.dispose();
    _passEditingController.dispose();


  }

  @override
  Widget build(BuildContext context) {
    var auth = BlocProvider.of<AuthCubit>(context);
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextField(controller: _emailEditingController, hintText: localization.email,),
        
          CustomTextField(controller: _passEditingController, hintText: localization.password,),
          ElevatedButton(onPressed: (){
            BlocProvider.of<AuthCubit>(context).login(
                email: _emailEditingController.text,
                password: _passEditingController.text,
              context: context
            );

          },
            child: Text(localization.login),

            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green

            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: TextButton(onPressed: (){
              Navigator.pushNamed(context, SignInScreen.routeName);

            },child:  Text(localization.signIn),),
          ),
        ],
      ),
    );
  }
}
