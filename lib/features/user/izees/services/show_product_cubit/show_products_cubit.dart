import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../models/product_model.dart';
import '../show_product_services.dart';
part 'show_products_state.dart';

class ShowProductsCubit extends Cubit<ShowProductsState> {

  ShowProductsCubit(this._showProductServices) : super(ShowProductsInitial());

  ShowProductServices _showProductServices;
  bool isLoading = false;

  List<Product> products =[];

  Future<void> showProducts()async{
    if(isLoading)return;
    emit(ShowProductsLoading());
    try{
      isLoading =true;
    var res =await  _showProductServices.showProducts();
    products.addAll(res);
    emit(ShowProductsSuccess(product: List.from(products)));
    }
    catch(e){
      emit(ShowProductsFailed(e.toString()));
    }finally{
      isLoading =false;
    }
  }


}
