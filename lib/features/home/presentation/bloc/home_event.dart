part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadBusinesses extends HomeEvent {
  const LoadBusinesses();
}

class RefreshBusinesses extends HomeEvent {
  const RefreshBusinesses();
}

class LoadBusinessesWithFilters extends HomeEvent {
  final BusinessFilters filters;
  
  const LoadBusinessesWithFilters(this.filters);
  
  @override
  List<Object> get props => [filters];
}

class LoadMoreBusinesses extends HomeEvent {
  final BusinessFilters filters;
  
  const LoadMoreBusinesses(this.filters);
  
  @override
  List<Object> get props => [filters];
}
