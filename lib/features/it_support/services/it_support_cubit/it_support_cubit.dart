import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:izees/features/it_support/services/it_support_services.dart';
import 'package:izees/models/temp_admin.dart';
import 'package:meta/meta.dart';

import '../../../../common/app_exception.dart';

part 'it_support_state.dart';

class ItSupportCubit extends Cubit<ItSupportState> {
  ItSupportCubit(this._itSupportServices) : super(ItSupportInitial());
  final ItSupportServices _itSupportServices;
  List<TempAdmin> _tempAdmin = [];

  Future<void> getTempAdmin({required BuildContext context})async{
    try{
      final res = await _itSupportServices.getTempAdmin(context: context);
      _tempAdmin.addAll(res);
      emit(ItSupportSuccess(List.from(_tempAdmin)));
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
      // Keep the state as CartSuccess
      emit(ItSupportSuccess(List.from(_tempAdmin)));

    }
  }

  Future<void> changeIntoAdmin({required String id,required BuildContext context})async{
    try{
   final res=   await _itSupportServices.addANewSeller(id: id, context: context);
      if(res.statusCode == 200){
        _tempAdmin.removeWhere((temp)=> temp.id == id);
        emit(ItSupportSuccess(List.from(_tempAdmin)));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed')),
        );

        emit(ItSupportSuccess(List.from(_tempAdmin)));

      }

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
      // Keep the state as CartSuccess
        emit(ItSupportSuccess(List.from(_tempAdmin)));

      }
      }


  void scheduleHourlyFetch({required BuildContext context}) {
    getTempAdmin(context: context); // Initial fetch
    // Scheduling the fetch to repeat every hour
    Future.delayed(Duration(hours: 1), () {
      getTempAdmin(context: context);
      scheduleHourlyFetch(context: context); // Recursive call to repeat every hour
    });
  }


}
