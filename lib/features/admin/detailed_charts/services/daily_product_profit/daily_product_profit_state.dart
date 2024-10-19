part of 'daily_product_profit_cubit.dart';

sealed class DailyProductProfitState extends Equatable {
  const DailyProductProfitState();
}

final class DailyProductProfitInitial extends DailyProductProfitState {
  @override
  List<Object?> get props => [];
}

final class DailyProductProfitLoading extends DailyProductProfitInitial {
  @override
  List<Object?> get props => [];
}

final class DailyProductProfitSuccess extends DailyProductProfitInitial {
  List<ProductProfit> productProfit;

  DailyProductProfitSuccess(this.productProfit);

  @override
  List<Object?> get props => [];
}

final class DailyProductProfitFailed extends DailyProductProfitInitial {
  String err;

  DailyProductProfitFailed(this.err);

  @override
  List<Object?> get props => [];
}
