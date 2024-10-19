import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/user/cart/services/cart_services.dart';

import 'cart_services_cubit.dart';

class ChangeQuantityCubit extends Cubit<Map<String,int>> {
  final CartServices _cartServices;

  ChangeQuantityCubit(this._cartServices) :  super({});

  // Fetch the initial number from backend
  Future<void> getQuantity({required String productId,required BuildContext context}) async {
    try {
      final status = await _cartServices.getQuantity(productId: productId, context: context);
      emit({...state, productId:status });
    } catch (e) {
      emit({...state, productId: 1}); // Default to 0 in case of error
    }
  }
  Future<void> incrementQuantity({required String id,required BuildContext context,required String productId}) async {
    final currentQuantity = state[productId] ?? 0;
    final newQuantity = currentQuantity + 1 ;


    try {
    final q =  await _cartServices.incrementOrDecrementQuantity(
          productId: productId,
          quantity: newQuantity,
          id: id,
          context: context
      );
      emit({...state,productId: q});
    } catch (e) {
      // Handle any error here (optional: revert to the previous state if the update fails)
      emit({...state , productId: currentQuantity}); // Revert the state if backend update fails
    }
  }

  Future<void> decrementQuantity({required String id,required BuildContext context,required String productId}) async {
    final currentQuantity = state[productId] ?? 0;
    final newQuantity = currentQuantity - 1 ;


    try {
      final q =  await _cartServices.incrementOrDecrementQuantity(
          productId: productId,
          quantity: newQuantity,
          id: id,
          context: context
      );
      emit({...state,productId: q});
    } catch (e) {
      // Handle any error here (optional: revert to the previous state if the update fails)
      emit({...state , productId: currentQuantity}); // Revert the state if backend update fails
    }
  }

  Future<void> deleteProductFromCart({required String productId,required BuildContext context}) async {
    try {
       await _cartServices.deleteProductFromCart(productId: productId, context: context);
       final newState = Map<String, int>.from(state);
       newState.remove(productId);
      emit(newState);
      BlocProvider.of<CartServicesCubit>(context).getCart(context: context);
    } catch (e) {
      //emit({...state, productId: 0}); // Default to 0 in case of error
    }
  }
}