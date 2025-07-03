import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_barbers.dart';
import 'barber_home_event.dart';
import 'barber_home_state.dart';

class BarberHomeBloc extends Bloc<BarberHomeEvent, BarberHomeState> {
  final GetBarbers getBarbers;

  BarberHomeBloc({required this.getBarbers}) : super(BarberHomeInitial()) {
    on<LoadBarbersEvent>(_onLoadBarbers);
  }

  Future<void> _onLoadBarbers(
    LoadBarbersEvent event,
    Emitter<BarberHomeState> emit,
  ) async {
    try {
      emit(BarberHomeLoading());
      final barbers = await getBarbers(event.businessId);
      emit(BarberHomeSuccess(barbers));
    } catch (e) {
      emit(BarberHomeError(e.toString()));
    }
  }
}
