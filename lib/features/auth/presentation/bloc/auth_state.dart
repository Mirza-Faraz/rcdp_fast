part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class UsernameSaved extends AuthState {
  final String username;

  const UsernameSaved({required this.username});

  @override
  List<Object> get props => [username];
}

class AuthAuthenticated extends AuthState {
  final String username;

  const AuthAuthenticated({required this.username});

  @override
  List<Object> get props => [username];
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}
