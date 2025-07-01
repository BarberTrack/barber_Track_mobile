import '../../domain/entities/style_history.dart';
import '../models/style_history_model.dart';

class StyleHistoryMapper {
  static StyleHistory toEntity(StyleHistoryModel model) {
    return StyleHistory(
      analyses: model.analyses
          .map((analysis) => _analysisToEntity(analysis))
          .toList(),
      totalCount: model.totalCount,
      hasMore: model.hasMore,
      dailyUsage: _dailyUsageToEntity(model.dailyUsage),
    );
  }

  static Analysis _analysisToEntity(AnalysisModel model) {
    return Analysis(
      id: model.id,
      analyzedAt: DateTime.parse(model.analyzedAt),
      analysisType: model.analysisType,
      visagismo: model.visagismo != null
          ? _visagismoToEntity(model.visagismo!)
          : null,
      styleDescription: model.styleDescription != null
          ? _styleDescriptionToEntity(model.styleDescription!)
          : null,
      recommendedStyles: model.recommendedStyles
          .map((style) => _recommendedStyleToEntity(style))
          .toList(),
    );
  }

  static StyleDescription _styleDescriptionToEntity(
    StyleDescriptionModel model,
  ) {
    return StyleDescription(
      nombreEstilo: model.nombreEstilo,
      descripcionDetallada: model.descripcionDetallada,
    );
  }

  static Visagismo _visagismoToEntity(VisagismoModel model) {
    return Visagismo(
      formaRostro: model.formaRostro,
      proporcionesFaciales: _proporcionesFacialesToEntity(
        model.proporcionesFaciales,
      ),
    );
  }

  static ProporcionesFaciales _proporcionesFacialesToEntity(
    ProporcionesFacialesModel model,
  ) {
    return ProporcionesFaciales(
      analisisPerfil: _analisisPerfilToEntity(model.analisisPerfil),
      analisisFrontal: _analisisFrontalToEntity(model.analisisFrontal),
    );
  }

  static AnalisisPerfil _analisisPerfilToEntity(AnalisisPerfilModel model) {
    return AnalisisPerfil(
      perfilNariz: model.perfilNariz,
      proyeccionMenton: model.proyeccionMenton,
      inclinacionFrente: model.inclinacionFrente,
      definicionMandibula: model.definicionMandibula,
    );
  }

  static AnalisisFrontal _analisisFrontalToEntity(AnalisisFrontalModel model) {
    return AnalisisFrontal(
      anchoFrente: model.anchoFrente,
      largoRostro: model.largoRostro,
      anchoPomulos: model.anchoPomulos,
      anchoMandibula: model.anchoMandibula,
    );
  }

  static RecommendedStyle _recommendedStyleToEntity(
    RecommendedStyleModel model,
  ) {
    return RecommendedStyle(
      nombreEstilo: model.nombreEstilo,
      puntuacionAdecuacion: model.puntuacionAdecuacion,
      descripcion: model.descripcion,
      dificultad: model.dificultad,
      nivelMantenimiento: model.nivelMantenimiento,
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
