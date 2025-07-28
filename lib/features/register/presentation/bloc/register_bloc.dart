import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'register_event.dart';
import 'register_state.dart';
import '../../domain/usecases/register_user.dart';
import '../../data/models/register_request_model.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUser registerUserUseCase;

  RegisterBloc({required this.registerUserUseCase}) : super(RegisterInitial()) {
    on<RegisterUserEvent>(_onRegisterUser);
  }

  Future<void> _onRegisterUser(
    RegisterUserEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());

    try {
      final request = RegisterRequestModel(
        email: event.email,
        password: event.password,
        firstName: event.firstName,
        lastName: event.lastName,
        phone: event.phone,
      );

      final response = await registerUserUseCase.call(request);
      emit(RegisterSuccess(response));
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        emit(
          const RegisterFailure(
            'El email ya está registrado. Por favor, utiliza otro email.',
            statusCode: 409,
          ),
        );
      } else if (e.response?.statusCode == 400) {
        emit(
          const RegisterFailure(
            'Los datos ingresados no son válidos. Por favor, verifica la información.',
            statusCode: 400,
          ),
        );
      } else {
        emit(
          RegisterFailure(
            e.message ?? 'Error de conexión. Por favor, intenta nuevamente.',
            statusCode: e.response?.statusCode,
          ),
        );
      }
    } catch (e) {
      emit(RegisterFailure('Error inesperado: ${e.toString()}'));
    }
  }
}
