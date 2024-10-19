part of 'day_profit_cubit.dart';

sealed class DayProfitState extends Equatable {
  const DayProfitState();
}

final class DayProfitInitial extends DayProfitState {
  @override
  List<Object?> get props => [];
}

final class DayProfitLoading extends DayProfitState {
  @override
  List<Object?> get props => [];
}

final class DayProfitSuccess extends DayProfitState {
  List<Sales> sales;

  DayProfitSuccess(this.sales);

  @override
  List<Object?> get props => [];
}

final class DayProfitFailed extends DayProfitState {
  String err;

  DayProfitFailed(this.err);

  @override
  List<Object?> get props => [];
}

