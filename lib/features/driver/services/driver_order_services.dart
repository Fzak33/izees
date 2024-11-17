import 'package:dio/dio.dart';
import 'package:izees/models/order.dart';

import '../../../common/app_exception.dart';
import '../../../resources/strings_res.dart';
class DriverOrderServices {
  final Dio _dio = Dio();
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
    on DioException catch (e) {
      if (e.response != null && e.response?.data is Map<String, dynamic>) {
        final message = e.response?.data['message'] ?? 'Something went wrong';
        throw AppException(message);
      } else {
        throw AppException('Network error. Please try again.');
      }
    }
  }


  Future<Response> changeOrderStatus({required String id, required num status})async {
try {
  var data = {
    '_id': id,
    'status': status
  };

 Response res =  await _dio.post('${StringsRes.uri}/change-order-status', data: data);
 return res;
}
on DioException catch (e) {
  if (e.response != null && e.response?.data is Map<String, dynamic>) {
    final message = e.response?.data['message'] ?? 'Something went wrong';
    throw AppException(message);
  } else {
    throw AppException('Network error. Please try again.');
  }
}

  }


  Future<int> getOrderStatus({required String id})async {
    try {
      int status = 0;
      Response res = await _dio.get('${StringsRes.uri}/get-order-status/$id');
      status = res.data;
      return status;
    }
    on DioException catch (e) {
      if (e.response != null && e.response?.data is Map<String, dynamic>) {
        final message = e.response?.data['message'] ?? 'Something went wrong';
        throw AppException(message);
      } else {
        throw AppException('Network error. Please try again.');
      }
    }
  }


}