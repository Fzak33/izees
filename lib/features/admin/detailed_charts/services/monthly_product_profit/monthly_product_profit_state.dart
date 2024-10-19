part of 'monthly_product_profit_cubit.dart';

sealed class MonthlyProductProfitState extends Equatable {
  const MonthlyProductProfitState();
}

final class MonthlyProductProfitInitial extends MonthlyProductProfitState {
  @override
  List<Object?> get props => [];
}

final class MonthlyProductProfitLoading extends MonthlyProductProfitInitial {
  @override
  List<Object?> get props => [];
}

final class MonthlyProductProfitSuccess extends MonthlyProductProfitInitial {
  List<ProductProfit> productProfit;

  MonthlyProductProfitSuccess(this.productProfit);

  @override
  List<Object?> get props => [];
}

final class MonthlyProductProfitFailed extends MonthlyProductProfitInitial {
  String err;

  MonthlyProductProfitFailed(this.err);

  @override
  List<Object?> get props => [];
}
