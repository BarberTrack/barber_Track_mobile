import '../../domain/entities/face_analysis.dart';
import '../models/face_analysis_model.dart';

class FaceAnalysisMapper {
  static FaceAnalysis toEntity(FaceAnalysisModel model) {
    return FaceAnalysis(
      analysisId: model.analysisId,
      visagismo: _visagismoToEntity(model.visagismo),
      recommendations: model.recommendations
          .map((rec) => _styleRecommendationToEntity(rec))
          .toList(),
      analysisInfo: _analysisInfoToEntity(model.analysis),
      dailyUsage: _dailyUsageToEntity(model.dailyUsage),
    );
  }

  static Visagismo _visagismoToEntity(VisagismoModel model) {
    return Visagismo(
      formaRostro: model.formaRostro,
      proporcionesFaciales: _proporcionesFacialesToEntity(
        model.proporcionesFaciales,
      ),
      armoniaFacial: _armoniaFacialToEntity(model.armoniaFacial),
    );
  }

  static ProporcionesFaciales _proporcionesFacialesToEntity(
    ProporcionesFacialesModel model,
  ) {
    return ProporcionesFaciales(
      analisisFrontal: _analisisFrontalToEntity(model.analisisFrontal),
      analisisPerfil: _analisisPerfilToEntity(model.analisisPerfil),
    );
  }

  static AnalisisFrontal _analisisFrontalToEntity(AnalisisFrontalModel model) {
    return AnalisisFrontal(
      anchoFrente: model.anchoFrente,
      anchoPomulos: model.anchoPomulos,
      anchoMandibula: model.anchoMandibula,
      largoRostro: model.largoRostro,
    );
  }

  static AnalisisPerfil _analisisPerfilToEntity(AnalisisPerfilModel model) {
    return AnalisisPerfil(
      inclinacionFrente: model.inclinacionFrente,
      perfilNariz: model.perfilNariz,
      proyeccionMenton: model.proyeccionMenton,
      definicionMandibula: model.definicionMandibula,
    );
  }

  static ArmoniaFacial _armoniaFacialToEntity(ArmoniaFacialModel model) {
    return ArmoniaFacial(
      proporcionAurea: model.proporcionAurea,
      puntuacionSimetria: model.puntuacionSimetria,
      indiceEquilibrio: model.indiceEquilibrio,
    );
  }

  static StyleRecommendation _styleRecommendationToEntity(
    StyleRecommendationModel model,
  ) {
    return StyleRecommendation(
      nombreEstilo: model.nombreEstilo,
      descripcion: model.descripcion,
      razonamientoVisagismo: model.razonamientoVisagismo,
      puntuacionAdecuacion: model.puntuacionAdecuacion,
      dificultad: model.dificultad,
      nivelMantenimiento: model.nivelMantenimiento,
    );
  }

  static AnalysisInfo _analysisInfoToEntity(AnalysisInfoModel model) {
    return AnalysisInfo(
      confidence: model.confidence,
      processingTime: model.processingTime,
      llmModel: model.llmModel,
    );
  }

  static DailyUsage _dailyUsageToEntity(DailyUsageModel model) {
    return DailyUsage(
      usedToday: model.usedToday,
      remainingToday: model.remainingToday,
      resetTime: DateTime.parse(model.resetTime),
    );
  }
}
