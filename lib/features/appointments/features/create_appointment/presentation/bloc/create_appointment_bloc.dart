import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_appointment_event.dart';
part 'create_appointment_state.dart';

class CreateAppointmentBloc extends Bloc<CreateAppointmentEvent, CreateAppointmentState> {
  CreateAppointmentBloc() : super(CreateAppointmentInitial()) {
    on<CreateAppointmentEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
