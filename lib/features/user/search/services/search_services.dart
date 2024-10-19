import 'package:dio/dio.dart';
import 'package:izees/resources/strings_res.dart';

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
         // (data['products'] as List)
         //    .map((productJson) => Product.fromJson(productJson))
         //    .toList();
        return products;
      } else {
        throw Exception('Failed to search products: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      // Handle any other errors
      throw Exception('Unexpected error: $e');
    }
  }

}


