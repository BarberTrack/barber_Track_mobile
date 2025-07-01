import 'package:equatable/equatable.dart';

class StyleHistory extends Equatable {
  final List<Analysis> analyses;
  final int totalCount;
  final bool hasMore;
  final DailyUsage dailyUsage;

  const StyleHistory({
    required this.analyses,
    required this.totalCount,
    required this.hasMore,
    required this.dailyUsage,
  });

  @override
  List<Object?> get props => [analyses, totalCount, hasMore, dailyUsage];
}

class Analysis extends Equatable {
  final String id;
  final DateTime analyzedAt;
  final String analysisType;
  final Visagismo? visagismo;
  final StyleDescription? styleDescription;
  final List<RecommendedStyle> recommendedStyles;

  const Analysis({
    required this.id,
    required this.analyzedAt,
    required this.analysisType,
    this.visagismo,
    this.styleDescription,
    required this.recommendedStyles,
  });

  @override
  List<Object?> get props => [
    id,
    analyzedAt,
    analysisType,
    visagismo,
    styleDescription,
    recommendedStyles,
  ];
}

class StyleDescription extends Equatable {
  final String nombreEstilo;
  final String descripcionDetallada;

  const StyleDescription({
    required this.nombreEstilo,
    required this.descripcionDetallada,
  });

  @override
  List<Object?> get props => [nombreEstilo, descripcionDetallada];
}

class Visagismo extends Equatable {
  final String formaRostro;
  final ProporcionesFaciales proporcionesFaciales;

  const Visagismo({
    required this.formaRostro,
    required this.proporcionesFaciales,
  });

  @override
  List<Object?> get props => [formaRostro, proporcionesFaciales];
}

class ProporcionesFaciales extends Equatable {
  final AnalisisPerfil analisisPerfil;
  final AnalisisFrontal analisisFrontal;

  const ProporcionesFaciales({
    required this.analisisPerfil,
    required this.analisisFrontal,
  });

  @override
  List<Object?> get props => [analisisPerfil, analisisFrontal];
}

class AnalisisPerfil extends Equatable {
  final String perfilNariz;
  final String proyeccionMenton;
  final String inclinacionFrente;
  final String definicionMandibula;

  const AnalisisPerfil({
    required this.perfilNariz,
    required this.proyeccionMenton,
    required this.inclinacionFrente,
    required this.definicionMandibula,
  });

  @override
  List<Object?> get props => [
    perfilNariz,
    proyeccionMenton,
    inclinacionFrente,
    definicionMandibula,
  ];
}

class AnalisisFrontal extends Equatable {
  final String anchoFrente;
  final String largoRostro;
  final String anchoPomulos;
  final String anchoMandibula;

  const AnalisisFrontal({
    required this.anchoFrente,
    required this.largoRostro,
    required this.anchoPomulos,
    required this.anchoMandibula,
  });

  @override
  List<Object?> get props => [
    anchoFrente,
    largoRostro,
    anchoPomulos,
    anchoMandibula,
  ];
}

class RecommendedStyle extends Equatable {
  final String nombreEstilo;
  final int puntuacionAdecuacion;
  final String descripcion;
  final String dificultad;
  final String nivelMantenimiento;

  const RecommendedStyle({
    required this.nombreEstilo,
    required this.puntuacionAdecuacion,
    required this.descripcion,
    required this.dificultad,
    required this.nivelMantenimiento,
  });

  @override
  List<Object?> get props => [
    nombreEstilo,
    puntuacionAdecuacion,
    descripcion,
    dificultad,
    nivelMantenimiento,
  ];
}

class DailyUsage extends Equatable {
  final int usedToday;
  final int remainingToday;
  final DateTime resetTime;

  const DailyUsage({
    required this.usedToday,
    required this.remainingToday,
    required this.resetTime,
  });

  @override
  List<Object?> get props => [usedToday, remainingToday, resetTime];
}
