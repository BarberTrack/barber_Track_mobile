import 'dart:io';
import '../../domain/entities/style_analysis.dart';
import '../../domain/repositories/style_reference_repository.dart';
import '../datasources/style_reference_remote_data_source.dart';
import '../mappers/style_analysis_mapper.dart';

class StyleReferenceRepositoryImpl implements StyleReferenceRepository {
  final StyleReferenceRemoteDataSource remoteDataSource;

  StyleReferenceRepositoryImpl(this.remoteDataSource);

  @override
  Future<StyleAnalysis> analyzeReferenceImage(File referenceImage) async {
    try {
      final responseModel = await remoteDataSource.analyzeReferenceImage(
        referenceImage,
      );

      if (responseModel.success) {
        return StyleAnalysisMapper.toEntity(responseModel.data);
      } else {
        throw Exception('Error en el análisis: ${responseModel.message}');
      }
    } catch (e) {
      throw Exception('Error en el repositorio: $e');
    }
  }
}
