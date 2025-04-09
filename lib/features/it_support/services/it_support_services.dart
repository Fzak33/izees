import 'package:dio/dio.dart';
import 'package:flutter/material.dart'
;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/auth/auth_cubit/auth_cubit.dart';
import 'package:izees/models/temp_admin.dart';
import 'package:izees/resources/strings_res.dart';

import '../../../common/app_exception.dart';
class ItSupportServices{

  final Dio _dio = Dio();

  Future<List<TempAdmin>> getTempAdmin({ required BuildContext context})async{
    try{
      var auth = context.read<AuthCubit>();
List<TempAdmin> tempAdmin = [];
      Response response = await _dio.get('${StringsRes.uri}/get-temp-admin',
          options: Options(
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': auth.adminModel.token,
              }
          )
      );
      for(var i in response.data){
        tempAdmin.add(TempAdmin.fromJson(i));
      }

      return tempAdmin;
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

  Future<Response> addANewSeller({required String id , required BuildContext context})async{
    try{
      var auth = context.read<AuthCubit>();
      var data = {
        '_id':id
      };
   Response res =   await _dio.post('${StringsRes.uri}/change-into-admin' ,
      data: data,
      options: Options(
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': auth.adminModel.token,
        }
      )
      );
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