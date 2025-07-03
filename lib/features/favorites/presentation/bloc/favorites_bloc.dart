import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_favorites.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavorites getFavoritesUseCase;

  FavoritesBloc({required this.getFavoritesUseCase})
    : super(FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<RefreshFavorites>(_onRefreshFavorites);
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());
    await _fetchFavorites(emit);
  }

  Future<void> _onRefreshFavorites(
    RefreshFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    await _fetchFavorites(emit);
  }

  Future<void> _fetchFavorites(Emitter<FavoritesState> emit) async {
    try {
      final response = await getFavoritesUseCase.execute();
      emit(FavoritesLoaded(response.data.favorites));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }
}
