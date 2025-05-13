import 'package:flutter/material.dart';
import 'package:izees/resources/strings_res.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/auth_cubit/auth_cubit.dart';

class SocketUserClient {
  static SocketUserClient? _instance;
  late IO.Socket socket;
  bool _isConnected = false;

  SocketUserClient._internal();

  static SocketUserClient get instance {
    _instance ??= SocketUserClient._internal();
    return _instance!;
  }

  bool get isConnected => _isConnected;

  void connect(String token) {
    if (_isConnected) return;

    socket = IO.io(
      '${StringsRes.uri}/user',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNew()
          .enableReconnection()
          .setExtraHeaders({'x-auth-token': token})
          .build(),
    );

    socket.onConnect((_) {
      _isConnected = true;
      debugPrint('✅ User socket connected');
    });

    socket.onDisconnect((_) {
      _isConnected = false;
      debugPrint('❌ User socket disconnected');
    });

    socket.onConnectError((err) {
      debugPrint('⚠️ User connect error: $err');
    });

    socket.onError((err) {
      debugPrint('🔥 User socket error: $err');
    });
  }

  void placeOrder({
    required double totalPrice,
    required BuildContext context,
    required void Function(String orderId) onSuccess,
    required void Function(String error) onError,
  })  {
    final auth = context.read<AuthCubit>();
    connect(auth.authModel.token!);

    final data = {
      'totalPrice': totalPrice,
      'address': auth.authModel.address,
    };

    socket.emitWithAck('placeOrder', data, ack: (response) async {
      if (response != null && response is Map && response['success'] == true) {
        onSuccess(response['orderId']);
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('local_cart');
      } else {
        onError(response?['message'] ?? 'Something went wrong');
      }
    });

  }

  void dispose() {
    if (_isConnected) {
      socket.disconnect();
      socket.dispose();
      _isConnected = false;
      debugPrint('🧹 User socket disposed');
    }
  }
}
