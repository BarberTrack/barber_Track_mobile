import 'dart:io';
import '../entities/style_analysis.dart';
import '../repositories/style_reference_repository.dart';

class AnalyzeReferenceImage {
  final StyleReferenceRepository repository;

  AnalyzeReferenceImage(this.repository);

  Future<StyleAnalysis> call(File referenceImage) async {
    return await repository.analyzeReferenceImage(referenceImage);
  }
}
