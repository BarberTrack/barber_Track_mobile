import 'package:equatable/equatable.dart';
import '../../domain/entities/map_businesses_response.dart';

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

  const MapLoaded(this.response);

  @override
  List<Object?> get props => [response];
}

class MapError extends MapState {
  final String message;

  const MapError(this.message);

  @override
  List<Object?> get props => [message];
}
