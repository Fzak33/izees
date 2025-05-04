import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../common/app_exception.dart';
import '../../models/sales.dart';
import '../services/admin_order_services.dart';
import '../services/admin_order_socket.dart';

part 'admin_order_state.dart';

class AdminOrderCubit extends Cubit<AdminOrderState> {
  final SocketAdminClient socketClient;
  final AdminOrderServices _adminOrderServices;

  final List<ProductProfit> _orders = [];
  late final StreamSubscription<ProductProfit> _subscription;

  AdminOrderCubit(this.socketClient, this._adminOrderServices) : super(AdminOrderInitial());

  late final StreamSubscription<String> _statusSub;

  Future<void> getAdminOrder(BuildContext context) async {
    emit(AdminOrderLoading());
    try {
      final res = await _adminOrderServices.getAdminProducts(context: context);
      _orders.clear();
      _orders.addAll(res);
      emit(AdminOrderSuccess(List.from(_orders.reversed)));

      // New order listener
      _subscription = socketClient.listenForOrders().listen((newOrder) {
        _orders.add(newOrder);
        emit(AdminOrderSuccess(List.from(_orders.reversed)));
      });

      // Status change listener to remove orders with status 2 or 3
      _statusSub = socketClient.listenForOrderStatusChanges().listen((orderId) {
        _orders.removeWhere((order) => order.id == orderId);
        emit(AdminOrderSuccess(List.from(_orders.reversed)));
      });
    } catch (e) {
      if (e is AppException) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred')),
        );
      }
      emit(AdminOrderSuccess(List.from(_orders.reversed)));
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    _statusSub.cancel();
    return super.close();
  }

}