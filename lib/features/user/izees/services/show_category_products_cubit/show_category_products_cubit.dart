import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../common/app_exception.dart';
import '../../../../../models/product_model.dart';
import '../show_product_services.dart';

part 'show_category_products_state.dart';

class ShowCategoryProductsCubit extends Cubit<ShowCategoryProductsState> {

  ShowCategoryProductsCubit(this._showProductServices) : super(ShowCategoryProductsInitial());


  final ShowProductServices _showProductServices;
  bool isLoading = false;

  List<Product> products =[];

  Future<void> showCategoryProducts({required String category})async{
    if(isLoading)return;
    emit(ShowCategoryProductsLoading());
    try{
      isLoading =true;
      var res =await  _showProductServices.showCategoryProducts(category: category);
      products.addAll(res);
      emit(ShowCategoryProductsSuccess(product: List.from(products)));
    }
    catch (e) {
      if (e is AppException) {
emit(ShowCategoryProductsFailed(e.toString()));
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(e.message)),
        // );
      } else {
        emit(ShowCategoryProductsFailed(e.toString()));
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('An unexpected error occurred')),
        // );
      }
    }finally{
      isLoading =false;
    }
  }

}
