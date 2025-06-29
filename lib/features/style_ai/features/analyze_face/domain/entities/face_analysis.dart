import 'package:equatable/equatable.dart';

class FaceAnalysis extends Equatable {
  final String analysisId;
  final Visagismo visagismo;
  final List<StyleRecommendation> recommendations;
  final AnalysisInfo analysisInfo;
  final DailyUsage dailyUsage;

  const FaceAnalysis({
    required this.analysisId,
    required this.visagismo,
    required this.recommendations,
    required this.analysisInfo,
    required this.dailyUsage,
  });

  @override
  List<Object?> get props => [
    analysisId,
    visagismo,
    recommendations,
    analysisInfo,
    dailyUsage,
  ];
}

class Visagismo extends Equatable {
  final String formaRostro;
  final ProporcionesFaciales proporcionesFaciales;
  final ArmoniaFacial armoniaFacial;

  const Visagismo({
    required this.formaRostro,
    required this.proporcionesFaciales,
    required this.armoniaFacial,
  });

  @override
  List<Object?> get props => [formaRostro, proporcionesFaciales, armoniaFacial];
}

class ProporcionesFaciales extends Equatable {
  final AnalisisFrontal analisisFrontal;
  final AnalisisPerfil analisisPerfil;

  const ProporcionesFaciales({
    required this.analisisFrontal,
    required this.analisisPerfil,
  });

  @override
  List<Object?> get props => [analisisFrontal, analisisPerfil];
}

class AnalisisFrontal extends Equatable {
  final String anchoFrente;
  final String anchoPomulos;
  final String anchoMandibula;
  final String largoRostro;

  const AnalisisFrontal({
    required this.anchoFrente,
    required this.anchoPomulos,
    required this.anchoMandibula,
    required this.largoRostro,
  });

  @override
  List<Object?> get props => [
    anchoFrente,
    anchoPomulos,
    anchoMandibula,
    largoRostro,
  ];
}

class AnalisisPerfil extends Equatable {
  final String inclinacionFrente;
  final String perfilNariz;
  final String proyeccionMenton;
  final String definicionMandibula;

  const AnalisisPerfil({
    required this.inclinacionFrente,
    required this.perfilNariz,
    required this.proyeccionMenton,
    required this.definicionMandibula,
  });

  @override
  List<Object?> get props => [
    inclinacionFrente,
    perfilNariz,
    proyeccionMenton,
    definicionMandibula,
  ];
}

class ArmoniaFacial extends Equatable {
  final double proporcionAurea;
  final int puntuacionSimetria;
  final int indiceEquilibrio;

  const ArmoniaFacial({
    required this.proporcionAurea,
    required this.puntuacionSimetria,
    required this.indiceEquilibrio,
  });

  @override
  List<Object?> get props => [
    proporcionAurea,
    puntuacionSimetria,
    indiceEquilibrio,
  ];
}

class StyleRecommendation extends Equatable {
  final String nombreEstilo;
  final String descripcion;
  final String razonamientoVisagismo;
  final int puntuacionAdecuacion;
  final String dificultad;
  final String nivelMantenimiento;

  const StyleRecommendation({
    required this.nombreEstilo,
    required this.descripcion,
    required this.razonamientoVisagismo,
    required this.puntuacionAdecuacion,
    required this.dificultad,
    required this.nivelMantenimiento,
  });

  @override
  List<Object?> get props => [
    nombreEstilo,
    descripcion,
    razonamientoVisagismo,
    puntuacionAdecuacion,
    dificultad,
    nivelMantenimiento,
  ];
}

class AnalysisInfo extends Equatable {
  final int confidence;
  final int processingTime;
  final String llmModel;

  const AnalysisInfo({
    required this.confidence,
    required this.processingTime,
    required this.llmModel,
  });

  @override
  List<Object?> get props => [confidence, processingTime, llmModel];
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
