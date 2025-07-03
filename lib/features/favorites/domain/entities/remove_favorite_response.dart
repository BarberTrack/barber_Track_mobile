import 'package:equatable/equatable.dart';

abstract class RemoveFavoriteResponse extends Equatable {
  final bool success;
  final String message;
  final RemoveFavoriteData data;

  const RemoveFavoriteResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  @override
  List<Object?> get props => [success, message, data];
}

abstract class RemoveFavoriteData extends Equatable {
  final bool removed;
  final String businessId;

  const RemoveFavoriteData({required this.removed, required this.businessId});

  @override
  List<Object?> get props => [removed, businessId];
}
