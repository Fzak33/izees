import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../common/app_exception.dart';
import '../../models/sales.dart';
import '../services/admin_order_services.dart';
import '../services/admin_order_socket.dart';

part 'admin_order_state.dart';

class AdminOrderCubit extends Cubit<AdminOrderState> {
  AdminOrderCubit( this._adminOrderServices) : super(AdminOrderInitial());

  final AdminOrderSocket _adminOrderSocket = AdminOrderSocket();
  final AdminOrderServices _adminOrderServices;
  void init(BuildContext context){
    _adminOrderSocket.connect(context);
    getAdminOrder(context);
  }
final List<ProductProfit> _order = [];

  Future<void> getAdminOrder( BuildContext context)async{
emit(AdminOrderLoading());
try{
 final res =  await _adminOrderServices.getAdminProducts(context: context);
 _order.addAll(res);
  emit(AdminOrderSuccess(List.from(_order.reversed)));
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
  emit(AdminOrderSuccess(List.from(_order.reversed)));
}
  }


  void scheduleHourlyFetchOrder({required BuildContext context}) {
    getAdminOrder(context); // Initial fetch
    // Scheduling the fetch to repeat every hour
    Future.delayed(const Duration(hours: 1), () {
      getAdminOrder( context);
      scheduleHourlyFetchOrder(context: context); // Recursive call to repeat every hour
    });
  }


}
