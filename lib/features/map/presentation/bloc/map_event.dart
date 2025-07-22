import 'package:equatable/equatable.dart';

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
