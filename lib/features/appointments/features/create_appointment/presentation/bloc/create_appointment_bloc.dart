import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import '../../domain/entities/service.dart';
import '../../domain/entities/availability.dart';
import '../../domain/entities/time_slot.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/usecases/get_business_services.dart';
import '../../domain/usecases/get_availability.dart';
import '../../domain/usecases/create_appointment.dart' as appointment_usecase;
import '../../../../../../core/utils/notes_validator.dart';

part 'create_appointment_event.dart';
part 'create_appointment_state.dart';

class CreateAppointmentBloc
    extends Bloc<CreateAppointmentEvent, CreateAppointmentState> {
  final GetBusinessServices getBusinessServices;
  final GetAvailability getAvailability;
  final appointment_usecase.CreateAppointment createAppointmentUseCase;
  final Logger logger = Logger();

  CreateAppointmentBloc({
    required this.getBusinessServices,
    required this.getAvailability,
    required this.createAppointmentUseCase,
  }) : super(CreateAppointmentInitial()) {
    on<LoadBusinessServices>(_onLoadBusinessServices);
    on<SelectService>(_onSelectService);
    on<SelectDate>(_onSelectDate);
    on<LoadAvailability>(_onLoadAvailability);
    on<SelectTimeSlot>(_onSelectTimeSlot);
    on<SelectTimeSlotWithDate>(_onSelectTimeSlotWithDate);
    on<UpdateClientNotes>(_onUpdateClientNotes);
    on<ValidateClientNotes>(_onValidateClientNotes);
    on<CreateAppointment>(_onCreateAppointment);
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
    } else if (currentState is CreateAppointmentDateSelected) {
      emit(
        CreateAppointmentDateSelected(
          services: currentState.services,
          businessId: currentState.businessId,
          selectedService: currentState.selectedService,
          selectedDate: event.date,
        ),
      );
    } else if (currentState is CreateAppointmentAvailabilityLoaded) {
      emit(
        CreateAppointmentDateSelected(
          services: currentState.services,
          businessId: currentState.businessId,
          selectedService: currentState.selectedService,
          selectedDate: event.date,
        ),
      );
    } else if (currentState is CreateAppointmentTimeSlotSelected) {
      emit(
        CreateAppointmentDateSelected(
          services: currentState.services,
          businessId: currentState.businessId,
          selectedService: currentState.selectedService,
          selectedDate: event.date,
        ),
      );
    } else if (currentState is CreateAppointmentWithNotes) {
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
    } else if (currentState is CreateAppointmentTimeSlotSelected) {
      
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
    } else if (currentState is CreateAppointmentWithNotes) {
      
      emit(
        CreateAppointmentWithNotes(
          services: currentState.services,
          businessId: currentState.businessId,
          selectedService: currentState.selectedService,
          selectedDate: currentState.selectedDate,
          availability: currentState.availability,
          selectedTimeSlot: event.timeSlot,
          clientNotes: currentState.clientNotes,
        ),
      );
    }
  }

  Future<void> _onSelectTimeSlotWithDate(
    SelectTimeSlotWithDate event,
    Emitter<CreateAppointmentState> emit,
  ) async {
    final currentState = state;
    if (currentState is CreateAppointmentAvailabilityLoaded) {
      emit(
        CreateAppointmentTimeSlotSelected(
          services: currentState.services,
          businessId: currentState.businessId,
          selectedService: currentState.selectedService,
          selectedDate:
              event.selectedDate, 
          availability: currentState.availability,
          selectedTimeSlot: event.timeSlot,
        ),
      );
    } else if (currentState is CreateAppointmentTimeSlotSelected) {
      
      emit(
        CreateAppointmentTimeSlotSelected(
          services: currentState.services,
          businessId: currentState.businessId,
          selectedService: currentState.selectedService,
          selectedDate:
              event.selectedDate, 
          availability: currentState.availability,
          selectedTimeSlot: event.timeSlot,
        ),
      );
    } else if (currentState is CreateAppointmentWithNotes) {
      
      emit(
        CreateAppointmentWithNotes(
          services: currentState.services,
          businessId: currentState.businessId,
          selectedService: currentState.selectedService,
          selectedDate:
              event.selectedDate, 
          availability: currentState.availability,
          selectedTimeSlot: event.timeSlot,
          clientNotes: currentState.clientNotes,
        ),
      );
    }
  }

  Future<void> _onUpdateClientNotes(
    UpdateClientNotes event,
    Emitter<CreateAppointmentState> emit,
  ) async {
    final currentState = state;
    if (currentState is CreateAppointmentTimeSlotSelected) {
      emit(
        CreateAppointmentWithNotes(
          services: currentState.services,
          businessId: currentState.businessId,
          selectedService: currentState.selectedService,
          selectedDate: currentState.selectedDate,
          availability: currentState.availability,
          selectedTimeSlot: currentState.selectedTimeSlot,
          clientNotes: event.notes,
        ),
      );
    } else if (currentState is CreateAppointmentWithNotes) {
      emit(
        CreateAppointmentWithNotes(
          services: currentState.services,
          businessId: currentState.businessId,
          selectedService: currentState.selectedService,
          selectedDate: currentState.selectedDate,
          availability: currentState.availability,
          selectedTimeSlot: currentState.selectedTimeSlot,
          clientNotes: event.notes,
        ),
      );
    }
  }

  Future<void> _onValidateClientNotes(
    ValidateClientNotes event,
    Emitter<CreateAppointmentState> emit,
  ) async {
    final currentState = state;

    
    if (currentState is! CreateAppointmentTimeSlotSelected &&
        currentState is! CreateAppointmentWithNotes &&
        currentState is! CreateAppointmentNotesError) {
      return;
    }

    
    final validationError = NotesValidator.validateNotes(event.notes);

    if (validationError != null) {
      
      if (currentState is CreateAppointmentTimeSlotSelected) {
        emit(
          CreateAppointmentNotesError(
            services: currentState.services,
            businessId: currentState.businessId,
            selectedService: currentState.selectedService,
            selectedDate: currentState.selectedDate,
            availability: currentState.availability,
            selectedTimeSlot: currentState.selectedTimeSlot,
            clientNotes: event.notes,
            errorMessage: validationError,
          ),
        );
      } else if (currentState is CreateAppointmentWithNotes) {
        emit(
          CreateAppointmentNotesError(
            services: currentState.services,
            businessId: currentState.businessId,
            selectedService: currentState.selectedService,
            selectedDate: currentState.selectedDate,
            availability: currentState.availability,
            selectedTimeSlot: currentState.selectedTimeSlot,
            clientNotes: event.notes,
            errorMessage: validationError,
          ),
        );
      } else if (currentState is CreateAppointmentNotesError) {
        emit(
          CreateAppointmentNotesError(
            services: currentState.services,
            businessId: currentState.businessId,
            selectedService: currentState.selectedService,
            selectedDate: currentState.selectedDate,
            availability: currentState.availability,
            selectedTimeSlot: currentState.selectedTimeSlot,
            clientNotes: event.notes,
            errorMessage: validationError,
          ),
        );
      }
    } else {

      if (currentState is CreateAppointmentTimeSlotSelected) {
        
        if (event.notes.trim().isEmpty) {
          
          return;
        } else {
          emit(
            CreateAppointmentWithNotes(
              services: currentState.services,
              businessId: currentState.businessId,
              selectedService: currentState.selectedService,
              selectedDate: currentState.selectedDate,
              availability: currentState.availability,
              selectedTimeSlot: currentState.selectedTimeSlot,
              clientNotes: event.notes,
            ),
          );
        }
      } else if (currentState is CreateAppointmentWithNotes) {
        if (event.notes.trim().isEmpty) {
          
          emit(
            CreateAppointmentTimeSlotSelected(
              services: currentState.services,
              businessId: currentState.businessId,
              selectedService: currentState.selectedService,
              selectedDate: currentState.selectedDate,
              availability: currentState.availability,
              selectedTimeSlot: currentState.selectedTimeSlot,
            ),
          );
        } else {
          emit(
            CreateAppointmentWithNotes(
              services: currentState.services,
              businessId: currentState.businessId,
              selectedService: currentState.selectedService,
              selectedDate: currentState.selectedDate,
              availability: currentState.availability,
              selectedTimeSlot: currentState.selectedTimeSlot,
              clientNotes: event.notes,
            ),
          );
        }
      } else if (currentState is CreateAppointmentNotesError) {
        if (event.notes.trim().isEmpty) {
          
          emit(
            CreateAppointmentTimeSlotSelected(
              services: currentState.services,
              businessId: currentState.businessId,
              selectedService: currentState.selectedService,
              selectedDate: currentState.selectedDate,
              availability: currentState.availability,
              selectedTimeSlot: currentState.selectedTimeSlot,
            ),
          );
        } else {
          emit(
            CreateAppointmentWithNotes(
              services: currentState.services,
              businessId: currentState.businessId,
              selectedService: currentState.selectedService,
              selectedDate: currentState.selectedDate,
              availability: currentState.availability,
              selectedTimeSlot: currentState.selectedTimeSlot,
              clientNotes: event.notes,
            ),
          );
        }
      }
    }
  }

  Future<void> _onCreateAppointment(
    CreateAppointment event,
    Emitter<CreateAppointmentState> emit,
  ) async {
    final currentState = state;

    
    if (currentState is! CreateAppointmentTimeSlotSelected &&
        currentState is! CreateAppointmentWithNotes) {
      emit(
        const CreateAppointmentError(
          'Debe seleccionar un servicio, fecha y horario',
        ),
      );
      return;
    }

    emit(CreateAppointmentCreating());

    try {
      String businessId, barberId, serviceId, scheduledDatetime;
      String? clientNotes;

      if (currentState is CreateAppointmentTimeSlotSelected) {
        businessId = currentState.businessId;
        barberId = currentState.selectedTimeSlot.barberId;
        serviceId = currentState.selectedService.id;
        scheduledDatetime = _formatDateTime(
          currentState.selectedDate,
          currentState.selectedTimeSlot.time,
        );
        clientNotes = null;
      } else if (currentState is CreateAppointmentWithNotes) {
        businessId = currentState.businessId;
        barberId = currentState.selectedTimeSlot.barberId;
        serviceId = currentState.selectedService.id;
        scheduledDatetime = _formatDateTime(
          currentState.selectedDate,
          currentState.selectedTimeSlot.time,
        );
        clientNotes = currentState.clientNotes;
      } else {
        emit(const CreateAppointmentError('Estado inválido para crear cita'));
        return;
      }

      final request = CreateAppointmentRequest(
        businessId: businessId,
        barberId: barberId,
        serviceId: serviceId,
        scheduledDatetime: scheduledDatetime,
        clientNotes: clientNotes,
      );

      final response = await createAppointmentUseCase(request);
      emit(CreateAppointmentSuccess(response));
    } catch (e) {
      logger.e('Error creating appointment: $e');
      emit(CreateAppointmentError(e.toString()));
    }
  }

  String _formatDateTime(DateTime date, String time) {
    final timeParts = time.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    final dateTime = DateTime(date.year, date.month, date.day, hour, minute);

    return dateTime.toIso8601String();
  }

  Future<void> _onResetSelection(
    ResetSelection event,
    Emitter<CreateAppointmentState> emit,
  ) async {
    emit(CreateAppointmentInitial());
  }
}
