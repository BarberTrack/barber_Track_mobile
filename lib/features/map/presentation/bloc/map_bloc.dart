import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../domain/usecases/get_map_businesses.dart';
import '../../domain/usecases/get_map_businesses_with_filters.dart';
import '../../domain/entities/map_business_filters.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final GetMapBusinesses getMapBusinesses;
  final GetMapBusinessesWithFilters getMapBusinessesWithFilters;
  final Logger logger = Logger();

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
      logger.i('Cargando negocios para el mapa...');

      final response = await getMapBusinesses.call();

      logger.i('Negocios cargados exitosamente para el mapa');
      logger.i('Total de negocios: ${response.total}');
      logger.i('Página actual: ${response.page}');
      logger.i('Total de páginas: ${response.totalPages}');

      // Mostrar información detallada de cada negocio en consola
      for (int i = 0; i < response.businesses.length; i++) {
        final business = response.businesses[i];
        logger.i('=== NEGOCIO ${i + 1} ===');
        logger.i('ID: ${business.id}');
        logger.i('Nombre: ${business.name}');
        logger.i('Descripción: ${business.description}');
        logger.i('Dirección: ${business.address}');
        logger.i('Teléfono: ${business.phone}');
        logger.i('Email: ${business.email}');

        if (business.latitude != null && business.longitude != null) {
          logger.i('Coordenadas: ${business.latitude}, ${business.longitude}');
        } else {
          logger.w('Sin coordenadas GPS disponibles');
        }

        logger.i('Rating promedio: ${business.ratingAverage}');
        logger.i('Total de reseñas: ${business.totalReviews}');
        logger.i('Activo: ${business.isActive}');
        logger.i('Horarios: ${business.businessHours}');

        if (business.galleryImages.isNotEmpty) {
          logger.i('Imágenes de galería (${business.galleryImages.length}):');
          for (int j = 0; j < business.galleryImages.length; j++) {
            logger.i('  ${j + 1}. ${business.galleryImages[j]}');
          }
        } else {
          logger.w('Sin imágenes de galería');
        }

        logger.i('Política de cancelación: ${business.cancellationPolicy}');

        if (business.products.isNotEmpty) {
          logger.i('Productos disponibles: ${business.products.length}');
        }

        if (business.promotions.isNotEmpty) {
          logger.i('Promociones activas: ${business.promotions.length}');
        }

        logger.i('Creado: ${business.createdAt}');
        logger.i('Actualizado: ${business.updatedAt}');
        logger.i('========================');
      }

      emit(MapLoaded(response));
    } catch (e) {
      logger.e('Error al cargar negocios del mapa: $e');
      emit(MapError('Error al cargar los negocios: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshMapBusinesses(
    RefreshMapBusinesses event,
    Emitter<MapState> emit,
  ) async {
    try {
      logger.i('Refrescando negocios del mapa...');
      final response = await getMapBusinesses.call();

      logger.i('Negocios refrescados exitosamente');
      emit(MapLoaded(response));
    } catch (e) {
      logger.e('Error al refrescar negocios del mapa: $e');
      emit(MapError('Error al refrescar los negocios: ${e.toString()}'));
    }
  }

  Future<void> _onLoadMapBusinessesWithFilters(
    LoadMapBusinessesWithFilters event,
    Emitter<MapState> emit,
  ) async {
    try {
      emit(const MapLoading());
      logger.i('Cargando negocios filtrados para el mapa...');
      logger.i('Filtros aplicados: ${event.filters.activeFiltersDescription}');

      final response = await getMapBusinessesWithFilters.call(event.filters);

      logger.i('Negocios filtrados cargados exitosamente para el mapa');
      logger.i('Total de negocios filtrados: ${response.total}');
      logger.i('Página actual: ${response.page}');
      logger.i('Total de páginas: ${response.totalPages}');

      // Mostrar información detallada de cada negocio filtrado en consola
      for (int i = 0; i < response.businesses.length; i++) {
        final business = response.businesses[i];
        logger.i('=== NEGOCIO FILTRADO ${i + 1} ===');
        logger.i('ID: ${business.id}');
        logger.i('Nombre: ${business.name}');
        logger.i('Descripción: ${business.description}');
        logger.i('Dirección: ${business.address}');
        logger.i('Teléfono: ${business.phone}');
        logger.i('Email: ${business.email}');

        if (business.latitude != null && business.longitude != null) {
          logger.i('Coordenadas: ${business.latitude}, ${business.longitude}');
        } else {
          logger.w('Sin coordenadas GPS disponibles');
        }

        logger.i('Rating promedio: ${business.ratingAverage}');
        logger.i('Total de reseñas: ${business.totalReviews}');
        logger.i('Activo: ${business.isActive}');
        logger.i('Horarios: ${business.businessHours}');

        if (business.galleryImages.isNotEmpty) {
          logger.i('Imágenes de galería (${business.galleryImages.length}):');
          for (int j = 0; j < business.galleryImages.length; j++) {
            logger.i('  ${j + 1}. ${business.galleryImages[j]}');
          }
        } else {
          logger.w('Sin imágenes de galería');
        }

        logger.i('Política de cancelación: ${business.cancellationPolicy}');

        if (business.products.isNotEmpty) {
          logger.i('Productos disponibles: ${business.products.length}');
        }

        if (business.promotions.isNotEmpty) {
          logger.i('Promociones activas: ${business.promotions.length}');
        }

        logger.i('Creado: ${business.createdAt}');
        logger.i('Actualizado: ${business.updatedAt}');
        logger.i('========================');
      }

      emit(MapLoadedWithFilters(response, event.filters));
    } catch (e) {
      logger.e('Error al cargar negocios filtrados del mapa: $e');
      emit(MapError('Error al cargar los negocios filtrados: ${e.toString()}'));
    }
  }

  Future<void> _onClearMapFilters(
    ClearMapFilters event,
    Emitter<MapState> emit,
  ) async {
    try {
      logger.i('Limpiando filtros del mapa...');
      final response = await getMapBusinesses.call();

      logger.i('Filtros limpiados exitosamente');
      emit(MapLoaded(response));
    } catch (e) {
      logger.e('Error al limpiar filtros del mapa: $e');
      emit(MapError('Error al limpiar los filtros: ${e.toString()}'));
    }
  }
}
