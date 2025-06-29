import 'package:equatable/equatable.dart';

abstract class Entity extends Equatable {
  @override
  List<Object?> get props => [];
}

class StyleAnalysis extends Entity {
  final String analysisId;
  final StyleDescription styleDescription;
  final List<StyleRecommendation> recommendations;
  final AnalysisMetadata analysis;
  final DailyUsage dailyUsage;

  StyleAnalysis({
    required this.analysisId,
    required this.styleDescription,
    required this.recommendations,
    required this.analysis,
    required this.dailyUsage,
  });

  @override
  List<Object?> get props => [
    analysisId,
    styleDescription,
    recommendations,
    analysis,
    dailyUsage,
  ];
}

class StyleDescription extends Entity {
  final String nombreEstilo;
  final String descripcionDetallada;
  final String cronogramaMantenimiento;
  final AdecuadoPara adecuadoPara;

  StyleDescription({
    required this.nombreEstilo,
    required this.descripcionDetallada,
    required this.cronogramaMantenimiento,
    required this.adecuadoPara,
  });

  @override
  List<Object?> get props => [
    nombreEstilo,
    descripcionDetallada,
    cronogramaMantenimiento,
    adecuadoPara,
  ];
}

class AdecuadoPara extends Entity {
  final List<String> formasRostro;
  final List<String> tiposCabello;
  final List<String> gruposEdad;

  AdecuadoPara({
    required this.formasRostro,
    required this.tiposCabello,
    required this.gruposEdad,
  });

  @override
  List<Object?> get props => [formasRostro, tiposCabello, gruposEdad];
}

class StyleRecommendation extends Entity {
  final String nombreEstilo;
  final String descripcion;
  final int puntuacionAdecuacion;
  final String dificultad;
  final String nivelMantenimiento;

  StyleRecommendation({
    required this.nombreEstilo,
    required this.descripcion,
    required this.puntuacionAdecuacion,
    required this.dificultad,
    required this.nivelMantenimiento,
  });

  @override
  List<Object?> get props => [
    nombreEstilo,
    descripcion,
    puntuacionAdecuacion,
    dificultad,
    nivelMantenimiento,
  ];
}

class AnalysisMetadata extends Entity {
  final int confidence;
  final int processingTime;
  final String llmModel;

  AnalysisMetadata({
    required this.confidence,
    required this.processingTime,
    required this.llmModel,
  });

  @override
  List<Object?> get props => [confidence, processingTime, llmModel];
}

class DailyUsage extends Entity {
  final int usedToday;
  final int remainingToday;
  final DateTime resetTime;

  DailyUsage({
    required this.usedToday,
    required this.remainingToday,
    required this.resetTime,
  });

  @override
  List<Object?> get props => [usedToday, remainingToday, resetTime];
}
