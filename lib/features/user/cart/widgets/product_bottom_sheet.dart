import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../models/product_model.dart';
import '../../../../resources/strings_res.dart';
import '../services/cart_cubit/cart_cubit.dart';


class ProductBottomSheet extends StatefulWidget {
  final Product product;
final String user;
int? colorIndex;
   ProductBottomSheet({Key? key, required this.product, required this.user , required this.colorIndex}) : super(key: key);

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
//                    "${StringsRes.uri}/${widget.product.images[widget.colorIndex!]}"),
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center( // center image inside the box
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12), // less than outer radius
                child: Image.network(
                    "${StringsRes.uri}/${widget.product.images[widget.colorIndex!]}",
                  height: MediaQuery.of(context).size.height * 0.18,
                  width: MediaQuery.of(context).size.width * 0.4,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Text(
            widget.product.name,
            style: FontStyles.homeName,
            maxLines: 2,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: () async {
                if(widget.user != ''){
                  final selectedColorName = widget.colorIndex != null
                      ? widget.product.colors[widget.colorIndex!].name
                      : 'Default';

                  await context.read<CartCubit>().addToCart(
                    product: widget.product,
                    id: widget.product.id ?? '',
                    quantity: quantity,
                    colorIndex: widget.colorIndex!,
                    colorName: selectedColorName,
                    image:  widget.product.colors[widget.colorIndex!].image,
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
                style: FontStyles.addToCart,
                ),
              style: ElevatedButton.styleFrom(

                minimumSize: const Size(double.infinity, 50),
                backgroundColor: ColorManager.primaryColor,

              ),
            ),
          ),

        ],
      ),
    );
  }
}