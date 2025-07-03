import 'package:equatable/equatable.dart';

class CreateReviewRequest extends Equatable {
  final String appointmentId;
  final int businessRating;
  final int barberRating;
  final String comment;

  const CreateReviewRequest({
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
