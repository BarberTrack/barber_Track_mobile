import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import '../../domain/entities/availability.dart';
import '../../domain/entities/repeat_appointment.dart';
import '../../domain/usecases/get_business_availability.dart';
import '../../domain/usecases/repeat_appointment.dart' as usecase;

part 'repeat_appointment_event.dart';
part 'repeat_appointment_state.dart';

class RepeatAppointmentBloc
    extends Bloc<RepeatAppointmentEvent, RepeatAppointmentState> {
  final GetBusinessAvailability getBusinessAvailability;
  final usecase.RepeatAppointment repeatAppointmentUseCase;
  final Logger logger = Logger();

  RepeatAppointmentBloc({
    required this.getBusinessAvailability,
    required this.repeatAppointmentUseCase,
  }) : super(RepeatAppointmentInitial()) {
    on<LoadBusinessAvailability>(_onLoadBusinessAvailability);
    on<SelectTimeSlot>(_onSelectTimeSlot);
    on<ConfirmRepeatAppointment>(_onConfirmRepeatAppointment);
    on<ResetState>(_onResetState);
  }

  Future<void> _onLoadBusinessAvailability(
    LoadBusinessAvailability event,
    Emitter<RepeatAppointmentState> emit,
  ) async {
    emit(RepeatAppointmentLoading());

    try {
      final dateString = event.selectedDate.toIso8601String().split('T')[0];

      final availability = await getBusinessAvailability(
        businessId: event.businessId,
        barberId: event.barberId,
        serviceId: event.serviceId,
        date: dateString,
        days: 3,
      );

     


      final filteredAvailability = _filterPastTimeSlots(
        availability,
        event.selectedDate,
      );



      emit(
        RepeatAppointmentAvailabilityLoaded(
          availability: filteredAvailability,
          businessId: event.businessId,
          serviceId: event.serviceId,
          selectedDate: event.selectedDate,
        ),
      );
    } catch (e) {
      emit(RepeatAppointmentError(e.toString()));
    }
  }

  Future<void> _onSelectTimeSlot(
    SelectTimeSlot event,
    Emitter<RepeatAppointmentState> emit,
  ) async {
    final currentState = state;
    if (currentState is RepeatAppointmentAvailabilityLoaded) {
      emit(
        RepeatAppointmentTimeSlotSelected(
          availability: currentState.availability,
          businessId: currentState.businessId,
          serviceId: currentState.serviceId,
          selectedDate: event.selectedDate,
          selectedTimeSlot: event.timeSlot,
        ),
      );
    } else if (currentState is RepeatAppointmentTimeSlotSelected) {
      emit(
        RepeatAppointmentTimeSlotSelected(
          availability: currentState.availability,
          businessId: currentState.businessId,
          serviceId: currentState.serviceId,
          selectedDate: event.selectedDate,
          selectedTimeSlot: event.timeSlot,
        ),
      );
    }
  }

  Future<void> _onConfirmRepeatAppointment(
    ConfirmRepeatAppointment event,
    Emitter<RepeatAppointmentState> emit,
  ) async {
    emit(RepeatAppointmentCreating());

    try {
      final scheduledDateTime = _formatDateTime(
        event.selectedDate,
        event.selectedTimeSlot.time,
      );

      final request = RepeatAppointmentRequest(
        appointmentId: event.appointmentId,
        scheduledDatetime: scheduledDateTime,
      );

      final response = await repeatAppointmentUseCase(request);
      emit(RepeatAppointmentSuccess(response));
    } catch (e) {
      logger.e('Error repeating appointment: $e');
      emit(RepeatAppointmentError(e.toString()));
    }
  }

  void _onResetState(ResetState event, Emitter<RepeatAppointmentState> emit) {
    emit(RepeatAppointmentInitial());
  }

  AvailabilityResponse _filterPastTimeSlots(
    AvailabilityResponse availability,
    DateTime selectedDate,
  ) {
    final now = DateTime.now();
    final isToday =
        selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;

    if (!isToday) {
      return availability;
    }

    final marginTime = now.add(const Duration(minutes: 30));
    final marginTimeString =
        '${marginTime.hour.toString().padLeft(2, '0')}:${marginTime.minute.toString().padLeft(2, '0')}';

    final filteredBarberAvailability = availability.availability.map((
      barberAvailability,
    ) {
      final filteredSchedule = barberAvailability.schedule.map((daySchedule) {
        if (daySchedule.date == selectedDate.toIso8601String().split('T')[0]) {
          final filteredSlots = daySchedule.availableSlots.where((slot) {
            return slot.time.compareTo(marginTimeString) >= 0;
          }).toList();

          return DaySchedule(
            date: daySchedule.date,
            availableSlots: filteredSlots,
          );
        }
        return daySchedule;
      }).toList();

      return BarberAvailability(
        barberId: barberAvailability.barberId,
        barberName: barberAvailability.barberName,
        schedule: filteredSchedule,
      );
    }).toList();

    return AvailabilityResponse(
      businessId: availability.businessId,
      availability: filteredBarberAvailability,
    );
  }

  String _formatDateTime(DateTime date, String time) {
    final timeParts = time.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    final dateTime = DateTime(date.year, date.month, date.day, hour, minute);
    return dateTime.toIso8601String();
  }
}
