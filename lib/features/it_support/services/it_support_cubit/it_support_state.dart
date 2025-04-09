part of 'it_support_cubit.dart';

@immutable
sealed class ItSupportState {}

final class ItSupportInitial extends ItSupportState {}

final class ItSupportLoading extends ItSupportState {}

final class ItSupportSuccess extends ItSupportState {
  List<TempAdmin> tempAdmin;

  ItSupportSuccess(this.tempAdmin);
}

final class ItSupportFailed extends ItSupportState {
  String err;

  ItSupportFailed(this.err);
}
