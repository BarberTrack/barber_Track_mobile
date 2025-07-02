import 'package:equatable/equatable.dart';

abstract class ModerationLogs extends Equatable {
  final Moderation? moderation;

  const ModerationLogs({this.moderation});

  @override
  List<Object?> get props => [moderation];
}

abstract class Moderation extends Equatable {
  final String action;
  final String reason;

  const Moderation({required this.action, required this.reason});

  @override
  List<Object?> get props => [action, reason];
}
