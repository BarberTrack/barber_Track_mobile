class FaceAnalysisModel {
  final String analysisId;
  final VisagismoModel visagismo;
  final List<StyleRecommendationModel> recommendations;
  final AnalysisInfoModel analysis;
  final DailyUsageModel dailyUsage;

  const FaceAnalysisModel({
    required this.analysisId,
    required this.visagismo,
    required this.recommendations,
    required this.analysis,
    required this.dailyUsage,
  });

  factory FaceAnalysisModel.fromJson(Map<String, dynamic> json) {
    return FaceAnalysisModel(
      analysisId: json['analysisId'] as String,
      visagismo: VisagismoModel.fromJson(
        json['visagismo'] as Map<String, dynamic>,
      ),
      recommendations: (json['recommendations'] as List<dynamic>)
          .map(
            (e) => StyleRecommendationModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      analysis: AnalysisInfoModel.fromJson(
        json['analysis'] as Map<String, dynamic>,
      ),
      dailyUsage: DailyUsageModel.fromJson(
        json['dailyUsage'] as Map<String, dynamic>,
      ),
    );
  }
}

class VisagismoModel {
  final String formaRostro;
  final ProporcionesFacialesModel proporcionesFaciales;
  final ArmoniaFacialModel armoniaFacial;

  const VisagismoModel({
    required this.formaRostro,
    required this.proporcionesFaciales,
    required this.armoniaFacial,
  });

  factory VisagismoModel.fromJson(Map<String, dynamic> json) {
    return VisagismoModel(
      formaRostro: json['formaRostro'] as String,
      proporcionesFaciales: ProporcionesFacialesModel.fromJson(
        json['proporcionesFaciales'] as Map<String, dynamic>,
      ),
      armoniaFacial: ArmoniaFacialModel.fromJson(
        json['armoniaFacial'] as Map<String, dynamic>,
      ),
    );
  }
}

class ProporcionesFacialesModel {
  final AnalisisFrontalModel analisisFrontal;
  final AnalisisPerfilModel analisisPerfil;

  const ProporcionesFacialesModel({
    required this.analisisFrontal,
    required this.analisisPerfil,
  });

  factory ProporcionesFacialesModel.fromJson(Map<String, dynamic> json) {
    return ProporcionesFacialesModel(
      analisisFrontal: AnalisisFrontalModel.fromJson(
        json['analisisFrontal'] as Map<String, dynamic>,
      ),
      analisisPerfil: AnalisisPerfilModel.fromJson(
        json['analisisPerfil'] as Map<String, dynamic>,
      ),
    );
  }
}

class AnalisisFrontalModel {
  final String anchoFrente;
  final String anchoPomulos;
  final String anchoMandibula;
  final String largoRostro;

  const AnalisisFrontalModel({
    required this.anchoFrente,
    required this.anchoPomulos,
    required this.anchoMandibula,
    required this.largoRostro,
  });

  factory AnalisisFrontalModel.fromJson(Map<String, dynamic> json) {
    return AnalisisFrontalModel(
      anchoFrente: json['anchoFrente'] as String,
      anchoPomulos: json['anchoPomulos'] as String,
      anchoMandibula: json['anchoMandibula'] as String,
      largoRostro: json['largoRostro'] as String,
    );
  }
}

class AnalisisPerfilModel {
  final String inclinacionFrente;
  final String perfilNariz;
  final String proyeccionMenton;
  final String definicionMandibula;

  const AnalisisPerfilModel({
    required this.inclinacionFrente,
    required this.perfilNariz,
    required this.proyeccionMenton,
    required this.definicionMandibula,
  });

  factory AnalisisPerfilModel.fromJson(Map<String, dynamic> json) {
    return AnalisisPerfilModel(
      inclinacionFrente: json['inclinacionFrente'] as String,
      perfilNariz: json['perfilNariz'] as String,
      proyeccionMenton: json['proyeccionMenton'] as String,
      definicionMandibula: json['definicionMandibula'] as String,
    );
  }
}

class ArmoniaFacialModel {
  final double proporcionAurea;
  final int puntuacionSimetria;
  final int indiceEquilibrio;

  const ArmoniaFacialModel({
    required this.proporcionAurea,
    required this.puntuacionSimetria,
    required this.indiceEquilibrio,
  });

  factory ArmoniaFacialModel.fromJson(Map<String, dynamic> json) {
    return ArmoniaFacialModel(
      proporcionAurea: (json['proporcionAurea'] as num).toDouble(),
      puntuacionSimetria: json['puntuacionSimetria'] as int,
      indiceEquilibrio: json['indiceEquilibrio'] as int,
    );
  }
}

class StyleRecommendationModel {
  final String nombreEstilo;
  final String descripcion;
  final String razonamientoVisagismo;
  final int puntuacionAdecuacion;
  final String dificultad;
  final String nivelMantenimiento;

  const StyleRecommendationModel({
    required this.nombreEstilo,
    required this.descripcion,
    required this.razonamientoVisagismo,
    required this.puntuacionAdecuacion,
    required this.dificultad,
    required this.nivelMantenimiento,
  });

  factory StyleRecommendationModel.fromJson(Map<String, dynamic> json) {
    return StyleRecommendationModel(
      nombreEstilo: json['nombreEstilo'] as String,
      descripcion: json['descripcion'] as String,
      razonamientoVisagismo: json['razonamientoVisagismo'] as String,
      puntuacionAdecuacion: json['puntuacionAdecuacion'] as int,
      dificultad: json['dificultad'] as String,
      nivelMantenimiento: json['nivelMantenimiento'] as String,
    );
  }
}

class AnalysisInfoModel {
  final int confidence;
  final int processingTime;
  final String llmModel;

  const AnalysisInfoModel({
    required this.confidence,
    required this.processingTime,
    required this.llmModel,
  });

  factory AnalysisInfoModel.fromJson(Map<String, dynamic> json) {
    return AnalysisInfoModel(
      confidence: json['confidence'] as int,
      processingTime: json['processingTime'] as int,
      llmModel: json['llmModel'] as String,
    );
  }
}

class DailyUsageModel {
  final int usedToday;
  final int remainingToday;
  final String resetTime;

  const DailyUsageModel({
    required this.usedToday,
    required this.remainingToday,
    required this.resetTime,
  });

  factory DailyUsageModel.fromJson(Map<String, dynamic> json) {
    return DailyUsageModel(
      usedToday: json['usedToday'] as int,
      remainingToday: json['remainingToday'] as int,
      resetTime: json['resetTime'] as String,
    );
  }
}
