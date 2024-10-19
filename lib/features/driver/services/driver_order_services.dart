import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/models/order.dart';

import '../../../resources/strings_res.dart';
import '../../auth/auth_cubit/auth_cubit.dart';
class DriverOrderServices {
  Dio _dio = Dio();
  Future< List<Order> > getDriverOrder()async{

    try {


      Response res = await _dio.get('${StringsRes.uri}/get-driver-order',
          options: Options(
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',

              }

          )
      );
      List<Order> order = [];
      if (res.statusCode == 200) {
        for (var i in res.data) {
          order.add(Order.fromJson(i));
        }
      }

      return order;
    }
    catch(e){
      print(e.toString());
      throw e.toString();
    }
  }


  Future<void> changeOrderStatus({required String id, required num status})async {


    var data ={
      '_id':id,
      'status':status
    };

   await _dio.post('${StringsRes.uri}/change-order-status', data: data);



  }


  Future<int> getOrderStatus({required String id})async {
    int status = 0;
     Response res =  await _dio.get('${StringsRes.uri}/get-order-status/$id');
     status  = res.data;
  return status;
  }


}