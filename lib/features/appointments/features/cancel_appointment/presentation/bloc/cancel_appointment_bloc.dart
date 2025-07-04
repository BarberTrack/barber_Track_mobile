import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/cancel_appointment_request.dart';
import '../../domain/usecases/cancel_appointment.dart';
import 'cancel_appointment_event.dart';
import 'cancel_appointment_state.dart';

class CancelAppointmentBloc
    extends Bloc<CancelAppointmentEvent, CancelAppointmentState> {
  final CancelAppointment cancelAppointmentUseCase;

  CancelAppointmentBloc({required this.cancelAppointmentUseCase})
    : super(CancelAppointmentInitial()) {
    on<CancelAppointmentRequested>(_onCancelAppointmentRequested);
  }

  Future<void> _onCancelAppointmentRequested(
    CancelAppointmentRequested event,
    Emitter<CancelAppointmentState> emit,
  ) async {
    emit(CancelAppointmentLoading());

    try {
      final request = CancelAppointmentRequest(
        appointmentId: event.appointmentId,
        reason: event.reason,
        cancelledBy: 'client',
      );

      final response = await cancelAppointmentUseCase(request);

      emit(
        CancelAppointmentSuccess(
          updatedAppointment: response.data,
          message: response.message,
        ),
      );
    } catch (e) {
      emit(CancelAppointmentError(e.toString()));
    }
  }
}
