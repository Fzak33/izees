import 'package:flutter/material.dart';
import 'package:izees/resources/strings_res.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketDriverClient {
  static SocketDriverClient? _instance;
  late IO.Socket socket;
  bool _isConnected = false;

  SocketDriverClient._internal();

  static SocketDriverClient get instance {
    _instance ??= SocketDriverClient._internal();
    return _instance!;
  }

  bool get isConnected => _isConnected;

  void connect() {
    if (_isConnected) return;

    socket = IO.io(
      '${StringsRes.uri}/driver',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNew()
          .enableReconnection()
          .build(),
    );

    socket.onConnect((_) {
      _isConnected = true;
      debugPrint('✅ Driver socket connected');
    });

    socket.onDisconnect((_) {
      _isConnected = false;
      debugPrint('❌ Driver socket disconnected');
    });

    socket.onConnectError((err) {
      debugPrint('⚠️ Driver connect error: $err');
    });

    socket.onError((err) {
      debugPrint('🔥 Driver socket error: $err');
    });
  }

  void changeOrderStatus({
    required String orderId,
    required int status,
    required void Function() onSuccess,
    required void Function(String error) onError,
  }) {
    final data = {
      '_id': orderId,
      'status': status,
    };

    socket.emitWithAck('changeOrderStatus', data, ack: (response) {
      if (response != null && response is Map && response['status'] == status) {
        onSuccess();
      } else {
        onError(response?['message'] ?? 'Failed to change order status');
      }
    });
  }

  void dispose() {
    if (_isConnected) {
      socket.disconnect();
      socket.dispose();
      _isConnected = false;
      debugPrint('🧹 Driver socket disposed');
    }
  }
}
