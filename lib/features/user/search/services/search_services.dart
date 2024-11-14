import 'package:dio/dio.dart';
import 'package:izees/resources/strings_res.dart';

import '../../../../common/app_exception.dart';
import '../../../../models/product_model.dart';

class SearchServices {


  final Dio _dio = Dio();


  Future<List<Product>> searchProducts({
    required String name,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        '${StringsRes.uri}/search',
        queryParameters: {
          'name': name,
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );
      List<Product> products =[];
      if (response.statusCode == 200) {
        final data = response.data;
        for(var i in data['prod']){
          products.add(Product.fromJson(i));
        }

        return products;
      } else {
        throw Exception('Failed to search products: ${response.statusMessage}');
      }
    }  on DioException catch (e) {
      if (e.response != null && e.response?.data is Map<String, dynamic>) {
        final message = e.response?.data['message'] ?? 'Something went wrong';
        throw AppException(message);
      } else {
        throw AppException('Network error. Please try again.');
      }
    }
  }

}


