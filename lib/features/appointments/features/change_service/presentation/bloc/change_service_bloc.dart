import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import '../../../create_appointment/domain/entities/service.dart';
import '../../../create_appointment/domain/entities/availability.dart';
import '../../../create_appointment/domain/entities/time_slot.dart';
import '../../../appoinments_home/domain/entities/appointment.dart';
import '../../domain/entities/change_service_request.dart';
import '../../domain/entities/change_service_response.dart';
import '../../domain/usecases/get_business_services.dart';
import '../../domain/usecases/get_availability.dart';
import '../../domain/usecases/change_service.dart';

part 'change_service_event.dart';
part 'change_service_state.dart';

class ChangeServiceBloc extends Bloc<ChangeServiceEvent, ChangeServiceState> {
  final GetBusinessServices getBusinessServices;
  final GetAvailability getAvailability;
  final ChangeService changeServiceUseCase;
  final Logger logger = Logger();

  ChangeServiceBloc({
    required this.getBusinessServices,
    required this.getAvailability,
    required this.changeServiceUseCase,
  }) : super(ChangeServiceInitial()) {
    on<LoadBusinessServices>(_onLoadBusinessServices);
    on<SelectService>(_onSelectService);
    on<SelectKeepDateTime>(_onSelectKeepDateTime);
    on<SelectChangeDateTime>(_onSelectChangeDateTime);
    on<SelectDate>(_onSelectDate);
    on<LoadAvailability>(_onLoadAvailability);
    on<SelectTimeSlot>(_onSelectTimeSlot);
    on<UpdateClientNotes>(_onUpdateClientNotes);
    on<SubmitChangeService>(_onSubmitChangeService);
    on<ResetSelection>(_onResetSelection);
  }

  Future<void> _onLoadBusinessServices(
    LoadBusinessServices event,
    Emitter<ChangeServiceState> emit,
  ) async {
    emit(ChangeServiceLoading());

    try {
      final services = await getBusinessServices(event.businessId);
      emit(
        ChangeServiceServicesLoaded(
          services: services,
          businessId: event.businessId,
          originalAppointment: event.originalAppointment,
        ),
      );
    } catch (e) {
      logger.e('Error loading business services: $e');
      emit(ChangeServiceError(e.toString()));
    }
  }

  
  void loadBusinessServicesWithAppointment(
    String businessId,
    Appointment appointment,
  ) {
    add(LoadBusinessServices(businessId, appointment));
  }

  Future<void> _onSelectService(
    SelectService event,
    Emitter<ChangeServiceState> emit,
  ) async {
    final currentState = state;
    if (currentState is ChangeServiceServicesLoaded) {
      emit(
        ChangeServiceServiceSelected(
          services: currentState.services,
          businessId: currentState.businessId,
          originalAppointment: currentState.originalAppointment,
          selectedService: event.service,
        ),
      );
    }
  }

  Future<void> _onSelectKeepDateTime(
    SelectKeepDateTime event,
    Emitter<ChangeServiceState> emit,
  ) async {
    final currentState = state;
    if (currentState is ChangeServiceServiceSelected) {
      emit(
        ChangeServiceDateTimeOptionSelected(
          services: currentState.services,
          businessId: currentState.businessId,
          originalAppointment: currentState.originalAppointment,
          selectedService: currentState.selectedService,
          keepDateTime: true,
        ),
      );
    }
  }

  Future<void> _onSelectChangeDateTime(
    SelectChangeDateTime event,
    Emitter<ChangeServiceState> emit,
  ) async {
    final currentState = state;
    if (currentState is ChangeServiceServiceSelected) {
      emit(
        ChangeServiceDateTimeOptionSelected(
          services: currentState.services,
          businessId: currentState.businessId,
          originalAppointment: currentState.originalAppointment,
          selectedService: currentState.selectedService,
          keepDateTime: false,
        ),
      );
    } else if (currentState is ChangeServiceAvailabilityLoaded) {
      
      emit(
        ChangeServiceDateTimeOptionSelected(
          services: currentState.services,
          businessId: currentState.businessId,
          originalAppointment: currentState.originalAppointment,
          selectedService: currentState.selectedService,
          keepDateTime: false,
        ),
      );
    } else if (currentState is ChangeServiceTimeSlotSelected) {
      
      emit(
        ChangeServiceDateTimeOptionSelected(
          services: currentState.services,
          businessId: currentState.businessId,
          originalAppointment: currentState.originalAppointment,
          selectedService: currentState.selectedService,
          keepDateTime: false,
        ),
      );
    }
  }

