import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import '../../domain/entities/service.dart';
import '../../domain/entities/availability.dart';
import '../../domain/entities/time_slot.dart';
import '../../domain/usecases/get_business_services.dart';
import '../../domain/usecases/get_availability.dart';

part 'create_appointment_event.dart';
part 'create_appointment_state.dart';

class CreateAppointmentBloc
    extends Bloc<CreateAppointmentEvent, CreateAppointmentState> {
  final GetBusinessServices getBusinessServices;
  final GetAvailability getAvailability;
  final Logger logger = Logger();

  CreateAppointmentBloc({
    required this.getBusinessServices,
    required this.getAvailability,
  }) : super(CreateAppointmentInitial()) {
    on<LoadBusinessServices>(_onLoadBusinessServices);
    on<SelectService>(_onSelectService);
    on<SelectDate>(_onSelectDate);
    on<LoadAvailability>(_onLoadAvailability);
    on<SelectTimeSlot>(_onSelectTimeSlot);
    on<ResetSelection>(_onResetSelection);
  }

  Future<void> _onLoadBusinessServices(
    LoadBusinessServices event,
    Emitter<CreateAppointmentState> emit,
  ) async {
    emit(CreateAppointmentLoading());

    try {
      final services = await getBusinessServices(event.businessId);
      emit(
        CreateAppointmentServicesLoaded(
          services: services,
          businessId: event.businessId,
        ),
      );
    } catch (e) {
      logger.e('Error loading business services: $e');
      emit(CreateAppointmentError(e.toString()));
    }
  }

  Future<void> _onSelectService(
    SelectService event,
    Emitter<CreateAppointmentState> emit,
  ) async {
    final currentState = state;
    if (currentState is CreateAppointmentServicesLoaded) {
      emit(
        CreateAppointmentServiceSelected(
          services: currentState.services,
          businessId: currentState.businessId,
          selectedService: event.service,
        ),
      );
    }
  }

  Future<void> _onSelectDate(
    SelectDate event,
    Emitter<CreateAppointmentState> emit,
  ) async {
    final currentState = state;
    if (currentState is CreateAppointmentServiceSelected) {
      emit(
        CreateAppointmentDateSelected(
          services: currentState.services,
          businessId: currentState.businessId,
          selectedService: currentState.selectedService,
          selectedDate: event.date,
        ),
      );
    }
  }

  Future<void> _onLoadAvailability(
    LoadAvailability event,
    Emitter<CreateAppointmentState> emit,
  ) async {
    final currentState = state;
    if (currentState is CreateAppointmentDateSelected) {
      emit(CreateAppointmentLoading());

      try {
        final availability = await getAvailability(
          businessId: event.businessId,
          barberId: event.barberId,
          date: event.date,
          days: event.days,
        );

        emit(
          CreateAppointmentAvailabilityLoaded(
            services: currentState.services,
            businessId: currentState.businessId,
            selectedService: currentState.selectedService,
            selectedDate: currentState.selectedDate,
            availability: availability,
          ),
        );
      } catch (e) {
        logger.e('Error loading availability: $e');
        emit(CreateAppointmentError(e.toString()));
      }
    }
  }

  Future<void> _onSelectTimeSlot(
    SelectTimeSlot event,
    Emitter<CreateAppointmentState> emit,
  ) async {
    final currentState = state;
    if (currentState is CreateAppointmentAvailabilityLoaded) {
      emit(
        CreateAppointmentTimeSlotSelected(
          services: currentState.services,
          businessId: currentState.businessId,
          selectedService: currentState.selectedService,
          selectedDate: currentState.selectedDate,
          availability: currentState.availability,
          selectedTimeSlot: event.timeSlot,
        ),
      );
    }
  }

  Future<void> _onResetSelection(
    ResetSelection event,
    Emitter<CreateAppointmentState> emit,
  ) async {
    emit(CreateAppointmentInitial());
  }
}
