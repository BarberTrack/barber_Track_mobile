import 'package:equatable/equatable.dart';

abstract class BarberHomeEvent extends Equatable {
  const BarberHomeEvent();

  @override
  List<Object> get props => [];
}

class LoadBarbersEvent extends BarberHomeEvent {
  final String businessId;

  const LoadBarbersEvent(this.businessId);

  @override
  List<Object> get props => [businessId];
}
