import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/driver/services/driver_order_services.dart';

class ChangeStatus extends Cubit<Map<String,int>> {
  final DriverOrderServices _driverOrderServices;

  ChangeStatus(this._driverOrderServices) :  super({});

  // Fetch the initial number from backend
  Future<void> getOrderStatus({required String id}) async {
    try {
      final status = await _driverOrderServices.getOrderStatus(id: id);
      emit({...state, id:status });
    } catch (e) {
      emit({...state, id: 0}); // Default to 0 in case of error
    }
  }
  Future<void> incrementStatus({required String id}) async {
    final currentStatus = state[id] ?? 0;
    final newStatus = currentStatus + 1 ;
    emit({...state,id: newStatus});

    try {
      await _driverOrderServices.changeOrderStatus(id: id, status: newStatus);
    } catch (e) {
      // Handle any error here (optional: revert to the previous state if the update fails)
      emit({...state , id: currentStatus}); // Revert the state if backend update fails
    }
  }



}