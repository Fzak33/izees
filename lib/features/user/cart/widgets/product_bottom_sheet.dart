import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../models/product_model.dart';
import '../../../../resources/strings_res.dart';
import '../services/cart_cubit/cart_cubit.dart';


class ProductBottomSheet extends StatefulWidget {
  final Product product;
final String user;
  const ProductBottomSheet({Key? key, required this.product, required this.user}) : super(key: key);

  @override
  State<ProductBottomSheet> createState() => _ProductBottomSheetState();
}

class _ProductBottomSheetState extends State<ProductBottomSheet> {
  int quantity = 1;

  void _increment() {
    setState(() {
      if(widget.product.quantity>= quantity) {
        quantity++;
       // totalPrice = totalPrice * quantity;
      }
      else{
        return;
      }
    });
  }

  void _decrement() {
    if (quantity > 1) {
      setState(() {
        quantity--;
        //totalPrice = totalPrice*quantity;

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    num totalPrice= widget.product.price * quantity;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(

            //color: Colors.green,
            height: MediaQuery
                .of(context)
                .size
                .height * 0.25,
            width: double.infinity,
            decoration: BoxDecoration(
              // shape: BoxShape.circle,

              image: DecorationImage(
                image: NetworkImage(
                    "${StringsRes.uri}/${widget.product.images[0]}"),
                fit: BoxFit.fitHeight,
              ),
            ),

          ),
          Text(
            widget.product.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Card(
            //margin: const EdgeInsets.only(left: 20, bottom: 28),
            child: SizedBox(
              width: 100,
              height: 50,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: _decrement,
                    child: const Icon(Icons.remove, size: 20),
                  ),
                  const SizedBox(width: 15),
                  Text(quantity.toString(), style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 15),
                  InkWell(
                    onTap: _increment,
                    child: const Icon(Icons.add, size: 20),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: () async {
              if(widget.user != ''){
                await context.read<CartCubit>().addToCart(
                  product: widget.product,
                  id: widget.product.id ?? '',
                  quantity: quantity,
                  context: context, // you're using this inside the Cubit
                );

              }
          else{
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please login first')),
                );
              }

              if (context.mounted) {
                Navigator.pop(context); // only after we're done using context
              }
          },

    child: Text("${localization.addToCart} $totalPrice ${localization.jod}",
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    style: TextStyle(color: Colors.white, fontSize: 16),
    ),
            style: ElevatedButton.styleFrom(

              minimumSize: const Size(double.infinity, 50),
              backgroundColor: ColorManager.primaryColor,

            ),
          ),
        ],
      ),
    );
  }
}