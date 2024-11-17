
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/auth/auth_cubit/auth_cubit.dart';
import 'package:izees/models/profit.dart';
import 'package:izees/resources/strings_res.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class AdminOrderSocket{
  late IO.Socket _socket;



  _connectSocket() {
    _socket.onConnect((data) => print('Connection established'));
    _socket.onConnectError((data) => print('Connect Error: $data'));
    _socket.onDisconnect((data) => print('Socket.IO server disconnected'));
    
  }

  // List<dynamic> getAdminOrder(){
  //   List<dynamic> profit;
  //   _socket.on('admin-profits',(data){
  //
  //     if(data['action'] == 'admin order'){
  //     profit = data['profit'];
  //     }
  //   }
  //
  //   );
  //   return profit;
  // }
  List<Profit> getAdminOrder1()  {
    //final Completer<List<dynamic>> completer = Completer<List<dynamic>>();
List<Profit> profits= [];
    _socket.on('admin-profit', (data) {
      print(data);
      if (data['action'] == 'admin order') {
        print(data['profits']);
        final List<dynamic> profit = data['profits']['profits'];
            profits = profit.map((json)=> Profit.fromJson(json)).toList();
print(profits);
      }
    });

    return profits;
  }


  // Future<List<dynamic>> getAdminOrder() async {
  //   final Completer<List<dynamic>> completer = Completer<List<dynamic>>();
  //
  //   // Listen to 'admin-profits' event
  //   _socket.on('admin-profits', (data) {
  //     if (data['action'] == 'admin order') {
  //       final List<dynamic> profit = data['profit'];
  //       // Complete the future when data is received
  //       completer.complete(profit);
  //     }
  //   });
  //
  //   // Wait until the future is completed with the data
  //   return completer.future;
  // }


void connect(BuildContext context) {
  var auth = BlocProvider.of<AuthCubit>(context);
  //Important: If your server is running on localhost and you are testing your app on Android then replace http://localhost:3000 with http://10.0.2.2:3000
  _socket = IO.io(
    StringsRes.uri,
    IO.OptionBuilder().setTransports(['websocket']).setExtraHeaders({"x-auth-token":auth.adminModel.token}).build(),
  );
  _connectSocket();
  getAdminOrder1();
}


}