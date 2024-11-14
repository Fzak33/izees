import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/user/cart/widgets/price_details_widget.dart';
import 'package:izees/resources/strings_res.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/cart_cubit/cart_cubit.dart';
import 'Increment_and_decrement_quantity.dart';


class ProductViewWidget extends StatefulWidget {
  const ProductViewWidget({super.key});

  @override
  State<ProductViewWidget> createState() => _ProductViewWidgetState();
}

class _ProductViewWidgetState extends State<ProductViewWidget> {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return
      BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
           if(state is CartSuccess){
          }
        },

  builder: (context, state) {
if(state is CartLoading){
  return const Center(child: CircularProgressIndicator(),);
}
    else if(state is CartEmpty){
    return  Center(child: Text(state.empty),);
    }


    else if(state is CartSuccess){
    final  product = state.cart;
    double? sum = 0;
    Set<String?> storeNamesSet = {};
    for (var prod in product) {
      sum = (sum! + (prod.quantity! * prod.product!.price));
      if (prod.product?.storeName != null) {
        storeNamesSet.add(prod.product!.storeName);
      }
    }
    int uniqueStoreCount = storeNamesSet.length;
    int counter = driverPrice(uniqueStoreCount);

    print("Total Sum: $sum");
    print("Unique Store Count: $uniqueStoreCount");
    print("Counter: $counter");

  return Column(
    children: [
      ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: product.length,
        itemBuilder: (context, index) {
        final  prod = product[index];

      //  sum = (sum! + (prod.quantity! * prod.product!.price));

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  child: ListTile(
                      title: Text(prod.product!.name),
                      subtitle: Text((prod.product!.price * prod.quantity! ).toString() ),
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
      product.isEmpty ?const Center(child: Text('cart is Empty'),):
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: double.infinity,child: ElevatedButton(
        onPressed: (){
          Navigator.pushNamed(context, PriceDetailsWidget.routeName,arguments: {
            'totalPrice':sum,
            'driverPrice':counter
          });
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
  );
    }
//     else if (state is CartFailed) {
//   return Center(child: Text(state.err));
// }


else{
    return  const Center(child: Text('something occurd'),);
    }



  },
);
  }
}

int driverPrice(int uniqueStoreCount){
 int counter = 7;
  if (uniqueStoreCount == 1) {
  return  counter = 3;
  } else if (uniqueStoreCount == 2 || uniqueStoreCount == 3) {
  return  counter = 5;
  } else if (uniqueStoreCount <= 6) {
  return  counter = 7;
  } else {
  return  counter += (uniqueStoreCount - 6) * 2;
  }
}



