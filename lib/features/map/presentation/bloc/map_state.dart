import 'package:equatable/equatable.dart';
import '../../domain/entities/map_businesses_response.dart';
import '../../domain/entities/map_business_filters.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

class MapInitial extends MapState {
  const MapInitial();
}

class MapLoading extends MapState {
  const MapLoading();
}

class MapLoaded extends MapState {
  final MapBusinessesResponse response;
  final MapBusinessFilters? currentFilters;

  const MapLoaded(this.response, {this.currentFilters});

  @override
  List<Object?> get props => [response, currentFilters];
}

class MapLoadedWithFilters extends MapState {
  final MapBusinessesResponse response;
  final MapBusinessFilters filters;

  const MapLoadedWithFilters(this.response, this.filters);

  @override
  List<Object?> get props => [response, filters];
}

class MapError extends MapState {
  final String message;

  const MapError(this.message);

  @override
  List<Object?> get props => [message];
}
