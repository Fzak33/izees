import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../common/app_exception.dart';
import '../../../../../models/product_model.dart';
import '../show_product_services.dart';

part 'recommended_state.dart';

class RecommendedCubit extends Cubit<RecommendedState> {
  RecommendedCubit(this._showProductServices) : super(RecommendedInitial());
  final ShowProductServices _showProductServices ;


  Future<void> recommended({required String category})async{
    emit(RecommendedLoading());
    try{
      var res =await  _showProductServices.recommendedProducts(category: category);
      emit(RecommendedSuccess(res));
    }
    catch (e) {
      if (e is AppException) {
        emit(RecommendedFailed(e.toString()));
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(e.message)),
        // );
      } else {
        emit(RecommendedFailed(e.toString()));
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('An unexpected error occurred')),
        // );
      }
    }
  }

}
