import 'package:equatable/equatable.dart';
import 'favorite.dart';

abstract class AddFavoriteResponse extends Equatable {
  final bool success;
  final String message;
  final Favorite data;

  const AddFavoriteResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  @override
  List<Object?> get props => [success, message, data];
}
