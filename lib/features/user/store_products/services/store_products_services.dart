

import 'package:dio/dio.dart';

import '../../../../common/app_exception.dart';
import '../../../../models/product_model.dart';
import '../../../../resources/strings_res.dart';

class StoreProductsServices {
  final Dio _dio = Dio();


  Future<List<Product>> showStoreProducts({String? storeName, List<String> exclude = const []}) async {
    try {
      String url = storeName == null ? StringsRes.uri : "${StringsRes.uri}/show-store-product/$storeName";
      String excludeQuery = exclude.isNotEmpty ? "?exclude=${exclude.join(',')}" : "";

      final response = await _dio.get("$url$excludeQuery");

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['products'];
        return data.map((json) => Product.fromJson(json)).toList();
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data is Map<String, dynamic>) {
        final message = e.response?.data['message'] ?? 'Something went wrong';
        throw AppException(message);
      } else {
        throw AppException('Network error. Please try again.');
      }
    }
    return []; // Default response if error occurs
  }


}