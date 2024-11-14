part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}
final class AuthUser extends AuthState {
  final AuthModel user;
  AuthUser(this.user);
}
final class AuthAdmin extends AuthState {
  final AdminModel admin;
  AuthAdmin(this.admin);
}
