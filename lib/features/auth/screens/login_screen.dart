import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/common/widgets/text_field.dart';
import 'package:izees/features/auth/screens/signin_screen.dart';
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
  bool _isObscured = true;

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

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            obscureText: _isObscured,
            controller: _passEditingController,
            decoration: InputDecoration(
              hintText: "Enter your ${localization.password}",
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              ),
            ),
          ),
        ),
          ElevatedButton(onPressed: (){
            BlocProvider.of<AuthCubit>(context).login(
                email: _emailEditingController.text.trim(),
                password: _passEditingController.text.trim(),
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
