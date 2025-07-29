import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/add_to_favorites.dart';
import '../../domain/usecases/remove_from_favorites.dart';
import '../../../../core/storage/favorites_storage.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavorites getFavoritesUseCase;
  final AddToFavorites? addToFavoritesUseCase;
  final RemoveFromFavorites? removeFromFavoritesUseCase;
  final FavoritesStorage favoritesStorage;

  FavoritesBloc({
    required this.getFavoritesUseCase,
    this.addToFavoritesUseCase,
    this.removeFromFavoritesUseCase,
    required this.favoritesStorage,
  }) : super(FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<RefreshFavorites>(_onRefreshFavorites);
    on<AddFavoriteEvent>(_onAddFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
    on<CheckIfFavoriteEvent>(_onCheckIfFavorite);
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
      final favorites = response.data.favorites;

      
      final favoriteIds = favorites.map((fav) => fav.businessId).toList();

      if (favoriteIds.isEmpty) {
        await favoritesStorage.clearFavorites();
      } else {
        await favoritesStorage.syncWithServerFavorites(favoriteIds);
      }

      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> _onAddFavorite(
    AddFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    if (addToFavoritesUseCase == null) return;

    emit(AddingToFavorites());
    try {
      final response = await addToFavoritesUseCase!.execute(event.businessId);

      
      await favoritesStorage.addFavoriteBusinessId(event.businessId);

      emit(AddToFavoritesSuccess(response.message));

      
      add(const RefreshFavorites());
    } catch (e) {
      emit(AddToFavoritesError(e.toString()));
    }
  }

  Future<void> _onRemoveFavorite(
    RemoveFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    if (removeFromFavoritesUseCase == null) return;

    emit(RemovingFromFavorites());
    try {
      final response = await removeFromFavoritesUseCase!.execute(
        event.businessId,
      );

      
      await favoritesStorage.removeFavoriteBusinessId(event.businessId);

      emit(RemoveFromFavoritesSuccess(response.message));

      
      add(const RefreshFavorites());
    } catch (e) {
      emit(RemoveFromFavoritesError(e.toString()));
    }
  }

  Future<void> _onCheckIfFavorite(
    CheckIfFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final isFavorite = await favoritesStorage.isFavorite(event.businessId);
      emit(
        FavoriteStatusChecked(
          businessId: event.businessId,
          isFavorite: isFavorite,
        ),
      );
    } catch (e) {
      
      if (state is FavoritesLoaded) {
        final favoritesLoaded = state as FavoritesLoaded;
        final isFavorite = favoritesLoaded.favorites.any(
          (fav) => fav.businessId == event.businessId,
        );
        emit(
          FavoriteStatusChecked(
            businessId: event.businessId,
            isFavorite: isFavorite,
          ),
        );
      } else {
        emit(
          FavoriteStatusChecked(
            businessId: event.businessId,
            isFavorite: false,
          ),
        );
      }
    }
  }
}
