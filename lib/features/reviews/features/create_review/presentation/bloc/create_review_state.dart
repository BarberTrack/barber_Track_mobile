import 'package:equatable/equatable.dart';
import '../../domain/entities/create_review_response.dart';

abstract class CreateReviewState extends Equatable {
  const CreateReviewState();

  @override
  List<Object?> get props => [];
}

class CreateReviewInitial extends CreateReviewState {}

class CreateReviewLoading extends CreateReviewState {}

class CreateReviewSuccess extends CreateReviewState {
  final CreateReviewResponse response;

  const CreateReviewSuccess(this.response);

  @override
  List<Object> get props => [response];
}

class CreateReviewError extends CreateReviewState {
  final String message;

  const CreateReviewError(this.message);

  @override
  List<Object> get props => [message];
}
