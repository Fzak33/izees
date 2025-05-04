
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:izees/resources/strings_res.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../models/sales.dart';

class SocketAdminClient {
  static SocketAdminClient? _instance;
  late IO.Socket socket;
  bool _isConnected = false;

  SocketAdminClient._internal();

  static SocketAdminClient get instance {
    _instance ??= SocketAdminClient._internal();
    return _instance!;
  }

  bool get isConnected => _isConnected;

  void connect(String token) {
    if (_isConnected) return;

    socket = IO.io(
      '${StringsRes.uri}/admin',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNew()
          .enableReconnection()
          .setExtraHeaders({'x-auth-token': token})
          .build(),
    );

    socket.onConnect((_) {
      _isConnected = true;
      debugPrint('✅ Admin socket connected');
    });

    socket.onDisconnect((_) {
      _isConnected = false;
      debugPrint('❌ Admin socket disconnected');
    });

    socket.onConnectError((err) {
      debugPrint('⚠️ Connect error: $err');
    });

    socket.onError((err) {
      debugPrint('🔥 Socket error: $err');
    });
  }

  Stream<ProductProfit> listenForOrders() {
    final controller = StreamController<ProductProfit>();

    socket.on('newOrder', (data) {
      try {
        if (data is List) {
          for (var item in data) {
            final profit = ProductProfit.fromJson(Map<String, dynamic>.from(item));
            controller.add(profit);
          }
        } else if (data is Map<String, dynamic>) {
          final profit = ProductProfit.fromJson(Map<String, dynamic>.from(data));
          controller.add(profit);
          debugPrint("the profit id is ${profit.id}");
        } else {
          debugPrint('Unexpected newOrder format: $data');
        }
      } catch (e) {
        debugPrint('Failed to parse newOrder data: $e');
      }
    });

    return controller.stream;
  }

  Stream<String> listenForOrderStatusChanges() {
    final controller = StreamController<String>();

    socket.on('orderStatusChanged', (data) {
      try {
        final orderId = data['orderId'];
        final status = data['status'];
        if (status == 2 || status == 3) {
          controller.add(orderId);
        }
      } catch (e) {
        debugPrint('⚠️ Failed to parse orderStatusChanged: $e');
      }
    });

    return controller.stream;
  }


  void dispose() {
    if (_isConnected) {
      socket.disconnect();
      socket.dispose();
      _isConnected = false;
      debugPrint('🧹 Admin socket disposed');
    }
  }
}