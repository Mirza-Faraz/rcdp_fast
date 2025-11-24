part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SaveUsernameEvent extends AuthEvent {
  final String username;

  const SaveUsernameEvent({required this.username});

  @override
  List<Object> get props => [username];
}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;

  const LoginEvent({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];
}

class GetSavedUsernameEvent extends AuthEvent {}
