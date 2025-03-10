import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/resources/strings_res.dart';

import '../../features/auth/auth_cubit/auth_cubit.dart';
import '../../features/user/cart/widgets/price_details_widget.dart';
import '../app_exception.dart';


class CommonServices {
  Dio _dio = Dio();

  Future<void> addPhoneNumber({required String phoneNumber, required BuildContext context})async {
    try {
      var auth = BlocProvider
          .of<AuthCubit>(context)
      ;
      String token = auth.authModel.token?.toString() ?? auth.adminModel.token?.toString() ?? '';
      print("your phone number token is $token");
      var data = {
        'phoneNumber': phoneNumber
      };
      await _dio.post("${StringsRes.uri}/add-phone-number",
          data: data,
          options: Options(
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': token

              }

          )
      );


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