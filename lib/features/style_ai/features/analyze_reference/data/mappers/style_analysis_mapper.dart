import '../models/style_analysis_response_model.dart';
import '../../domain/entities/style_analysis.dart';

class StyleAnalysisMapper {
  static StyleAnalysis toEntity(StyleAnalysisDataModel model) {
    return StyleAnalysis(
      analysisId: model.analysisId,
      styleDescription: _mapStyleDescription(model.styleDescription),
      recommendations: model.recommendations
          .map((recommendation) => _mapStyleRecommendation(recommendation))
          .toList(),
      analysis: _mapAnalysisMetadata(model.analysis),
      dailyUsage: _mapDailyUsage(model.dailyUsage),
    );
  }

  static StyleDescription _mapStyleDescription(StyleDescriptionModel model) {
    return StyleDescription(
      nombreEstilo: model.nombreEstilo,
      descripcionDetallada: model.descripcionDetallada,
      cronogramaMantenimiento: model.cronogramaMantenimiento,
      adecuadoPara: _mapAdecuadoPara(model.adecuadoPara),
    );
  }

  static AdecuadoPara _mapAdecuadoPara(AdecuadoParaModel model) {
    return AdecuadoPara(
      formasRostro: model.formasRostro,
      tiposCabello: model.tiposCabello,
      gruposEdad: model.gruposEdad,
    );
  }

  static StyleRecommendation _mapStyleRecommendation(
    StyleRecommendationModel model,
  ) {
    return StyleRecommendation(
      nombreEstilo: model.nombreEstilo,
      descripcion: model.descripcion,
      puntuacionAdecuacion: model.puntuacionAdecuacion,
      dificultad: model.dificultad,
      nivelMantenimiento: model.nivelMantenimiento,
    );
  }

  static AnalysisMetadata _mapAnalysisMetadata(AnalysisMetadataModel model) {
    return AnalysisMetadata(
      confidence: model.confidence,
      processingTime: model.processingTime,
      llmModel: model.llmModel,
    );
  }

  static DailyUsage _mapDailyUsage(DailyUsageModel model) {
    return DailyUsage(
      usedToday: model.usedToday,
      remainingToday: model.remainingToday,
      resetTime: DateTime.parse(model.resetTime),
    );
  }
}
