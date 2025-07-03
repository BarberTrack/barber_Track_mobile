import 'package:equatable/equatable.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class LoadFavorites extends FavoritesEvent {
  const LoadFavorites();
}

class RefreshFavorites extends FavoritesEvent {
  const RefreshFavorites();
}

class AddFavoriteEvent extends FavoritesEvent {
  final String businessId;

  const AddFavoriteEvent(this.businessId);

  @override
  List<Object> get props => [businessId];
}

class RemoveFavoriteEvent extends FavoritesEvent {
  final String businessId;

  const RemoveFavoriteEvent(this.businessId);

  @override
  List<Object> get props => [businessId];
}

class CheckIfFavoriteEvent extends FavoritesEvent {
  final String businessId;

  const CheckIfFavoriteEvent(this.businessId);

  @override
  List<Object> get props => [businessId];
}
