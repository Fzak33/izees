import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/common/widgets/text_field.dart';
import 'package:izees/features/auth/screens/signin_screen.dart';
import 'package:izees/features/user/cart/services/cart_service_cubit/cart_services_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../auth/auth_cubit/auth_cubit.dart';



class AddAddressScreen extends StatefulWidget {
  static const String routeName = '/address';
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  TextEditingController _addressEditingController = TextEditingController();


  @override
  void dispose() {
    super.dispose();
    _addressEditingController.dispose();

  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    var auth = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextField(controller: _addressEditingController, hintText: localization.address,),


          ElevatedButton(onPressed: (){
            if(_addressEditingController.text.isNotEmpty){
              context.read<CartServicesCubit>().addAddress(address: _addressEditingController.text, context: context);
              Navigator.pop(context);

            }else{
              ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(content: Text(localization.errAddress)));
            }

          },

            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green

            ),
            child:  Text(localization.addAddress),
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
