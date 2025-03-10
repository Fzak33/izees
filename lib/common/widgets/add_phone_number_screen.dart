import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/common/services/common_cubit/common_cubit.dart';
import 'package:izees/features/auth/auth_cubit/auth_cubit.dart';
import 'package:izees/resources/strings_res.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../features/user/cart/services/cart_cubit/cart_cubit.dart';
import '../../features/user/cart/widgets/price_details_widget.dart';

class AddPhoneNumberScreen extends StatefulWidget {
  static const String routeName = '/add-phone-number';

  const AddPhoneNumberScreen({super.key});

  @override
  State<AddPhoneNumberScreen> createState() => _AddPhoneNumberScreenState();
}

class _AddPhoneNumberScreenState extends State<AddPhoneNumberScreen> {
  TextEditingController _phoneNumberEditingController = TextEditingController();
  String? errorMessage;

  bool isValidJordanianPhoneNumber(String value) {
    final RegExp phoneRegExp = RegExp(r'^07[789]\d{7}$');
    return phoneRegExp.hasMatch(value);
  }

  @override
  void dispose() {
    super.dispose();
    _phoneNumberEditingController.dispose();

  }

  @override
  Widget build(BuildContext context) {
    final _auth = context.read<AuthCubit>();
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(backgroundColor: ColorManager.primaryColor,),
       body: Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: TextField(
                 controller: _phoneNumberEditingController,
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
             ),
             SizedBox(height: 20,),

             ElevatedButton(onPressed: () {
               String phoneNumber = _phoneNumberEditingController.text.trim();

               // Only allow an empty phone number or a valid one
               if ( !isValidJordanianPhoneNumber(phoneNumber)) {
                 ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(content: Text(localization.errPhone)),
                 );
                 return; // Stop further execution if the phone number is invalid
               }else{
                    context.read<CommonCubit>().addPhoneNumber(phoneNumber: phoneNumber, context: context);
                    String role = _auth.authModel.role?.toString() ?? _auth.adminModel.role?.toString() ?? '';
                  final sum =   context.read<CartCubit>().totalPrice;
                  final driverPrice =   context.read<CartCubit>().driverPrice;



                    if(role == 'user'){
                      Navigator.pushNamed(context, PriceDetailsWidget.routeName,arguments: {
                        'totalPrice':sum,
                        'driverPrice':driverPrice
                      });


                    }else{
                      Navigator.pop(context);
                    }
               }
             },
               child: Text(localization.add),

               style: ElevatedButton.styleFrom(
                   backgroundColor: ColorManager.primaryColor,
                 minimumSize: const Size(double.infinity, 50),

               ),
             ),


           ],
         ),
       ),
    );
  }
}
