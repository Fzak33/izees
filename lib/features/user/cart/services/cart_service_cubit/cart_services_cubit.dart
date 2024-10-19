import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:izees/features/user/cart/services/cart_services.dart';
import 'package:meta/meta.dart';

import '../../../../../models/cart_model.dart';

part 'cart_services_state.dart';

class CartServicesCubit extends Cubit<CartServicesState> {
  CartServicesCubit() : super(CartServicesInitial());
  final CartServices _cartServices = CartServices();

  Future<void> addToCart({required String id, required BuildContext context, })async{
 await _cartServices.addToCart(id:id,context:context);
  await getCart(context: context);

  }

  Future<void> order({required double sum, required BuildContext context})async{
    await _cartServices.order(sum: sum,context:context);
   await getCart(context: context);
  }

  Future<void> getCart({required BuildContext context})async{

    emit(CartServicesLoading());

    try{

      final res = await _cartServices.getCart(context: context);
      if(res.isEmpty || res.length == 0){
        emit(CartServicesEmpty("Cart is Empty "));
      }else {
        emit(CartServicesSuccess(cart: res));
        print('cart-------------------$res');
      }
    }
    catch(e){
      emit(CartServicesFailed(e.toString()));
    }
  }



  Future<void> addAddress({required String address, required BuildContext context, })async{
    await _cartServices.addAddress(address: address,context:context);
  }
}
