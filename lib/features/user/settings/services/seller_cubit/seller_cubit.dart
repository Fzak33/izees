import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:izees/features/user/settings/services/seller.dart';
import 'package:meta/meta.dart';

part 'seller_state.dart';

class SellerCubit extends Cubit<SellerState> {
  SellerCubit() : super(SellerInitial());
  SellerServices sellerServices = SellerServices();
  Future<void> becomeASeller({required BuildContext context, required String storeName, required String branch})async{
    await sellerServices.seller( context: context, storeName: storeName, branch: branch);
  }
}
