import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/get_saved_username_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/save_username_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SaveUsernameUseCase saveUsernameUseCase;
  final GetSavedUsernameUseCase getSavedUsernameUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.saveUsernameUseCase,
    required this.getSavedUsernameUseCase,
  }) : super(AuthInitial()) {
    on<SaveUsernameEvent>(_onSaveUsername);
    on<LoginEvent>(_onLogin);
    on<GetSavedUsernameEvent>(_onGetSavedUsername);
  }

  Future<void> _onSaveUsername(
    SaveUsernameEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await saveUsernameUseCase(event.username);
    
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(UsernameSaved(username: event.username)),
    );
  }

  Future<void> _onLogin(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await loginUseCase(event.username, event.password);
    
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (success) {
        if (success) {
          emit(AuthAuthenticated(username: event.username));
        } else {
          emit(const AuthError(message: 'Login failed'));
        }
      },
    );
  }

  Future<void> _onGetSavedUsername(
    GetSavedUsernameEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await getSavedUsernameUseCase();
    
    result.fold(
      (failure) => emit(AuthInitial()),
      (username) {
        if (username != null && username.isNotEmpty) {
          emit(UsernameSaved(username: username));
        } else {
          emit(AuthInitial());
        }
      },
    );
  }
}
