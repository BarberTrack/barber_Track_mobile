import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../domain/usecases/authenticate_user.dart';
import '../../../../core/services/notification_service.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticateUser authenticateUser;

  LoginBloc(this.authenticateUser) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    try {
      final user = await authenticateUser(
        email: event.email,
        password: event.password,
      );

      
      await NotificationService.registerTokenInAPI();

      emit(LoginSuccess(user));
    } on DioException catch (e) {
      emit(LoginFailure(e.message ?? 'Error de conexión'));
    } catch (e) {
      emit(LoginFailure('Error inesperado: $e'));
    }
  }
}
