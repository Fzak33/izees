import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/auth/auth_cubit/auth_cubit.dart';
import 'package:izees/features/user/cart/screens/add_address_screen.dart';
import 'package:izees/features/user/cart/services/cart_service_cubit/cart_services_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../models/cart_model.dart';

class PriceDetailsWidget extends StatelessWidget {
  static const  routeName= '/price-details-widget';
  double? totalPrice;



   PriceDetailsWidget({super.key, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    var auth = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ListTile(
            title: Text(localization.totalOrderPrice),
            trailing: Text("$totalPrice"),
          ),
          // ListTile(
          //   title: Text('fee'),
          //   trailing: Text('0.3'),
          // ),
          // ListTile(
          //   title: Text('Delivery'),
          //   trailing: Text('3'),
          // ),
          Divider(),
          ListTile(
            title: Text(localization.totalPrice),
            trailing: Text('$totalPrice'),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity,child: ElevatedButton(
              onPressed: (){
                if(auth.authModel.address == ''||  auth.authModel.address == null){
                  Navigator.pushNamed(context, AddAddressScreen.routeName);
                }else{

                  List<Cart>?   cart = auth.authModel.cart?.whereType<Cart>().toList();
                  double sum = totalPrice!;
                  String address =  auth.authModel.address ?? '';
                 // print('your cart is -------------------- $cart and your address is ----- ${auth.authModel.address}');
                  BlocProvider.of<CartServicesCubit>(context).order
                    (
                      sum:sum,
                      context: context
                  );
                }
              },
              child: Text(localization.pay, style: TextStyle(
                color: Colors.black,
                fontSize: 15
              ),),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent
            ),
          ),
      
          ),
        ],
      ),
    );
  }
}
