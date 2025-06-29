part of 'analyze_face_bloc.dart';

abstract class AnalyzeFaceState extends Equatable {
  const AnalyzeFaceState();

  @override
  List<Object?> get props => [];
}

class AnalyzeFaceInitial extends AnalyzeFaceState {}

class AnalyzeFacePhotoSelected extends AnalyzeFaceState {
  final File? frontPhoto;
  final File? profilePhoto;

  const AnalyzeFacePhotoSelected({this.frontPhoto, this.profilePhoto});

  bool get canAnalyze => frontPhoto != null && profilePhoto != null;

  @override
  List<Object?> get props => [frontPhoto, profilePhoto];
}

class AnalyzeFaceLoading extends AnalyzeFaceState {
  final File frontPhoto;
  final File profilePhoto;

  const AnalyzeFaceLoading({
    required this.frontPhoto,
    required this.profilePhoto,
  });

  @override
  List<Object?> get props => [frontPhoto, profilePhoto];
}

class AnalyzeFaceSuccess extends AnalyzeFaceState {
  final FaceAnalysis faceAnalysis;

  const AnalyzeFaceSuccess(this.faceAnalysis);

  @override
  List<Object?> get props => [faceAnalysis];
}

class AnalyzeFaceError extends AnalyzeFaceState {
  final String message;
  final File? frontPhoto;
  final File? profilePhoto;

  const AnalyzeFaceError({
    required this.message,
    this.frontPhoto,
    this.profilePhoto,
  });

  @override
  List<Object?> get props => [message, frontPhoto, profilePhoto];
}
