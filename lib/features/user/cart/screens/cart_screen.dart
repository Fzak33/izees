import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/auth/auth_cubit/auth_cubit.dart';

import '../widgets/product_view_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
final auth = BlocProvider.of<AuthCubit>(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: auth.authModel.id == null?const Center(
         child:  Text('Cart is Empty !')
        ):
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: const ProductViewWidget(),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
