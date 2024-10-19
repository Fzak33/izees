part of 'driver_order_cubit.dart';

@immutable
sealed class DriverOrderState {}

final class DriverOrderInitial extends DriverOrderState {}
final class DriverOrderLoading extends DriverOrderState {}
final class DriverOrderEmpty extends DriverOrderState {
  String empty;

  DriverOrderEmpty(this.empty);


}
final class DriverOrderSuccess extends DriverOrderState {
  List<Order> order;

  DriverOrderSuccess(this.order);
}
final class DriverOrderFailed extends DriverOrderState {
  String err;

  DriverOrderFailed(this.err);
}

final class OrderChangeStatus extends DriverOrderState {
  num status;

  OrderChangeStatus(this.status);
}