  Future<void> _onSelectDate(
    SelectDate event,
    Emitter<ChangeServiceState> emit,
  ) async {
    final currentState = state;
    if (currentState is ChangeServiceDateTimeOptionSelected &&
        !currentState.keepDateTime) {
      emit(
        ChangeServiceDateSelected(
          services: currentState.services,
          businessId: currentState.businessId,
          originalAppointment: currentState.originalAppointment,
          selectedService: currentState.selectedService,
          selectedDate: event.date,
        ),
      );
    }
  }

  Future<void> _onLoadAvailability(
    LoadAvailability event,
    Emitter<ChangeServiceState> emit,
  ) async {
    final currentState = state;
    if (currentState is ChangeServiceDateSelected) {
      emit(ChangeServiceLoading());

      try {
        final availability = await getAvailability(
          businessId: event.businessId,
          barberId: event.barberId,
          date: event.date,
          days: event.days,
        );

        emit(
          ChangeServiceAvailabilityLoaded(
            services: currentState.services,
            businessId: currentState.businessId,
            originalAppointment: currentState.originalAppointment,
            selectedService: currentState.selectedService,
            selectedDate: currentState.selectedDate,
            availability: availability,
          ),
        );
      } catch (e) {
        logger.e('Error loading availability: $e');
        emit(ChangeServiceError(e.toString()));
      }
    }
  }

  Future<void> _onSelectTimeSlot(
    SelectTimeSlot event,
    Emitter<ChangeServiceState> emit,
  ) async {
    final currentState = state;
    if (currentState is ChangeServiceAvailabilityLoaded) {
      emit(
        ChangeServiceTimeSlotSelected(
          services: currentState.services,
          businessId: currentState.businessId,
          originalAppointment: currentState.originalAppointment,
          selectedService: currentState.selectedService,
          selectedDate: currentState.selectedDate,
          availability: currentState.availability,
          selectedTimeSlot: event.timeSlot,
        ),
      );
    }
  }

  Future<void> _onUpdateClientNotes(
    UpdateClientNotes event,
    Emitter<ChangeServiceState> emit,
  ) async {
    final currentState = state;

    if (currentState is ChangeServiceDateTimeOptionSelected &&
        currentState.keepDateTime) {
      emit(
        ChangeServiceWithNotes(
          services: currentState.services,
          businessId: currentState.businessId,
          originalAppointment: currentState.originalAppointment,
          selectedService: currentState.selectedService,
          clientNotes: event.notes,
          keepDateTime: true,
        ),
      );
    } else if (currentState is ChangeServiceTimeSlotSelected) {
      emit(
        ChangeServiceWithNotes(
          services: currentState.services,
          businessId: currentState.businessId,
          originalAppointment: currentState.originalAppointment,
          selectedService: currentState.selectedService,
          selectedDate: currentState.selectedDate,
          availability: currentState.availability,
          selectedTimeSlot: currentState.selectedTimeSlot,
          clientNotes: event.notes,
          keepDateTime: false,
        ),
      );
    } else if (currentState is ChangeServiceWithNotes) {
      emit(
        ChangeServiceWithNotes(
          services: currentState.services,
          businessId: currentState.businessId,
          originalAppointment: currentState.originalAppointment,
          selectedService: currentState.selectedService,
          selectedDate: currentState.selectedDate,
          availability: currentState.availability,
          selectedTimeSlot: currentState.selectedTimeSlot,
          clientNotes: event.notes,
          keepDateTime: currentState.keepDateTime,
        ),
      );
    }
  }

