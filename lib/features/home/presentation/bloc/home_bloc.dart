import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/business.dart';
import '../../domain/entities/business_filters.dart';
import '../../domain/usecases/get_businesses.dart';
import '../../domain/usecases/get_businesses_with_filters.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetBusinesses getBusinesses;
  final GetBusinessesWithFilters getBusinessesWithFilters;

  HomeBloc(this.getBusinesses, this.getBusinessesWithFilters)
    : super(HomeInitial()) {
    on<LoadBusinesses>(_onLoadBusinesses);
    on<RefreshBusinesses>(_onRefreshBusinesses);
    on<LoadBusinessesWithFilters>(_onLoadBusinessesWithFilters);
    on<LoadMoreBusinesses>(_onLoadMoreBusinesses);
  }

  Future<void> _onLoadBusinesses(
    LoadBusinesses event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final businesses = await getBusinesses();
      emit(HomeLoaded(businesses));
    } catch (e) {
      emit(HomeError('Error al cargar las barberías: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshBusinesses(
    RefreshBusinesses event,
    Emitter<HomeState> emit,
  ) async {
 
    try {
      final businesses = await getBusinesses();
      emit(HomeLoaded(businesses));
    } catch (e) {
      emit(HomeError('Error al actualizar las barberías: ${e.toString()}'));
    }
  }

  Future<void> _onLoadBusinessesWithFilters(
    LoadBusinessesWithFilters event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final response = await getBusinessesWithFilters(event.filters);
      emit(
        HomeLoadedWithFilters(
          businesses: response.businesses,
          currentFilters: event.filters,
          total: response.total,
          page: response.page,
          totalPages: response.totalPages,
        ),
      );
    } catch (e) {
      emit(HomeError('Error al cargar las barberías: ${e.toString()}'));
    }
  }

  Future<void> _onLoadMoreBusinesses(
    LoadMoreBusinesses event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is HomeLoadedWithFilters &&
        currentState.hasMore &&
        !currentState.isLoadingMore) {
      emit(currentState.copyWith(isLoadingMore: true));

      try {
        final nextPageFilters = event.filters.copyWith(
          page: currentState.page + 1,
        );
        final response = await getBusinessesWithFilters(nextPageFilters);

        final hasReceivedEmptyResponse = response.businesses.isEmpty;

        final allBusinesses = List<Business>.from(currentState.businesses)
          ..addAll(response.businesses);

        emit(
          HomeLoadedWithFilters(
            businesses: allBusinesses,
            currentFilters: nextPageFilters,
            total: response.total,
            page: response.page,
            totalPages: response.totalPages,
            hasReceivedEmptyResponse: hasReceivedEmptyResponse,
          ),
        );
      } catch (e) {
        emit(currentState.copyWith(isLoadingMore: false));
        emit(HomeError('Error al cargar más barberías: ${e.toString()}'));
      }
    }
  }
}
