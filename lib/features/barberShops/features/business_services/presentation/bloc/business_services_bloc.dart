import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/business_services_response.dart';
import '../../domain/usecases/get_business_services.dart';

part 'business_services_event.dart';
part 'business_services_state.dart';

class BusinessServicesBloc
    extends Bloc<BusinessServicesEvent, BusinessServicesState> {
  final GetBusinessServices getBusinessServices;

  BusinessServicesBloc({required this.getBusinessServices})
    : super(const BusinessServicesInitial()) {
    on<LoadBusinessServices>(_onLoadBusinessServices);
  }

  Future<void> _onLoadBusinessServices(
    LoadBusinessServices event,
    Emitter<BusinessServicesState> emit,
  ) async {
    emit(const BusinessServicesLoading());

    try {
      final businessServices = await getBusinessServices(event.businessId);
      emit(BusinessServicesLoaded(businessServices));
    } catch (e) {
      emit(BusinessServicesError(e.toString()));
    }
  }
}
