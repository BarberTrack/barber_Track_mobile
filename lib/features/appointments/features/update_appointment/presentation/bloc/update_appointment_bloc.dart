import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/availability.dart';
import '../../domain/entities/update_appointment.dart';
import '../../domain/usecases/get_availability.dart';
import '../../domain/usecases/update_appointment.dart' as update_usecase;

part 'update_appointment_event.dart';
part 'update_appointment_state.dart';

class UpdateAppointmentBloc
    extends Bloc<UpdateAppointmentEvent, UpdateAppointmentState> {
  final GetAvailability getAvailability;
  final update_usecase.UpdateAppointment updateAppointmentUseCase;
  final Logger logger = Logger();

  UpdateAppointmentBloc({
    required this.getAvailability,
    required this.updateAppointmentUseCase,
  }) : super(UpdateAppointmentInitial()) {
    on<LoadAvailability>(_onLoadAvailability);
    on<SelectTimeSlot>(_onSelectTimeSlot);
    on<UpdateClientNotes>(_onUpdateClientNotes);
    on<SubmitUpdateAppointment>(_onSubmitUpdateAppointment);
    on<ResetState>(_onResetState);
  }

  Future<void> _onLoadAvailability(
    LoadAvailability event,
    Emitter<UpdateAppointmentState> emit,
  ) async {
    emit(UpdateAppointmentLoading());

    try {
      final availability = await getAvailability(
        businessId: event.businessId,
        barberId: event.barberId,
        serviceId: event.serviceId,
        date: event.date,
        days: event.days,
      );

      emit(
        UpdateAppointmentAvailabilityLoaded(
          availability: availability,
          businessId: event.businessId,
          barberId: event.barberId,
          serviceId: event.serviceId,
        ),
      );
    } catch (e) {
      logger.e('Error loading availability: $e');
      emit(UpdateAppointmentError(e.toString()));
    }
  }

  Future<void> _onSelectTimeSlot(
    SelectTimeSlot event,
    Emitter<UpdateAppointmentState> emit,
  ) async {
    final currentState = state;
    if (currentState is UpdateAppointmentAvailabilityLoaded) {
      emit(
        UpdateAppointmentTimeSlotSelected(
          availability: currentState.availability,
          businessId: currentState.businessId,
          barberId: currentState.barberId,
          serviceId: currentState.serviceId,
          selectedTimeSlot: event.timeSlot,
          selectedDate: event.selectedDate,
        ),
      );
    } else if (currentState is UpdateAppointmentWithNotes) {
      emit(
        UpdateAppointmentTimeSlotSelected(
          availability: currentState.availability,
          businessId: currentState.businessId,
          barberId: currentState.barberId,
          serviceId: currentState.serviceId,
          selectedTimeSlot: event.timeSlot,
          selectedDate: event.selectedDate,
        ),
      );
    }
  }

  Future<void> _onUpdateClientNotes(
    UpdateClientNotes event,
    Emitter<UpdateAppointmentState> emit,
  ) async {
    final currentState = state;
    if (currentState is UpdateAppointmentTimeSlotSelected) {
      emit(
        UpdateAppointmentWithNotes(
          availability: currentState.availability,
          businessId: currentState.businessId,
          barberId: currentState.barberId,
          serviceId: currentState.serviceId,
          selectedTimeSlot: currentState.selectedTimeSlot,
          selectedDate: currentState.selectedDate,
          clientNotes: event.notes,
        ),
      );
    } else if (currentState is UpdateAppointmentWithNotes) {
      emit(
        UpdateAppointmentWithNotes(
          availability: currentState.availability,
          businessId: currentState.businessId,
          barberId: currentState.barberId,
          serviceId: currentState.serviceId,
          selectedTimeSlot: currentState.selectedTimeSlot,
          selectedDate: currentState.selectedDate,
          clientNotes: event.notes,
        ),
      );
    }
  }

  Future<void> _onSubmitUpdateAppointment(
    SubmitUpdateAppointment event,
    Emitter<UpdateAppointmentState> emit,
  ) async {
    final currentState = state;

    // Verificar que tenemos todos los datos necesarios
    if (currentState is! UpdateAppointmentTimeSlotSelected &&
        currentState is! UpdateAppointmentWithNotes) {
      emit(
        const UpdateAppointmentError('Debe seleccionar una fecha y horario'),
      );
      return;
    }

    emit(UpdateAppointmentUpdating());

    try {
      String scheduledDatetime;
      String? clientNotes;

      if (currentState is UpdateAppointmentTimeSlotSelected) {
        scheduledDatetime = _formatDateTime(
          currentState.selectedDate,
          currentState.selectedTimeSlot.time,
        );
        clientNotes = null;
      } else if (currentState is UpdateAppointmentWithNotes) {
        scheduledDatetime = _formatDateTime(
          currentState.selectedDate,
          currentState.selectedTimeSlot.time,
        );
        clientNotes = currentState.clientNotes;
      } else {
        emit(
          const UpdateAppointmentError('Estado inválido para actualizar cita'),
        );
        return;
      }

      final request = UpdateAppointmentRequest(
        appointmentId: event.appointmentId,
        scheduledDatetime: scheduledDatetime,
        barberId: event.barberId,
        serviceId: event.serviceId,
        clientNotes: clientNotes,
      );

      final response = await updateAppointmentUseCase(request);
      emit(UpdateAppointmentSuccess(response));
    } catch (e) {
      logger.e('Error updating appointment: $e');

      int? statusCode;
      String errorMessage = 'Error al actualizar la cita';

      if (e is DioException && e.response != null) {
        statusCode = e.response!.statusCode;
        switch (statusCode) {
          case 400:
            errorMessage = 'Datos de entrada inválidos';
            break;
          case 403:
            errorMessage =
                'No se puede modificar la cita (muy cerca de la fecha programada)';
            break;
          case 404:
            errorMessage = 'Cita no encontrada o sin permisos';
            break;
          default:
            errorMessage = e.error?.toString() ?? errorMessage;
        }
      } else {
        errorMessage = e.toString();
      }

      emit(UpdateAppointmentError(errorMessage, statusCode: statusCode));
    }
  }

  String _formatDateTime(DateTime date, String time) {
    // Combinar fecha y hora en formato ISO 8601
    final timeParts = time.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    final dateTime = DateTime(date.year, date.month, date.day, hour, minute);
    return dateTime.toIso8601String();
  }

  Future<void> _onResetState(
    ResetState event,
    Emitter<UpdateAppointmentState> emit,
  ) async {
    emit(UpdateAppointmentInitial());
  }
}
