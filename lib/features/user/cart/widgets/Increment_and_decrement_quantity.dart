import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/cart_model.dart';
import '../services/cart_service_cubit/change_quantity_cubit.dart';
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

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ChangeQuantityCubit>();
    cubit.getQuantity(productId: widget.prod.id ?? '', context: context);
  }

  Widget change(){
    setState(() {

    });
   if(   widget.prod.quantity == 1) {
    return  const Icon(Icons.delete_outline_rounded, color: Colors.green,);
   }
    return   const Text('-',style: TextStyle(fontSize: 20),);

  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangeQuantityCubit, Map<String,int>>(
  builder: (context, state) {
    final qty = state[widget.prod.id] ?? 0;
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
                    qty == 1 ?
                    context.read<ChangeQuantityCubit>().deleteProductFromCart(productId: widget.prod.id ?? '', context: context)
                        :
                    context.read<ChangeQuantityCubit>().decrementQuantity(
                        id: widget.prod.product?.id ?? '',
                        context: context,
                        productId: widget.prod.id ?? ''
                    );

                  }, child:

                  qty == 1 ?const Icon(Icons.delete_outline_rounded, color: Colors.green,):
                  const Icon(Icons.remove,size: 15,),),
                  SizedBox(width: 15,),
                  Text('$qty',style: TextStyle(fontSize: 15) ),
                  SizedBox(width: 15,),
                  InkWell( onTap: () {
                    context.read<ChangeQuantityCubit>().incrementQuantity(
                        id: widget.prod.product?.id ?? '',
                        context: context,
                        productId: widget.prod.id ?? ''
                    );
                  }, child: const Icon(Icons.add, size: 15,),),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  },
);
  }
}
