import 'dart:io';
import '../entities/face_analysis.dart';
import '../repositories/face_analysis_repository.dart';

class AnalyzeFace {
  final FaceAnalysisRepository repository;

  AnalyzeFace(this.repository);

  Future<FaceAnalysis> call(AnalyzeFaceParams params) async {
    return await repository.analyzeFace(
      frontPhoto: params.frontPhoto,
      profilePhoto: params.profilePhoto,
    );
  }
}

class AnalyzeFaceParams {
  final File frontPhoto;
  final File profilePhoto;

  AnalyzeFaceParams({required this.frontPhoto, required this.profilePhoto});
}
