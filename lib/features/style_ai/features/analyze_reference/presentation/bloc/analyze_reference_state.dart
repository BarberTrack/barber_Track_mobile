import 'package:equatable/equatable.dart';
import '../../domain/entities/style_analysis.dart';

abstract class AnalyzeReferenceState extends Equatable {
  const AnalyzeReferenceState();

  @override
  List<Object?> get props => [];
}

class AnalyzeReferenceInitial extends AnalyzeReferenceState {}

class AnalyzeReferenceLoading extends AnalyzeReferenceState {}

class AnalyzeReferenceSuccess extends AnalyzeReferenceState {
  final StyleAnalysis styleAnalysis;

  AnalyzeReferenceSuccess(this.styleAnalysis);

  @override
  List<Object?> get props => [styleAnalysis];
}

class AnalyzeReferenceError extends AnalyzeReferenceState {
  final String message;

  AnalyzeReferenceError(this.message);

  @override
  List<Object?> get props => [message];
}
