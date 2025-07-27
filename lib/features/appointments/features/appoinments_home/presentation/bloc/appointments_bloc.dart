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
    on<LoadMoreAppointments>(_onLoadMoreAppointments);
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
          hasReachedMax: response.page >= response.totalPages,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      logger.e('Error loading appointments: $e');
      emit(AppointmentsError(e.toString()));
    }
  }

  Future<void> _onLoadMoreAppointments(
    LoadMoreAppointments event,
    Emitter<AppointmentsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! AppointmentsLoaded ||
        currentState.hasReachedMax ||
        currentState.isLoadingMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final nextPage = currentState.page + 1;
      final response = await getAppointments(
        page: nextPage,
        limit: 5,
        status: event.status,
      );

      final updatedAppointments = List<Appointment>.from(
        currentState.appointments,
      )..addAll(response.appointments);

      emit(
        currentState.copyWith(
          appointments: updatedAppointments,
          page: response.page,
          hasReachedMax:
              response.page >= response.totalPages ||
              response.appointments.isEmpty,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      logger.e('Error loading more appointments: $e');
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onRefreshAppointments(
    RefreshAppointments event,
    Emitter<AppointmentsState> emit,
  ) async {
    try {
      final response = await getAppointments(
        page: 1,
        limit: 5,
        status: event.status,
      );

      emit(
        AppointmentsLoaded(
          appointments: response.appointments,
          total: response.total,
          page: response.page,
          totalPages: response.totalPages,
          currentFilter: event.status,
          hasReachedMax: response.page >= response.totalPages,
          isLoadingMore: false,
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
        limit: 5,
        status: event.status,
      );

      emit(
        AppointmentsLoaded(
          appointments: response.appointments,
          total: response.total,
          page: response.page,
          totalPages: response.totalPages,
          currentFilter: event.status,
          hasReachedMax: response.page >= response.totalPages,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      logger.e('Error filtering appointments: $e');
      emit(AppointmentsError(e.toString()));
    }
  }
}
