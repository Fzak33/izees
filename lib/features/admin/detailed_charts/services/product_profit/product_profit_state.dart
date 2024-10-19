part of 'product_profit_cubit.dart';

sealed class ProductProfitState extends Equatable {
  const ProductProfitState();
}

final class ProductProfitInitial extends ProductProfitState {
  @override
  List<Object?> get props => [];
}

final class ProductProfitLoading extends ProductProfitInitial {
  @override
  List<Object?> get props => [];
}

final class ProductProfitSuccess extends ProductProfitInitial {
  List<ProductProfit> productProfit;

  ProductProfitSuccess(this.productProfit);

  @override
  List<Object?> get props => [];
}

final class ProductProfitFailed extends ProductProfitInitial {
  String err;

  ProductProfitFailed(this.err);

  @override
  List<Object?> get props => [];
}
