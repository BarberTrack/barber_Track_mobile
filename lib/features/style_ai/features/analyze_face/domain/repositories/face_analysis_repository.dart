import 'dart:io';
import '../entities/face_analysis.dart';

abstract class FaceAnalysisRepository {
  Future<FaceAnalysis> analyzeFace({
    required File frontPhoto,
    required File profilePhoto,
  });
}
