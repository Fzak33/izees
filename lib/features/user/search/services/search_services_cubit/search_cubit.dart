import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:izees/features/user/search/services/search_services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../models/product_model.dart';

part 'search_state.dart';


 const _debounceDuration = Duration(milliseconds: 300);

class SearchCubit extends Cubit<SearchState> {

  SearchServices searchServices;

  final _searchController = StreamController<String>();
  StreamSubscription<String>? _searchSubscription;



  SearchCubit({required this.searchServices}) : super(SearchInitial()){
    _searchSubscription = _searchController.stream
        .debounceTime(_debounceDuration ) // Apply debounce
        .distinct() // Prevent duplicate searches
        .listen((query) {
      if (query.isNotEmpty) {
        searchProducts(name: query);
      } else {
        emit(SearchInitial());
      }
    });
  }



  void onSearchChanged(String query) {
    _searchController.add(query);
  }

  Future<void> searchProducts({required String name}) async {
    // if (name.isEmpty) {
    //   emit(const SearchFailure('Search query cannot be empty.'));
    //   return;
    // }
    //
    emit(SearchLoading());

    try {
      final products = await searchServices.searchProducts(name: name);
      emit(SearchSuccess(products));
    } catch (e) {
      emit(SearchFailure(e.toString()));
    }
  }


  @override
  Future<void> close() {
    _searchSubscription?.cancel();
    _searchController.close();
    return super.close();
  }

}
