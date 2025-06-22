import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/barber_business.dart';
import '../../domain/usecases/get_business_by_id.dart';

part 'barberdetails_event.dart';
part 'barberdetails_state.dart';

class BarberdetailsBloc extends Bloc<BarberdetailsEvent, BarberdetailsState> {
  final GetBusinessById getBusinessById;

  BarberdetailsBloc(this.getBusinessById) : super(BarberdetailsInitial()) {
    on<LoadBusinessDetails>(_onLoadBusinessDetails);
  }

  Future<void> _onLoadBusinessDetails(
    LoadBusinessDetails event,
    Emitter<BarberdetailsState> emit,
  ) async {
    emit(BarberdetailsLoading());

    try {
      final business = await getBusinessById(event.businessId);
      emit(BarberdetailsLoaded(business));
    } catch (e) {
      emit(BarberdetailsError(e.toString()));
    }
  }
}
