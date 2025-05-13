import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/user/cart/services/cart_cubit/cart_cubit.dart';
import 'package:izees/resources/strings_res.dart';

import '../../../../models/cart_model.dart';
class IncrementAndDecrementQuantity extends StatefulWidget {
  const IncrementAndDecrementQuantity({
    super.key,
    required this.prod,
  });

  final Cart prod;

  @override
  State<IncrementAndDecrementQuantity> createState() => _IncrementAndDecrementQuantityState();
}

class _IncrementAndDecrementQuantityState extends State<IncrementAndDecrementQuantity> {

  // @override
  // void initState() {
  //   super.initState();
  //   final cubit = context.read<ChangeQuantityCubit>();
  //   cubit.getQuantity(productId: widget.prod.id ?? '', context: context);
  // }

  Widget change(){
    setState(() {

    });
   if(   widget.prod.quantity == 1) {
    return  const Icon(Icons.delete_outline_rounded, color: ColorManager.primaryColor,);
   }
    return   const Text('-',style: TextStyle(fontSize: 20),);

  }


  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(right:10.0,),
      child: ListTile(

        trailing: SizedBox(
          width:100,
          child: Card(
            margin:const EdgeInsets.only(left: 20 , bottom: 28),     //   margin:EdgeInsets.all(1),
            child: SizedBox(
              width: 70,
              child: Row(

                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(onTap: () {
                    widget.prod.quantity == 1 ?
                    context.read<CartCubit>().deleteProductFromCart(

                        cartId: widget.prod.id ?? '',productId: widget.prod.product?.id ?? '', context: context)
                        :
                    context.read<CartCubit>().decrementQuantity(
                        id: widget.prod.product?.id ?? '',
                        context: context,
                        cartId: widget.prod.id ?? ''
                    );

                  }, child:

                  widget.prod.quantity == 1 ?const Icon(Icons.delete_outline_rounded, color: ColorManager.primaryColor,):
                  const Icon(Icons.remove,size: 15,),),
                  const SizedBox(width: 15,),
                  Text('${widget.prod.quantity}',style: const TextStyle(fontSize: 15) ),
                  const SizedBox(width: 15,),
                  InkWell( onTap: () {
                    context.read<CartCubit>().incrementQuantity(
                        id: widget.prod.product?.id ?? '',
                        context: context,
                        cartId: widget.prod.id ?? ''
                    );
                  }, child: const Icon(Icons.add, size: 15,),),
                ],
              ),
            ),
          ),
        ),
      ),
    );

  }
}
