part of 'month_profit_cubit.dart';

sealed class MonthProfitState extends Equatable {
  const MonthProfitState();
}

final class MonthProfitInitial extends MonthProfitState {
  @override
  List<Object?> get props => [];
}

final class MonthProfitLoading extends MonthProfitState {
  @override
  List<Object?> get props => [];
}

final class MonthProfitSuccess extends MonthProfitState {
  List<Sales> sales;

  MonthProfitSuccess(this.sales);

  @override
  List<Object?> get props => [];
}

final class MonthProfitFailed extends MonthProfitState {
  String err;

  MonthProfitFailed(this.err);

  @override
  List<Object?> get props => [];
}

