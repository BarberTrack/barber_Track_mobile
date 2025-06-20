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
