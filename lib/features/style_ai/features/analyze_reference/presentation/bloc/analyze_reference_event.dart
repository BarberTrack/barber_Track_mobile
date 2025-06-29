import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class AnalyzeReferenceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AnalyzeReferenceImageEvent extends AnalyzeReferenceEvent {
  final File referenceImage;

  AnalyzeReferenceImageEvent(this.referenceImage);

  @override
  List<Object?> get props => [referenceImage];
}

class ResetAnalyzeReferenceEvent extends AnalyzeReferenceEvent {}
