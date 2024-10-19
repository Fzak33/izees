import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/auth/auth_cubit/auth_cubit.dart';
import 'package:izees/features/user/cart/services/cart_service_cubit/cart_services_cubit.dart';
import 'package:izees/features/user/cart/widgets/price_details_widget.dart';
import 'package:izees/models/cart_model.dart';
import 'package:izees/resources/strings_res.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'Increment_and_decrement_quantity.dart';


class ProductViewWidget extends StatelessWidget {
  const ProductViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    var auth = BlocProvider.of<AuthCubit>(context);
    double sum=0;
    //auth.authModel.cart.map((e) => sum+= e.quantity !* e.product!.price  ).toList();
    return


      BlocBuilder<CartServicesCubit, CartServicesState>(
  builder: (context, state) {
if(state is CartServicesLoading){
  return const Center(child: CircularProgressIndicator(),);
}
    else if(state is CartServicesEmpty){
    return  Center(child: Text(state.empty),);
    }
    else if(state is CartServicesFailed){
    return  Center(child: Text(state.err),);
    }

    else if(state is CartServicesSuccess){
    final  product = state.cart;
    double? sum = 0;
  return Column(
    children: [
      ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: product.length,
        itemBuilder: (context, index) {
        final  prod = product[index];

        sum = (sum! + (prod.quantity! * prod.product!.price));
        print (sum);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  child: ListTile(
                      title: Text(prod.product!.name),
                      subtitle: Text('${prod.product?.price}' ),
                      trailing:
                      Container(
                        height: 100,
                        width:  100,
                        decoration:    BoxDecoration(
                          shape: BoxShape.rectangle,
                          image:  DecorationImage(image: NetworkImage("${StringsRes.uri}/${prod.product?.images[0].path}") ,)  ,
                        ),
                      )
                  ),
                ),
                IncrementAndDecrementQuantity(prod: prod),
              ],
            ),
          );
        },


      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: double.infinity,child: ElevatedButton(
        onPressed: (){
        //  print("your cart is -------------${auth.authModel.cart?[0]}");
          Navigator.pushNamed(context, PriceDetailsWidget.routeName,arguments: sum);
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
  );
    }


    else{
    return  const Center(child: Text('something occurd'),);
    }



  },
);
  }
}





