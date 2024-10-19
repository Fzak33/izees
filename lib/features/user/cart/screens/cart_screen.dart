import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/product_view_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: ProductViewWidget(),
              ),
              // BlocBuilder<CartServicesCubit, CartServicesState>(
              //   builder: (context, state) {
              //     if(state is CartServicesEmpty){
              //       return Container();
              //     }else{
              //       return PriceDetailsWidget(totalPrice: 5,);
              //     }
              //
              //   },
              // )
            ],
          ),
        ),
      ),
    );
  }
}
