import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/barber_business.dart';
import '../../domain/usecases/get_business_by_id.dart';
import 'package:logger/logger.dart';

part 'barberdetails_event.dart';
part 'barberdetails_state.dart';

class BarberdetailsBloc extends Bloc<BarberdetailsEvent, BarberdetailsState> {
  final GetBusinessById getBusinessById;
  final Logger logger = Logger();
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
      //logger.d(business);
      emit(BarberdetailsLoaded(business));
    } catch (e) {
      logger.e(e);
      emit(BarberdetailsError(e.toString()));
    }
  }
}
