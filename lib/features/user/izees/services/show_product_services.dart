

import 'package:dio/dio.dart';
import 'package:izees/models/product_model.dart';
import 'package:izees/resources/strings_res.dart';

class ShowProductServices{
  final Dio _dio = Dio();


  Future<List<Product>> showProducts()async{
    try {
      List<Product> products = [];
      Response res = await _dio.get("${StringsRes.uri}/show-products", options: Options(
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        }
      ));
      print(res.data);
      for (var i in res.data) {
        products.add(Product.fromJson(i));
      }

      return products;
    }
    catch(e){
      print(e.toString());
      throw e.toString();

    }

  }

  Future<List<Product>> showCategoryProducts({required String category})async{
    try {
      List<Product> products = [];
      Response res = await _dio.get("${StringsRes.uri}/show-category-product/$category", options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          }
      ));
      print(res.data);
      for (var i in res.data) {
        products.add(Product.fromJson(i));
      }

      return products;
    }
    catch(e){
      print(e.toString());
      throw e.toString();

    }

  }


  Future<List<Product>> recommendedProducts({required String category})async{
    try {
      List<Product> products = [];
      Response res = await _dio.get("${StringsRes.uri}/recommended/$category", options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          }
      ));
      print(res.data);
      for (var i in res.data) {
        products.add(Product.fromJson(i));
      }

      return products;
    }
    catch(e){
      print(e.toString());
      throw e.toString();

    }

  }


}