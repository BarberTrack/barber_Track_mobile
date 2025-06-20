import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/business.dart';
import '../../domain/usecases/get_businesses.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetBusinesses getBusinesses;

  HomeBloc(this.getBusinesses) : super(HomeInitial()) {
    on<LoadBusinesses>(_onLoadBusinesses);
    on<RefreshBusinesses>(_onRefreshBusinesses);
  }

  Future<void> _onLoadBusinesses(
    LoadBusinesses event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final businesses = await getBusinesses();
      emit(HomeLoaded(businesses));
    } catch (e) {
      emit(HomeError('Error al cargar las barberías: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshBusinesses(
    RefreshBusinesses event,
    Emitter<HomeState> emit,
  ) async {
    // todo: lazy loading
    try {
      final businesses = await getBusinesses();
      emit(HomeLoaded(businesses));
    } catch (e) {
      emit(HomeError('Error al actualizar las barberías: ${e.toString()}'));
    }
  }
}
