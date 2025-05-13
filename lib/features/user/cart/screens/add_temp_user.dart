import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/common/widgets/text_field.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:izees/resources/strings_res.dart';


import '../../../auth/auth_cubit/auth_cubit.dart';
import '../services/cart_cubit/cart_cubit.dart';



class AddTempUser extends StatefulWidget {
  static const String routeName = '/add-temp-user';
  const AddTempUser({super.key});

  @override
  State<AddTempUser> createState() => _AddTempUserState();
}

class _AddTempUserState extends State<AddTempUser> {
  String? errorMessage;

  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();

  final TextEditingController _street = TextEditingController();
  final TextEditingController _building = TextEditingController();
  final TextEditingController _neighborhood = TextEditingController();

  String city = "Amman";


  @override
  void dispose() {
    _phoneNumber.dispose();
    _lastName.dispose();
    _firstName.dispose();
    _street.dispose();
    _building.dispose();
    _neighborhood.dispose();
    super.dispose();
  }

  bool isValidJordanianPhoneNumber(String value) {
    final RegExp phoneRegExp = RegExp(r'^07[789]\d{7}$');
    return phoneRegExp.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    var auth = BlocProvider
        .of<AuthCubit>(context)
    ;
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.primaryColor,
        title: Text('please Enter Your information',
          style: TextStyle(
              color: Colors.black,
              fontSize: 24
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        
            CustomTextField(controller: _firstName, hintText: localization.firstName),
            CustomTextField(controller: _lastName, hintText: localization.lastName),
        
            CustomTextField(controller: _neighborhood, hintText: localization.neighborhood),
            CustomTextField(controller: _street, hintText: localization.street),
            CustomTextField(controller: _building, hintText: localization.building),
            TextField(
              controller: _phoneNumber,
              keyboardType: TextInputType.phone,
              maxLength: 10,  // Limit the phone number length to 10 digits
              decoration: InputDecoration(
                hintText: localization.phoneNumber,
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
            DropdownButton(
              hint:  Text(localization.choseYourCity),
              items: StringsRes.jordanCities().map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              )
              ).toList(),
              value: city,  onChanged: (String? newVal) {
              setState(() {
                city = newVal!;
              });
            },),
            ElevatedButton(onPressed: (){
              String phoneNumber = _phoneNumber.text.trim();
        
              // Only allow an empty phone number or a valid one
              if ( !isValidJordanianPhoneNumber(phoneNumber)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(localization.errPhone)),
                );
                return; // Stop further execution if the phone number is invalid
              }else{
                if(
                _neighborhood.text.isNotEmpty
                    && _street.text.isNotEmpty
                    && _building.text.isNotEmpty
                    && _phoneNumber.text.isNotEmpty
                    && _firstName.text.isNotEmpty
                    && _lastName.text.isNotEmpty
                ){
                  context.read<CartCubit>().addTempUser(
                      name: "${_firstName.text} ${_lastName.text}",
                      phoneNumber: phoneNumber,
        
                      address: "$city - ${_neighborhood.text} - ${_street.text} - ${_building.text}",
                      city: city,
                      context: context);
        
                  Navigator.pop(context);
                }else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(localization.errAddress)));
                }
              }
        
            },
        
              style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primaryColor
        
              ),
              child:  Text(localization.addAddress),
            ),
        
          ],
        ),
      ),
    );
  }
}
