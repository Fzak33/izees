import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/auth/auth_cubit/auth_cubit.dart';
import 'package:izees/features/user/settings/services/seller.dart';

import '../../../../../common/app_exception.dart';

part 'seller_state.dart';

class SellerCubit extends Cubit<SellerState> {
  SellerCubit(this.sellerServices,this.resetApp) : super(SellerInitial());
  SellerServices sellerServices ;

  final VoidCallback resetApp;


  Future<void> becomeASeller({required String phoneNumber,required String storeName,required String address,required String cityStore ,required BuildContext context})async{
  try {
    await sellerServices.seller(
        context: context,
        storeName: storeName,
        address: address,
        cityStore: cityStore,
      phoneNumber: phoneNumber
    );
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

  Future<void> deleteMyAccount({
    required String password,required BuildContext context})async{
    try {
     final res = await sellerServices.deleteMyAccount(
          context: context,
          password: password,
           );
if(res.statusCode == 200){
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('delete it success')),
  );
  context.read<AuthCubit>().logOut(context: context);

}else{
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('An unexpected error occurred, failed to delete')),
  );
}
    }
    catch (e) {
      if (e is AppException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),

        );
        print("your problem is    ${e.toString()}");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred')),
        );
      }
      print("your problem is now   ${e.toString()}");

    }
  }





}
