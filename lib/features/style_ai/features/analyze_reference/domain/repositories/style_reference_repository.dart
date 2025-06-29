import 'dart:io';
import '../entities/style_analysis.dart';

abstract class StyleReferenceRepository {
  Future<StyleAnalysis> analyzeReferenceImage(File referenceImage);
}
