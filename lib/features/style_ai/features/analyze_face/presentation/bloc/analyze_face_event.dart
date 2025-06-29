part of 'analyze_face_bloc.dart';

abstract class AnalyzeFaceEvent extends Equatable {
  const AnalyzeFaceEvent();

  @override
  List<Object?> get props => [];
}

class SelectFrontPhotoEvent extends AnalyzeFaceEvent {
  final File photo;

  const SelectFrontPhotoEvent(this.photo);

  @override
  List<Object?> get props => [photo];
}

class SelectProfilePhotoEvent extends AnalyzeFaceEvent {
  final File photo;

  const SelectProfilePhotoEvent(this.photo);

  @override
  List<Object?> get props => [photo];
}

class AnalyzeFaceStartEvent extends AnalyzeFaceEvent {
  const AnalyzeFaceStartEvent();
}

class ResetAnalysisEvent extends AnalyzeFaceEvent {
  const ResetAnalysisEvent();
}
