import 'package:equatable/equatable.dart';

class StyleAnalysisResponseModel extends Equatable {
  final bool success;
  final StyleAnalysisDataModel data;
  final String message;

  const StyleAnalysisResponseModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory StyleAnalysisResponseModel.fromJson(Map<String, dynamic> json) {
    return StyleAnalysisResponseModel(
      success: json['success'] ?? false,
      data: StyleAnalysisDataModel.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'data': data.toJson(), 'message': message};
  }

  @override
  List<Object?> get props => [success, data, message];
}

class StyleAnalysisDataModel extends Equatable {
  final String analysisId;
  final StyleDescriptionModel styleDescription;
  final List<StyleRecommendationModel> recommendations;
  final AnalysisMetadataModel analysis;
  final DailyUsageModel dailyUsage;

  const StyleAnalysisDataModel({
    required this.analysisId,
    required this.styleDescription,
    required this.recommendations,
    required this.analysis,
    required this.dailyUsage,
  });

  factory StyleAnalysisDataModel.fromJson(Map<String, dynamic> json) {
    return StyleAnalysisDataModel(
      analysisId: json['analysisId'] ?? '',
      styleDescription: StyleDescriptionModel.fromJson(
        json['styleDescription'] ?? {},
      ),
      recommendations: (json['recommendations'] as List<dynamic>? ?? [])
          .map((item) => StyleRecommendationModel.fromJson(item))
          .toList(),
      analysis: AnalysisMetadataModel.fromJson(json['analysis'] ?? {}),
      dailyUsage: DailyUsageModel.fromJson(json['dailyUsage'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'analysisId': analysisId,
      'styleDescription': styleDescription.toJson(),
      'recommendations': recommendations.map((item) => item.toJson()).toList(),
      'analysis': analysis.toJson(),
      'dailyUsage': dailyUsage.toJson(),
    };
  }

  @override
  List<Object?> get props => [
    analysisId,
    styleDescription,
    recommendations,
    analysis,
    dailyUsage,
  ];
}

class StyleDescriptionModel extends Equatable {
  final String nombreEstilo;
  final String descripcionDetallada;
  final String cronogramaMantenimiento;
  final AdecuadoParaModel adecuadoPara;

  const StyleDescriptionModel({
    required this.nombreEstilo,
    required this.descripcionDetallada,
    required this.cronogramaMantenimiento,
    required this.adecuadoPara,
  });

  factory StyleDescriptionModel.fromJson(Map<String, dynamic> json) {
    return StyleDescriptionModel(
      nombreEstilo: json['nombreEstilo'] ?? '',
      descripcionDetallada: json['descripcionDetallada'] ?? '',
      cronogramaMantenimiento: json['cronogramaMantenimiento'] ?? '',
      adecuadoPara: AdecuadoParaModel.fromJson(json['adecuadoPara'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombreEstilo': nombreEstilo,
      'descripcionDetallada': descripcionDetallada,
      'cronogramaMantenimiento': cronogramaMantenimiento,
      'adecuadoPara': adecuadoPara.toJson(),
    };
  }

  @override
  List<Object?> get props => [
    nombreEstilo,
    descripcionDetallada,
    cronogramaMantenimiento,
    adecuadoPara,
  ];
}

class AdecuadoParaModel extends Equatable {
  final List<String> formasRostro;
  final List<String> tiposCabello;
  final List<String> gruposEdad;

  const AdecuadoParaModel({
    required this.formasRostro,
    required this.tiposCabello,
    required this.gruposEdad,
  });

  factory AdecuadoParaModel.fromJson(Map<String, dynamic> json) {
    return AdecuadoParaModel(
      formasRostro: List<String>.from(json['formasRostro'] ?? []),
      tiposCabello: List<String>.from(json['tiposCabello'] ?? []),
      gruposEdad: List<String>.from(json['gruposEdad'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'formasRostro': formasRostro,
      'tiposCabello': tiposCabello,
      'gruposEdad': gruposEdad,
    };
  }

  @override
  List<Object?> get props => [formasRostro, tiposCabello, gruposEdad];
}

class StyleRecommendationModel extends Equatable {
  final String nombreEstilo;
  final String descripcion;
  final int puntuacionAdecuacion;
  final String dificultad;
  final String nivelMantenimiento;

  const StyleRecommendationModel({
    required this.nombreEstilo,
    required this.descripcion,
    required this.puntuacionAdecuacion,
    required this.dificultad,
    required this.nivelMantenimiento,
  });

  factory StyleRecommendationModel.fromJson(Map<String, dynamic> json) {
    return StyleRecommendationModel(
      nombreEstilo: json['nombreEstilo'] ?? '',
      descripcion: json['descripcion'] ?? '',
      puntuacionAdecuacion: json['puntuacionAdecuacion'] ?? 0,
      dificultad: json['dificultad'] ?? '',
      nivelMantenimiento: json['nivelMantenimiento'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombreEstilo': nombreEstilo,
      'descripcion': descripcion,
      'puntuacionAdecuacion': puntuacionAdecuacion,
      'dificultad': dificultad,
      'nivelMantenimiento': nivelMantenimiento,
    };
  }

  @override
  List<Object?> get props => [
    nombreEstilo,
    descripcion,
    puntuacionAdecuacion,
    dificultad,
    nivelMantenimiento,
  ];
}

class AnalysisMetadataModel extends Equatable {
  final int confidence;
  final int processingTime;
  final String llmModel;

  const AnalysisMetadataModel({
    required this.confidence,
    required this.processingTime,
    required this.llmModel,
  });

  factory AnalysisMetadataModel.fromJson(Map<String, dynamic> json) {
    return AnalysisMetadataModel(
      confidence: json['confidence'] ?? 0,
      processingTime: json['processingTime'] ?? 0,
      llmModel: json['llmModel'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'confidence': confidence,
      'processingTime': processingTime,
      'llmModel': llmModel,
    };
  }

  @override
  List<Object?> get props => [confidence, processingTime, llmModel];
}

class DailyUsageModel extends Equatable {
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
      usedToday: json['usedToday'] ?? 0,
      remainingToday: json['remainingToday'] ?? 0,
      resetTime: json['resetTime'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usedToday': usedToday,
      'remainingToday': remainingToday,
      'resetTime': resetTime,
    };
  }

  @override
  List<Object?> get props => [usedToday, remainingToday, resetTime];
}
