import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/driver/services/driver_order_services.dart';
import 'package:meta/meta.dart';

import '../../../../models/order.dart';

part 'driver_order_state.dart';

class DriverOrderCubit extends Cubit<DriverOrderState> {
  DriverOrderCubit() : super(DriverOrderInitial());
  DriverOrderServices _driverOrderServices = DriverOrderServices();
  num s=1;
  Future<void> getDriverOrder()async{

    emit(DriverOrderLoading());

    try{

      final res = await _driverOrderServices.getDriverOrder();
      if(res.isEmpty || res.length == 0){
        emit(DriverOrderEmpty("there is no order's "));
      }else {
        emit(DriverOrderSuccess(res));
        print(res);
      }
    }
    catch(e){
      emit(DriverOrderFailed(e.toString()));
    }
  }

Future<void> changeOrderStatus({required String id, required num status})async{

     await _driverOrderServices.changeOrderStatus(
          id: id, status: status);

}
}
