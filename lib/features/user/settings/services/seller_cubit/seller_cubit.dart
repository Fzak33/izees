import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:izees/features/user/settings/services/seller.dart';
import 'package:meta/meta.dart';

import '../../../../../common/app_exception.dart';

part 'seller_state.dart';

class SellerCubit extends Cubit<SellerState> {
  SellerCubit() : super(SellerInitial());
  SellerServices sellerServices = SellerServices();
  Future<void> becomeASeller({required String storeName,required String address,required String cityStore ,required BuildContext context})async{
  try {
    await sellerServices.seller(context: context,
        storeName: storeName,
        address: address,
        cityStore: cityStore);
  }
  catch (e) {
    if (e is AppException) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred')),
      );
    }

  }
  }
}
