import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'appoinments_event.dart';
part 'appoinments_state.dart';

class AppoinmentsBloc extends Bloc<AppoinmentsEvent, AppoinmentsState> {
  AppoinmentsBloc() : super(AppoinmentsInitial()) {
    on<AppoinmentsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
