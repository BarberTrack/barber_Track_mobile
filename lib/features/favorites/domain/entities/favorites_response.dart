import 'package:equatable/equatable.dart';
import 'favorite.dart';

class FavoritesResponse extends Equatable {
  final bool success;
  final String message;
  final FavoritesData data;

  const FavoritesResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  @override
  List<Object> get props => [success, message, data];
}

class FavoritesData extends Equatable {
  final List<Favorite> favorites;

  const FavoritesData({required this.favorites});

  @override
  List<Object> get props => [favorites];
}
