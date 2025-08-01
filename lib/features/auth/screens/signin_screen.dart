import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/common/widgets/text_field.dart';
import 'package:izees/features/auth/auth_cubit/auth_cubit.dart';
import 'package:izees/features/auth/screens/login_screen.dart';
import 'package:izees/resources/strings_res.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/sign-in';
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _emailEditingController = TextEditingController();
  TextEditingController _passEditingController = TextEditingController();
  TextEditingController _confirmPassEditingController = TextEditingController();
  TextEditingController _firstNameEditingController = TextEditingController();
  TextEditingController _lastNameEditingController = TextEditingController();
  TextEditingController _phoneNumberEditingController = TextEditingController();
String? errorMessage;


  @override
  void dispose() {
    super.dispose();
    _emailEditingController.dispose();
    _passEditingController.dispose();
    _firstNameEditingController.dispose();
    _lastNameEditingController.dispose();
    _phoneNumberEditingController.dispose();
    _confirmPassEditingController.dispose();
  }

  bool isValidJordanianPhoneNumber(String value) {
    final RegExp phoneRegExp = RegExp(r'^07[789]\d{7}$');
    return phoneRegExp.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

        return Scaffold(
          appBar: AppBar(backgroundColor: ColorManager.primaryColor,),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(controller: _firstNameEditingController, hintText: localization.firstName,),
                CustomTextField(controller: _lastNameEditingController, hintText: localization.lastName,),
                CustomTextField(controller: _emailEditingController, hintText: localization.email, textInputType: TextInputType.emailAddress,),
                CustomTextField(controller: _passEditingController, hintText: localization.password,textInputType: TextInputType.visiblePassword,),
                CustomTextField(controller: _confirmPassEditingController, hintText: localization.confirmPassword,textInputType: TextInputType.visiblePassword,),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _phoneNumberEditingController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,  // Limit the phone number length to 10 digits
                    decoration: InputDecoration(
                      hintText: "${localization.phoneNumber} ${localization.optional}",
                     // labelText: 'Phone Number',
                      errorText: errorMessage,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black38
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black38
                        ),
                      ),// Show error message
                      focusedBorder: const OutlineInputBorder( // Keep normal border when focused
                        borderSide: BorderSide(color: Colors.black38),
                      ),
                    ),
                    onChanged: (value) {
                      if (isValidJordanianPhoneNumber(value)) {
                        setState(() {
                          errorMessage = null; // Clear error when valid
                        });
                      } else {
                        setState(() {
                          errorMessage = localization.errPhone;
                        });
                      }
                    },
                  ),
                ),

                ElevatedButton(onPressed: () {
                  String phoneNumber = _phoneNumberEditingController.text.trim();

                  // Only allow an empty phone number or a valid one
                  if (phoneNumber.isNotEmpty && !isValidJordanianPhoneNumber(phoneNumber)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(localization.errPhone)),
                    );
                    return; // Stop further execution if the phone number is invalid
                  }

                  if(
                  _lastNameEditingController.text.isNotEmpty &&
                      _firstNameEditingController.text.isNotEmpty &&
                      _emailEditingController.text.isNotEmpty &&
                      _passEditingController.text.isNotEmpty
                  ){

                    if(_passEditingController.text == _confirmPassEditingController.text) {
                      BlocProvider.of<AuthCubit>(context).signin(
                          name: '${_firstNameEditingController
                              .text} ${_lastNameEditingController.text}',
                          email: _emailEditingController.text.trim(),
                          password: _passEditingController.text.trim(),
                          phoneNumber: _phoneNumberEditingController.text.trim(),
                          context: context
                      );
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(localization.confirmPassword))
                      );
                    }
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(localization.notCompleteData))
                    );
                  }


                },
                  child: Text(localization.signUp),
            
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green
            
                  ),
                ),
                TextButton(onPressed: () {
            
            
            
                  Navigator.pushNamed(context, LoginScreen.routeName);
                }, child:  Text(localization.account))
              ],
            ),
          ),
        );

  }
}


