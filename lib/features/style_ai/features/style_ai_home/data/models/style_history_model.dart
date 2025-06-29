class StyleHistoryModel {
  final List<AnalysisModel> analyses;
  final int totalCount;
  final bool hasMore;
  final DailyUsageModel dailyUsage;

  const StyleHistoryModel({
    required this.analyses,
    required this.totalCount,
    required this.hasMore,
    required this.dailyUsage,
  });

  factory StyleHistoryModel.fromJson(Map<String, dynamic> json) {
    return StyleHistoryModel(
      analyses: (json['analyses'] as List<dynamic>)
          .map((e) => AnalysisModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: json['totalCount'] as int,
      hasMore: json['hasMore'] as bool,
      dailyUsage: DailyUsageModel.fromJson(
        json['dailyUsage'] as Map<String, dynamic>,
      ),
    );
  }
}

class AnalysisModel {
  final String id;
  final String analyzedAt;
  final String analysisType;
  final VisagismoModel visagismo;
  final List<RecommendedStyleModel> recommendedStyles;

  const AnalysisModel({
    required this.id,
    required this.analyzedAt,
    required this.analysisType,
    required this.visagismo,
    required this.recommendedStyles,
  });

  factory AnalysisModel.fromJson(Map<String, dynamic> json) {
    return AnalysisModel(
      id: json['id'] as String,
      analyzedAt: json['analyzedAt'] as String,
      analysisType: json['analysisType'] as String,
      visagismo: VisagismoModel.fromJson(
        json['visagismo'] as Map<String, dynamic>,
      ),
      recommendedStyles: (json['recommendedStyles'] as List<dynamic>)
          .map((e) => RecommendedStyleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class VisagismoModel {
  final String formaRostro;
  final ProporcionesFacialesModel proporcionesFaciales;

  const VisagismoModel({
    required this.formaRostro,
    required this.proporcionesFaciales,
  });

  factory VisagismoModel.fromJson(Map<String, dynamic> json) {
    return VisagismoModel(
      formaRostro: json['formaRostro'] as String,
      proporcionesFaciales: ProporcionesFacialesModel.fromJson(
        json['proporcionesFaciales'] as Map<String, dynamic>,
      ),
    );
  }
}

class ProporcionesFacialesModel {
  final AnalisisPerfilModel analisisPerfil;
  final AnalisisFrontalModel analisisFrontal;

  const ProporcionesFacialesModel({
    required this.analisisPerfil,
    required this.analisisFrontal,
  });

  factory ProporcionesFacialesModel.fromJson(Map<String, dynamic> json) {
    return ProporcionesFacialesModel(
      analisisPerfil: AnalisisPerfilModel.fromJson(
        json['analisisPerfil'] as Map<String, dynamic>,
      ),
      analisisFrontal: AnalisisFrontalModel.fromJson(
        json['analisisFrontal'] as Map<String, dynamic>,
      ),
    );
  }
}

class AnalisisPerfilModel {
  final String perfilNariz;
  final String proyeccionMenton;
  final String inclinacionFrente;
  final String definicionMandibula;

  const AnalisisPerfilModel({
    required this.perfilNariz,
    required this.proyeccionMenton,
    required this.inclinacionFrente,
    required this.definicionMandibula,
  });

  factory AnalisisPerfilModel.fromJson(Map<String, dynamic> json) {
    return AnalisisPerfilModel(
      perfilNariz: json['perfilNariz'] as String,
      proyeccionMenton: json['proyeccionMenton'] as String,
      inclinacionFrente: json['inclinacionFrente'] as String,
      definicionMandibula: json['definicionMandibula'] as String,
    );
  }
}

class AnalisisFrontalModel {
  final String anchoFrente;
  final String largoRostro;
  final String anchoPomulos;
  final String anchoMandibula;

  const AnalisisFrontalModel({
    required this.anchoFrente,
    required this.largoRostro,
    required this.anchoPomulos,
    required this.anchoMandibula,
  });

  factory AnalisisFrontalModel.fromJson(Map<String, dynamic> json) {
    return AnalisisFrontalModel(
      anchoFrente: json['anchoFrente'] as String,
      largoRostro: json['largoRostro'] as String,
      anchoPomulos: json['anchoPomulos'] as String,
      anchoMandibula: json['anchoMandibula'] as String,
    );
  }
}

class RecommendedStyleModel {
  final String nombreEstilo;
  final int puntuacionAdecuacion;
  final String descripcion;
  final String dificultad;
  final String nivelMantenimiento;

  const RecommendedStyleModel({
    required this.nombreEstilo,
    required this.puntuacionAdecuacion,
    required this.descripcion,
    required this.dificultad,
    required this.nivelMantenimiento,
  });

  factory RecommendedStyleModel.fromJson(Map<String, dynamic> json) {
    return RecommendedStyleModel(
      nombreEstilo: json['nombreEstilo'] as String,
      puntuacionAdecuacion: json['puntuacionAdecuacion'] as int,
      descripcion: json['descripcion'] as String,
      dificultad: json['dificultad'] as String,
      nivelMantenimiento: json['nivelMantenimiento'] as String,
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
