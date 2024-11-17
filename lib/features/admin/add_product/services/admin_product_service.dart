import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/models/product_model.dart';
import 'package:izees/resources/strings_res.dart';
import 'package:flutter/material.dart';

import '../../../../common/app_exception.dart';
import '../../../auth/auth_cubit/auth_cubit.dart';

class AdminProductService{
Dio dio = Dio();

Future<Product> addProduct({required Product product,required List<File> images, required BuildContext context})async {
try {
  var auth = BlocProvider
      .of<AuthCubit>(context)
  ;
  FormData formData = FormData.fromMap({

  'name': product.name,
  'description': product.description,
  'quantity': product.quantity,
  'price': product.price,
  'category': product.category,
   // List of MultipartFiles
'images':
await Future.wait(images.map((image) async {
  return await MultipartFile.fromFile(
    image.path,
    filename: image.path.split('/').last,
  );
})),

    });

 Response res= await dio.post('${StringsRes.uri}/add-product',
      data: formData,
      options: Options(
          headers: {
           'Content-Type':'multipart/form-data',
            //'Content-Type': 'application/x-www-form-urlencoded',
            'x-auth-token': auth.adminModel.token
          }

      ));
// AdminModel adminModel =  auth.adminModel.copyWith(product: [product]);
// auth.setAdmin(adminModel);
  Product prod = Product.fromJson(res.data);

return prod;
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



Future< List<Product> > getAdminProducts({required BuildContext context})async{

  try {
    var auth = BlocProvider
        .of<AuthCubit>(context)
    ;

    Response res = await dio.get('${StringsRes.uri}/get-product',
        options: Options(
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': auth.adminModel.token
            }

        )
    );
    List<Product> product = [];
    if (res.statusCode == 200) {
      for (var i in res.data) {
        product.add(Product.fromJson(i));
      }
    }
   // print('ypur dat is ------------------------------------ ${res.data}');
    //print('your list is --------------------- $product');
    return product;
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


Future<Response> updateProduct({
  required String productId,
  required String description,
  required String name,
  required double price,
  required int quantity,
  required BuildContext context
})async {
  try {
    var auth = BlocProvider
        .of<AuthCubit>(context)
    ;
    var data = {
      'description':description,
      'name':name,
      'price':price,
      'quantity':quantity
    };
  Response res =  await dio.put('${StringsRes.uri}/update-product/$productId',
        data: data,
        options: Options(
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              //'Content-Type': 'application/x-www-form-urlencoded',
              'x-auth-token': auth.adminModel.token
            }

        ));
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

Future<Response> deleteProduct({
  required String productId,
  required BuildContext context
})async {
  try {
    var auth = BlocProvider
        .of<AuthCubit>(context)
    ;

  Response res =  await dio.delete('${StringsRes.uri}/delete-product/$productId',

        options: Options(
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              //'Content-Type': 'application/x-www-form-urlencoded',
              'x-auth-token': auth.adminModel.token
            }

        ));
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







}