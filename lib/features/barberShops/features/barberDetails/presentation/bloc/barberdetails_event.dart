part of 'barberdetails_bloc.dart';

abstract class BarberdetailsEvent extends Equatable {
  const BarberdetailsEvent();

  @override
  List<Object> get props => [];
}

class LoadBusinessDetails extends BarberdetailsEvent {
  final String businessId;

  const LoadBusinessDetails(this.businessId);

  @override
  List<Object> get props => [businessId];
}
