import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/admin/models/sales.dart';
import 'package:flutter/material.dart';

import '../../../../common/app_exception.dart';
import '../../../../resources/strings_res.dart';
import '../../../auth/auth_cubit/auth_cubit.dart';

class AdminOrderServices {
  final Dio _dio = Dio();
  Future< List<ProductProfit> > getAdminProducts({required BuildContext context})async{

    try {
      var auth = BlocProvider
          .of<AuthCubit>(context)
      ;

      Response res = await _dio.get('${StringsRes.uri}/get-admin-order',
          options: Options(
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': auth.adminModel.token
              }

          )
      );
      List<ProductProfit> profit = [];
      if (res.statusCode == 200) {
        for (var i in res.data) {
          profit.add(ProductProfit.fromJson(i));
        }
      }

      return profit;
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