part of 'admin_order_cubit.dart';

@immutable
sealed class AdminOrderState {}

final class AdminOrderInitial extends AdminOrderState {}
final class AdminOrderLoading  extends AdminOrderState {}

final class AdminOrderSuccess extends AdminOrderState {
  List<Profit> profit;

  AdminOrderSuccess(this.profit);
}
final class AdminOrderFailed extends AdminOrderState {
  String err;

  AdminOrderFailed(this.err);
}
