part of 'appointments_bloc.dart';

abstract class AppointmentsState extends Equatable {
  const AppointmentsState();

  @override
  List<Object?> get props => [];
}

class AppointmentsInitial extends AppointmentsState {}

class AppointmentsLoading extends AppointmentsState {}

class AppointmentsLoaded extends AppointmentsState {
  final List<Appointment> appointments;
  final int total;
  final int page;
  final int totalPages;
  final String? currentFilter;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const AppointmentsLoaded({
    required this.appointments,
    required this.total,
    required this.page,
    required this.totalPages,
    this.currentFilter,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  AppointmentsLoaded copyWith({
    List<Appointment>? appointments,
    int? total,
    int? page,
    int? totalPages,
    String? currentFilter,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return AppointmentsLoaded(
      appointments: appointments ?? this.appointments,
      total: total ?? this.total,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      currentFilter: currentFilter ?? this.currentFilter,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    appointments,
    total,
    page,
    totalPages,
    currentFilter,
    hasReachedMax,
    isLoadingMore,
  ];
}

class AppointmentsError extends AppointmentsState {
  final String message;

  const AppointmentsError(this.message);

  @override
  List<Object> get props => [message];
}
