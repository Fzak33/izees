import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/auth/auth_cubit/auth_cubit.dart';
import 'package:izees/features/user/cart/screens/add_address_screen.dart';
import 'package:izees/features/user/cart/screens/add_temp_user.dart';

import '../services/cart_cubit/cart_cubit.dart';
import '../services/cart_socket.dart';

class PriceDetailsWidget extends StatelessWidget {
  static const  routeName= '/price-details-widget';
  double? totalPrice;
  int driverPrice;


   PriceDetailsWidget({super.key, required this.totalPrice, required this.driverPrice});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    var auth = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            title: Text(localization.totalOrderPrice),
            trailing: Text("$totalPrice"),
          ),
          ListTile(
            title: Text(localization.delivery),
            trailing: Text('$driverPrice'),
          ),
          const Divider(),
          ListTile(
            title: Text(localization.totalPrice),
            trailing: Text((driverPrice+ totalPrice!).toString()),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity,child: ElevatedButton(
              onPressed: (){

                if(auth.authModel.token != null) {
                  if (auth.authModel.address == '' ||
                      auth.authModel.address == null) {
                    Navigator.pushNamed(context, AddAddressScreen.routeName);
                  }
                  else {
                    double sum = totalPrice!;

                    context.read<CartCubit>().order(sum: sum, context: context);

                    context.read<CartCubit>().setToZero();
                  }
                }else{
                Navigator.pushNamed(context, AddTempUser.routeName);
                }
              },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent
            ),
              child: Text(localization.pay, style: const TextStyle(
                color: Colors.black,
                fontSize: 15
              ),),
          ),
      
          ),
        ],
      ),
    );
  }
}
