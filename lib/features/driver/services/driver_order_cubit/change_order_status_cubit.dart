import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/driver/services/driver_order_services.dart';

import '../../../../common/app_exception.dart';
import '../driver_socket.dart';

class ChangeStatus extends Cubit<Map<String,int>> {
  final DriverOrderServices _driverOrderServices;

  ChangeStatus(this._driverOrderServices) :  super({});

  // Fetch the initial number from backend
  Future<void> getOrderStatus({required String id, required BuildContext context}) async {
    try {
      final status = await _driverOrderServices.getOrderStatus(id: id);
      emit({...state, id:status });
    } catch (e) {
      if (e is AppException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred')),
        );
      }
      emit({...state, id: 0}); // Default to 0 in case of error
    }
  }
  Future<void> incrementStatus({
    required String id,
    required BuildContext context,
  }) async {
    final currentStatus = state[id] ?? 0;
    final newStatus = currentStatus + 1;
    emit({...state, id: newStatus});

    try {
      // Use SocketDriverClient instead of HTTP service
      SocketDriverClient.instance.changeOrderStatus(
        orderId: id,
        status: newStatus,
        onSuccess: () {
          // You can show success feedback if needed
          debugPrint('🚚 Status updated via socket');
        },
        onError: (error) {
          // Revert on error
          emit({...state, id: currentStatus});
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error)),
          );
        },
      );
    } catch (e) {
      emit({...state, id: currentStatus});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred')),
      );
    }
  }



}