

part of 'search_cubit.dart';


sealed class SearchState extends Equatable {
  const SearchState();
}

final class SearchInitial extends SearchState {
  @override
  List<Object?> get props => [];
}


class SearchLoading extends SearchState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

}

class SearchSuccess extends SearchState {
  final List<Product> products;

  const SearchSuccess(this.products);

  @override
  List<Object?> get props => [products];
}

class SearchFailure extends SearchState {
  final String error;

  const SearchFailure(this.error);

  @override
  List<Object?> get props => [error];
}