  Future<void> _onSubmitChangeService(
    SubmitChangeService event,
    Emitter<ChangeServiceState> emit,
  ) async {
    final currentState = state;

    
    if (currentState is! ChangeServiceWithNotes &&
        !(currentState is ChangeServiceDateTimeOptionSelected &&
            currentState.keepDateTime) &&
        currentState is! ChangeServiceTimeSlotSelected) {
      emit(const ChangeServiceError('Debe completar todos los datos'));
      return;
    }

    emit(ChangeServiceSubmitting());

    try {
      String scheduledDatetime;
      String barberId;
      String clientNotes;

      
      final selectedService = _getSelectedServiceFromState(currentState);
      final originalAppointment = _getOriginalAppointmentFromState(
        currentState,
      );
      final keepDateTime = _getKeepDateTimeFromState(currentState);

      
      if (currentState is ChangeServiceWithNotes) {
        clientNotes = currentState.clientNotes.isNotEmpty
            ? currentState.clientNotes
            : originalAppointment.clientNotes ?? '';
      } else {
        
        clientNotes = originalAppointment.clientNotes ?? '';
      }

      
      final serviceBarberId = _getBarberIdFromService(selectedService);
      if (serviceBarberId == null) {
        emit(
          const ChangeServiceError(
            'El servicio seleccionado no tiene barberos asignados',
          ),
        );
        return;
      }

      if (keepDateTime) {
        
        logger.d('Original DateTime: ${originalAppointment.scheduledDatetime}');
        logger.d(
          'Original String: ${originalAppointment.scheduledDatetimeOriginal}',
        );

        
        final originalDateTime = originalAppointment.scheduledDatetime;
        
        final mexicoDateTime = originalDateTime.toUtc().subtract(
          const Duration(hours: 6),
        );
        scheduledDatetime = mexicoDateTime.toIso8601String();

        logger.d('Converted to UTC-6 for request: $scheduledDatetime');

        barberId = serviceBarberId;
      } else {

        final selectedDate = _getSelectedDateFromState(currentState);
        final selectedTimeSlot = _getSelectedTimeSlotFromState(currentState);

        if (selectedTimeSlot == null || selectedDate == null) {
          emit(const ChangeServiceError('Debe seleccionar fecha y horario'));
          return;
        }
        scheduledDatetime = _formatDateTime(
          selectedDate,
          selectedTimeSlot.time,
          convertToUtc: false, 
        );
        barberId =
            serviceBarberId; 
      }

      final request = ChangeServiceRequest(
        scheduledDatetime: scheduledDatetime,
        barberId: barberId,
        serviceId: selectedService.id,
        clientNotes: clientNotes,
      );
      logger.d('requestttt: $request');
      final response = await changeServiceUseCase(
        originalAppointment.id,
        request,
      );

      emit(ChangeServiceSuccess(response));
    } catch (e) {
      logger.e('Error changing service: $e');
      emit(ChangeServiceError(e.toString()));
    }
  }

  
  String? _getBarberIdFromService(Service service) {
    if (service.barberAssignments.isEmpty) {
      return null;
    }

    
    final preferredBarber = service.barberAssignments
        .where((assignment) => assignment.isPreferred)
        .firstOrNull;

    if (preferredBarber != null) {
      return preferredBarber.barberId;
    }

    
    return service.barberAssignments.first.barberId;
  }

  String _formatDateTime(
    DateTime date,
    String time, {
    bool convertToUtc = false,
  }) {
    final timeParts = time.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    
    final mexicoDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      hour,
      minute,
    );

    if (convertToUtc) {
      
      final utcDateTime = mexicoDateTime.subtract(const Duration(hours: 6));
      return utcDateTime.toIso8601String();
    } else {
      
      return mexicoDateTime.toIso8601String();
    }
  }

  Future<void> _onResetSelection(
    ResetSelection event,
    Emitter<ChangeServiceState> emit,
  ) async {
    emit(ChangeServiceInitial());
  }

  
  Service _getSelectedServiceFromState(ChangeServiceState state) {
    if (state is ChangeServiceServiceSelected) return state.selectedService;
    if (state is ChangeServiceDateTimeOptionSelected)
      return state.selectedService;
    if (state is ChangeServiceDateSelected) return state.selectedService;
    if (state is ChangeServiceAvailabilityLoaded) return state.selectedService;
    if (state is ChangeServiceTimeSlotSelected) return state.selectedService;
    if (state is ChangeServiceWithNotes) return state.selectedService;
    throw Exception('Service not found in state');
  }

  Appointment _getOriginalAppointmentFromState(ChangeServiceState state) {
    if (state is ChangeServiceServiceSelected) return state.originalAppointment;
    if (state is ChangeServiceDateTimeOptionSelected)
      return state.originalAppointment;
    if (state is ChangeServiceDateSelected) return state.originalAppointment;
    if (state is ChangeServiceAvailabilityLoaded)
      return state.originalAppointment;
    if (state is ChangeServiceTimeSlotSelected)
      return state.originalAppointment;
    if (state is ChangeServiceWithNotes) return state.originalAppointment;
    throw Exception('Appointment not found in state');
  }

  bool _getKeepDateTimeFromState(ChangeServiceState state) {
    if (state is ChangeServiceDateTimeOptionSelected) return state.keepDateTime;
    if (state is ChangeServiceWithNotes) return state.keepDateTime;
    return false;
  }

  DateTime? _getSelectedDateFromState(ChangeServiceState state) {
    if (state is ChangeServiceDateSelected) return state.selectedDate;
    if (state is ChangeServiceAvailabilityLoaded) return state.selectedDate;
    if (state is ChangeServiceTimeSlotSelected) return state.selectedDate;
    if (state is ChangeServiceWithNotes) return state.selectedDate;
    return null;
  }

  TimeSlot? _getSelectedTimeSlotFromState(ChangeServiceState state) {
    if (state is ChangeServiceTimeSlotSelected) return state.selectedTimeSlot;
    if (state is ChangeServiceWithNotes) return state.selectedTimeSlot;
    return null;
  }
}
