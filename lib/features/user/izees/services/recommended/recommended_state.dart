part of 'recommended_cubit.dart';

sealed class RecommendedState extends Equatable {
  const RecommendedState();
}

final class RecommendedInitial extends RecommendedState {
  @override
  List<Object?> get props => [];
}

final class RecommendedLoading extends RecommendedState {
  @override
  List<Object?> get props => [];
}

final class RecommendedSuccess extends RecommendedState {
  List<Product> product;

  RecommendedSuccess(this.product);

  @override
  List<Object?> get props => [];
}

final class RecommendedFailed extends RecommendedState {
  String err;

  RecommendedFailed(this.err);

  @override
  List<Object?> get props => [];
}
