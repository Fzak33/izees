import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/driver/services/driver_order_services.dart';
import 'package:meta/meta.dart';

import '../../../../common/app_exception.dart';
import '../../../../models/order.dart';

part 'driver_order_state.dart';

class DriverOrderCubit extends Cubit<DriverOrderState> {
  DriverOrderCubit(this._driverOrderServices) : super(DriverOrderInitial());
  final DriverOrderServices _driverOrderServices ;
 final List<Order> _order =[];
  Future<void> getDriverOrder({required BuildContext context})async{

    emit(DriverOrderLoading());

    try{

      final res = await _driverOrderServices.getDriverOrder();
      if(res.isEmpty || res.isEmpty){
        emit(DriverOrderEmpty("there is no order's "));
      }else {
        _order.addAll(res);
        emit(DriverOrderSuccess(List.from(_order.reversed)));

      }
    }
    catch (e) {
      // if (e is AppException) {
      //
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text(e.message)),
      //   );
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('An unexpected error occurred')),
      //   );
      // }
      emit(DriverOrderSuccess(List.from(_order.reversed)));
    }
  }

  void scheduleHourlyFetch({required BuildContext context}) {
    getDriverOrder(context: context); // Initial fetch
    // Scheduling the fetch to repeat every hour
    Future.delayed(const Duration(hours: 1), () {
      getDriverOrder(context:  context);
      scheduleHourlyFetch(context: context); // Recursive call to repeat every hour
    });
  }


}
