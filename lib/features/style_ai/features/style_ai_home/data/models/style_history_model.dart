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
      analyses: (json['analyses'] as List<dynamic>? ?? [])
          .map((e) => AnalysisModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: json['totalCount'] as int? ?? 0,
      hasMore: json['hasMore'] as bool? ?? false,
      dailyUsage: json['dailyUsage'] != null
          ? DailyUsageModel.fromJson(json['dailyUsage'] as Map<String, dynamic>)
          : DailyUsageModel(usedToday: 0, remainingToday: 5, resetTime: ''),
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
      id: json['id'] as String? ?? '',
      analyzedAt:
          json['analyzedAt'] as String? ?? DateTime.now().toIso8601String(),
      analysisType: json['analysisType'] as String? ?? 'unknown',
      visagismo: json['visagismo'] != null
          ? VisagismoModel.fromJson(json['visagismo'] as Map<String, dynamic>)
          : VisagismoModel(
              formaRostro: 'desconocido',
              proporcionesFaciales: ProporcionesFacialesModel(
                analisisPerfil: AnalisisPerfilModel(
                  perfilNariz: 'desconocido',
                  proyeccionMenton: 'desconocido',
                  inclinacionFrente: 'desconocido',
                  definicionMandibula: 'desconocido',
                ),
                analisisFrontal: AnalisisFrontalModel(
                  anchoFrente: 'desconocido',
                  largoRostro: 'desconocido',
                  anchoPomulos: 'desconocido',
                  anchoMandibula: 'desconocido',
                ),
              ),
            ),
      recommendedStyles: (json['recommendedStyles'] as List<dynamic>? ?? [])
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
      formaRostro: json['formaRostro'] as String? ?? 'desconocido',
      proporcionesFaciales: json['proporcionesFaciales'] != null
          ? ProporcionesFacialesModel.fromJson(
              json['proporcionesFaciales'] as Map<String, dynamic>,
            )
          : ProporcionesFacialesModel(
              analisisPerfil: AnalisisPerfilModel(
                perfilNariz: 'desconocido',
                proyeccionMenton: 'desconocido',
                inclinacionFrente: 'desconocido',
                definicionMandibula: 'desconocido',
              ),
              analisisFrontal: AnalisisFrontalModel(
                anchoFrente: 'desconocido',
                largoRostro: 'desconocido',
                anchoPomulos: 'desconocido',
                anchoMandibula: 'desconocido',
              ),
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
      analisisPerfil: json['analisisPerfil'] != null
          ? AnalisisPerfilModel.fromJson(
              json['analisisPerfil'] as Map<String, dynamic>,
            )
          : AnalisisPerfilModel(
              perfilNariz: 'desconocido',
              proyeccionMenton: 'desconocido',
              inclinacionFrente: 'desconocido',
              definicionMandibula: 'desconocido',
            ),
      analisisFrontal: json['analisisFrontal'] != null
          ? AnalisisFrontalModel.fromJson(
              json['analisisFrontal'] as Map<String, dynamic>,
            )
          : AnalisisFrontalModel(
              anchoFrente: 'desconocido',
              largoRostro: 'desconocido',
              anchoPomulos: 'desconocido',
              anchoMandibula: 'desconocido',
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
      perfilNariz: json['perfilNariz'] as String? ?? 'desconocido',
      proyeccionMenton: json['proyeccionMenton'] as String? ?? 'desconocido',
      inclinacionFrente: json['inclinacionFrente'] as String? ?? 'desconocido',
      definicionMandibula:
          json['definicionMandibula'] as String? ?? 'desconocido',
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
      anchoFrente: json['anchoFrente'] as String? ?? 'desconocido',
      largoRostro: json['largoRostro'] as String? ?? 'desconocido',
      anchoPomulos: json['anchoPomulos'] as String? ?? 'desconocido',
      anchoMandibula: json['anchoMandibula'] as String? ?? 'desconocido',
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
      nombreEstilo: json['nombreEstilo'] as String? ?? 'Sin nombre',
      puntuacionAdecuacion: json['puntuacionAdecuacion'] as int? ?? 0,
      descripcion: json['descripcion'] as String? ?? 'Sin descripción',
      dificultad: json['dificultad'] as String? ?? 'desconocido',
      nivelMantenimiento:
          json['nivelMantenimiento'] as String? ?? 'desconocido',
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
      usedToday: json['usedToday'] as int? ?? 0,
      remainingToday: json['remainingToday'] as int? ?? 5,
      resetTime: json['resetTime'] as String? ?? '',
    );
  }
}
