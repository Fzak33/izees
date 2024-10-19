part of 'admin_product_service_cubit.dart';

@immutable
sealed class AdminProductServiceState {}

final class AdminProductServiceInitial extends AdminProductServiceState {}
final class AdminProductServiceSuccess extends AdminProductServiceState {
  List<Product> product;
  AdminProductServiceSuccess(this.product);
}
final class AdminProductServiceFailed extends AdminProductServiceState {
  String err;

  AdminProductServiceFailed(this.err);
}
final class AdminProductServiceLoding extends AdminProductServiceState {}
final class AdminProductServiceEmpty extends AdminProductServiceState {
  String empty;

  AdminProductServiceEmpty(this.empty);
}


