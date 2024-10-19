import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../../models/profit.dart';
import '../services/admin_order_socket.dart';

part 'admin_order_state.dart';

class AdminOrderCubit extends Cubit<AdminOrderState> {
  AdminOrderCubit() : super(AdminOrderInitial());

  AdminOrderSocket _adminOrderSocket = AdminOrderSocket();
  
  void init(BuildContext context){
    _adminOrderSocket.connect(context);
    getAdminOrder(context);
  }


  Future<void> getAdminOrder( BuildContext context)async{
emit(AdminOrderLoading());
try{
 var res =  _adminOrderSocket.getAdminOrder1();
  emit(AdminOrderSuccess(res));
}catch(e){
  emit(AdminOrderFailed(e.toString()));
}
  }

}
