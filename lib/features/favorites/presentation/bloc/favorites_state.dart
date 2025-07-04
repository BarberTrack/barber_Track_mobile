import 'package:equatable/equatable.dart';
import '../../domain/entities/favorite.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Favorite> favorites;

  const FavoritesLoaded(this.favorites);

  @override
  List<Object> get props => [favorites];
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object> get props => [message];
}

// Estados específicos para agregar/quitar favoritos
class AddingToFavorites extends FavoritesState {}

class AddToFavoritesSuccess extends FavoritesState {
  final String message;

  const AddToFavoritesSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class AddToFavoritesError extends FavoritesState {
  final String message;

  const AddToFavoritesError(this.message);

  @override
  List<Object> get props => [message];
}

class RemovingFromFavorites extends FavoritesState {}

class RemoveFromFavoritesSuccess extends FavoritesState {
  final String message;

  const RemoveFromFavoritesSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class RemoveFromFavoritesError extends FavoritesState {
  final String message;

  const RemoveFromFavoritesError(this.message);

  @override
  List<Object> get props => [message];
}

class FavoriteStatusChecked extends FavoritesState {
  final String businessId;
  final bool isFavorite;

  const FavoriteStatusChecked({
    required this.businessId,
    required this.isFavorite,
  });

  @override
  List<Object> get props => [businessId, isFavorite];
}
