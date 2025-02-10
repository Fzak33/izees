

import 'package:dio/dio.dart';
import 'package:izees/models/product_model.dart';
import 'package:izees/resources/strings_res.dart';

import '../../../../common/app_exception.dart';

class ShowProductServices{
  final Dio _dio = Dio();


  // Future<List<Product>> showProducts()async{
  //   try {
  //     List<Product> products = [];
  //     Response res = await _dio.get("${StringsRes.uri}/show-products", options: Options(
  //       headers: {
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       }
  //     ));
  //     for (var i in res.data) {
  //       products.add(Product.fromJson(i));
  //     }
  //
  //     return products;
  //   }
  //   on DioException catch (e) {
  //     if (e.response != null && e.response?.data is Map<String, dynamic>) {
  //       final message = e.response?.data['message'] ?? 'Something went wrong';
  //       throw AppException(message);
  //     } else {
  //       throw AppException('Network error. Please try again.');
  //     }
  //   }
  //
  // }


  Future<List<Product>> fetchProducts(List<String> exclude) async {
    try {
      String excludeQuery = exclude.isNotEmpty ? "?exclude=${exclude.join(',')}" : "";
      final response = await _dio.get("${StringsRes.uri}/show-products$excludeQuery");

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['products'];
        return data.map((json) => Product.fromJson(json)).toList(); // { "products": [...], "hasMore": true/false }
      }
    }on DioException catch (e) {
          if (e.response != null && e.response?.data is Map<String, dynamic>) {
            final message = e.response?.data['message'] ?? 'Something went wrong';
            throw AppException(message);
          } else {
            print(e);

            throw AppException('Network error. Please try again.');
          }
    }
    return []; // Default if error occurs
  }

  Future<List<Product>> showCategoryProducts({String? category, List<String> exclude = const []}) async {
    try {
      String url = category == null ? StringsRes.uri : "${StringsRes.uri}/show-category-product/$category";
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


  Future<List<Product>> recommendedProducts({required String category})async{
    try {
      List<Product> products = [];
      Response res = await _dio.get("${StringsRes.uri}/recommended/$category", options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          }
      ));

      for (var i in res.data) {
        products.add(Product.fromJson(i));
      }

      return products;
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

  // Future<List<Product>> showCategoryProducts({required String category})async{
  //   try {
  //     List<Product> products = [];
  //     Response res = await _dio.get("${StringsRes.uri}/show-category-product/$category", options: Options(
  //         headers: {
  //           'Content-Type': 'application/json; charset=UTF-8',
  //         }
  //     ));
  //     print(res.data);
  //     for (var i in res.data) {
  //       products.add(Product.fromJson(i));
  //     }
  //
  //     return products;
  //   }
  //   on DioException catch (e) {
  //     if (e.response != null && e.response?.data is Map<String, dynamic>) {
  //       final message = e.response?.data['message'] ?? 'Something went wrong';
  //       throw AppException(message);
  //     } else {
  //       throw AppException('Network error. Please try again.');
  //     }
  //   }
  //
  // }




