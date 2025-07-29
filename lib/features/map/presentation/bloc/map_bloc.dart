import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_map_businesses.dart';
import '../../domain/usecases/get_map_businesses_with_filters.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final GetMapBusinesses getMapBusinesses;
  final GetMapBusinessesWithFilters getMapBusinessesWithFilters;

  MapBloc({
    required this.getMapBusinesses,
    required this.getMapBusinessesWithFilters,
  }) : super(const MapInitial()) {
    on<LoadMapBusinesses>(_onLoadMapBusinesses);
    on<RefreshMapBusinesses>(_onRefreshMapBusinesses);
    on<LoadMapBusinessesWithFilters>(_onLoadMapBusinessesWithFilters);
    on<ClearMapFilters>(_onClearMapFilters);
  }

  Future<void> _onLoadMapBusinesses(
    LoadMapBusinesses event,
    Emitter<MapState> emit,
  ) async {
    try {
      emit(const MapLoading());

      final response = await getMapBusinesses.call();

      emit(MapLoaded(response));
    } catch (e) {
      emit(MapError('Error al cargar los negocios: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshMapBusinesses(
    RefreshMapBusinesses event,
    Emitter<MapState> emit,
  ) async {
    try {
      final response = await getMapBusinesses.call();

      emit(MapLoaded(response));
    } catch (e) {
      emit(MapError('Error al refrescar los negocios: ${e.toString()}'));
    }
  }

  Future<void> _onLoadMapBusinessesWithFilters(
    LoadMapBusinessesWithFilters event,
    Emitter<MapState> emit,
  ) async {
    try {
      emit(const MapLoading());

      final response = await getMapBusinessesWithFilters.call(event.filters);

      emit(MapLoadedWithFilters(response, event.filters));
    } catch (e) {
      emit(MapError('Error al cargar los negocios filtrados: ${e.toString()}'));
    }
  }

  Future<void> _onClearMapFilters(
    ClearMapFilters event,
    Emitter<MapState> emit,
  ) async {
    try {
      final response = await getMapBusinesses.call();

      emit(MapLoaded(response));
    } catch (e) {
      emit(MapError('Error al limpiar los filtros: ${e.toString()}'));
    }
  }
}
