import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/usecases/get_appointments.dart';

part 'appointments_event.dart';
part 'appointments_state.dart';

class AppointmentsBloc extends Bloc<AppointmentsEvent, AppointmentsState> {
  final GetAppointments getAppointments;
  final Logger logger = Logger();

  AppointmentsBloc({required this.getAppointments})
    : super(AppointmentsInitial()) {
    on<LoadAppointments>(_onLoadAppointments);
    on<RefreshAppointments>(_onRefreshAppointments);
    on<FilterAppointmentsByStatus>(_onFilterAppointmentsByStatus);
  }

  Future<void> _onLoadAppointments(
    LoadAppointments event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(AppointmentsLoading());

    try {
      final response = await getAppointments(
        page: event.page,
        limit: event.limit,
        status: event.status,
      );

      emit(
        AppointmentsLoaded(
          appointments: response.appointments,
          total: response.total,
          page: response.page,
          totalPages: response.totalPages,
          currentFilter: event.status,
        ),
      );
    } catch (e) {
      logger.e('Error loading appointments: $e');
      emit(AppointmentsError(e.toString()));
    }
  }

  Future<void> _onRefreshAppointments(
    RefreshAppointments event,
    Emitter<AppointmentsState> emit,
  ) async {
    try {
      final response = await getAppointments(
        page: 1,
        limit: 10,
        status: event.status,
      );

      emit(
        AppointmentsLoaded(
          appointments: response.appointments,
          total: response.total,
          page: response.page,
          totalPages: response.totalPages,
          currentFilter: event.status,
        ),
      );
    } catch (e) {
      logger.e('Error refreshing appointments: $e');
      emit(AppointmentsError(e.toString()));
    }
  }

  Future<void> _onFilterAppointmentsByStatus(
    FilterAppointmentsByStatus event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(AppointmentsLoading());

    try {
      final response = await getAppointments(
        page: 1,
        limit: 10,
        status: event.status,
      );

      emit(
        AppointmentsLoaded(
          appointments: response.appointments,
          total: response.total,
          page: response.page,
          totalPages: response.totalPages,
          currentFilter: event.status,
        ),
      );
    } catch (e) {
      logger.e('Error filtering appointments: $e');
      emit(AppointmentsError(e.toString()));
    }
  }
}
