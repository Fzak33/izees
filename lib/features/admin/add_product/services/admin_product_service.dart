import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/models/admin_model.dart';
import 'package:izees/models/product_model.dart';
import 'package:izees/resources/strings_res.dart';
import 'package:flutter/material.dart';

import '../../../auth/auth_cubit/auth_cubit.dart';

class AdminProductService{
Dio dio = Dio();

Future<void> addProduct({required Product product,required List<File> images, required BuildContext context})async {
try {
  var auth = BlocProvider
      .of<AuthCubit>(context)
  ;


// images.map((image) {
//   File(image.path);
// }).toList();
//   List<MultipartFile> imageFiles = images.map((image) {
//     return MultipartFile.fromFileSync(
//       image.path,
//       filename: image.path.split('/').last,
//     );
//   }).toList();


 //  List<MultipartFile> imageFiles =[];
 //
 //  images.map((image) async =>  imageFiles.add(
 // await  MultipartFile.fromFile(
 //  image.path,
 //    filename: image.path.split('/').last,
 //  ),)).toList();


  // for (var image in images) {
  //   imageFiles.add(
  //     await MultipartFile.fromFile(
  //       image.path,
  //       filename: image.path.split('/').last,
  //     ),
  //   );
  // }


print(" ------------------------------------------- ${images[0].path}");
  //Create FormData with fields and the list of images






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
  //  images.map((image) async =>
  // await  MultipartFile.fromFile(
  // image.path,
  // filename: image.path.split('/').last,
  // ),).toList()

  // for (File file in images) {
  //   String fileName = file.path.split('/').last;

    // Add each file to FormData
  //   formData.files.addAll([
  //     MapEntry(
  //       'images', // This key should match the expected parameter name on your backend
  //       await MultipartFile.fromFile(file.path, filename: fileName),
  //     ),
  //   ]);
  // }

  await dio.post('${StringsRes.uri}/add-product',
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
}
catch(e){
  print(e.toString());
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
  catch(e){
    print(e.toString());
    throw e.toString();
  }
}

}