import 'package:equatable/equatable.dart';

abstract class CreateReviewEvent extends Equatable {
  const CreateReviewEvent();

  @override
  List<Object> get props => [];
}

class SubmitReviewEvent extends CreateReviewEvent {
  final String appointmentId;
  final int businessRating;
  final int barberRating;
  final String comment;

  const SubmitReviewEvent({
    required this.appointmentId,
    required this.businessRating,
    required this.barberRating,
    required this.comment,
  });

  @override
  List<Object> get props => [
    appointmentId,
    businessRating,
    barberRating,
    comment,
  ];
}
