part of 'profit_cubit.dart';

sealed class ProfitState extends Equatable {
  const ProfitState();
}

final class ProfitInitial extends ProfitState {
  @override
  List<Object?> get props => [];
}

final class ProfitLoading extends ProfitState {
  @override
  List<Object?> get props => [];
}

final class ProfitSuccess extends ProfitState {
  List<Sales> sales;

  ProfitSuccess(this.sales);

  @override
  List<Object?> get props => [];
}

final class ProfitFailed extends ProfitState {
  String err;

  ProfitFailed(this.err);

  @override
  List<Object?> get props => [];
}

