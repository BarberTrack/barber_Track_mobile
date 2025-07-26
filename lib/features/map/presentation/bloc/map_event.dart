import 'package:equatable/equatable.dart';
import '../../domain/entities/map_business_filters.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

class LoadMapBusinesses extends MapEvent {
  const LoadMapBusinesses();
}

class RefreshMapBusinesses extends MapEvent {
  const RefreshMapBusinesses();
}

class LoadMapBusinessesWithFilters extends MapEvent {
  final MapBusinessFilters filters;

  const LoadMapBusinessesWithFilters(this.filters);

  @override
  List<Object?> get props => [filters];
}

class ClearMapFilters extends MapEvent {
  const ClearMapFilters();
}
