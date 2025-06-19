part of 'auth_bloc.dart';

abstract class AuthState {}

final class AuthInitial extends AuthState {}

final class LoginLoading extends AuthState {}

final class SessionExpired extends AuthState {}

final class LoginSuccess extends AuthState {
  final String successMessage;
  final String token;
  LoginSuccess({
    required this.successMessage,
    required this.token,
  });
}

final class LoginFailure extends AuthState {
  final String errMessage;
  LoginFailure({required this.errMessage});
}
