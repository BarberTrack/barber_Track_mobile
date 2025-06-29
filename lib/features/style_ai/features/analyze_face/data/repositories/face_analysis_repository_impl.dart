import 'dart:io';
import '../../domain/entities/face_analysis.dart';
import '../../domain/repositories/face_analysis_repository.dart';
import '../datasources/face_analysis_remote_data_source.dart';
import '../mappers/face_analysis_mapper.dart';

class FaceAnalysisRepositoryImpl implements FaceAnalysisRepository {
  final FaceAnalysisRemoteDataSource remoteDataSource;

  FaceAnalysisRepositoryImpl(this.remoteDataSource);

  @override
  Future<FaceAnalysis> analyzeFace({
    required File frontPhoto,
    required File profilePhoto,
  }) async {
    final faceAnalysisModel = await remoteDataSource.analyzeFace(
      frontPhoto: frontPhoto,
      profilePhoto: profilePhoto,
    );
    return FaceAnalysisMapper.toEntity(faceAnalysisModel);
  }
}
