import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../app_exception.dart';
import '../common_services.dart';

part 'common_state.dart';

class CommonCubit extends Cubit<CommonState> {
  CommonCubit(this._commonServices) : super(CommonInitial());
  final CommonServices _commonServices;

  Future<void> addPhoneNumber({required String phoneNumber, required BuildContext context})async{
    try{
      await _commonServices.addPhoneNumber(phoneNumber: phoneNumber, context: context);
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
