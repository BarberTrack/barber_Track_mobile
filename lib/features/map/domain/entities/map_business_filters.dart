import 'package:equatable/equatable.dart';

class MapBusinessFilters extends Equatable {
  final String? search;
  final int? rating;
  final String? date;
  final String? time;

  const MapBusinessFilters({this.search, this.rating, this.date, this.time});

  // Método copyWith para manejo inmutable de filtros
  MapBusinessFilters copyWith({
    String? search,
    int? rating,
    String? date,
    String? time,
    bool clearSearch = false,
    bool clearRating = false,
    bool clearDate = false,
    bool clearTime = false,
  }) {
    return MapBusinessFilters(
      search: clearSearch ? null : (search ?? this.search),
      rating: clearRating ? null : (rating ?? this.rating),
      date: clearDate ? null : (date ?? this.date),
      time: clearTime ? null : (time ?? this.time),
    );
  }

  // Método para convertir filtros a parámetros HTTP
  Map<String, dynamic> toQueryParameters() {
    final Map<String, dynamic> params = {};

    if (search != null && search!.isNotEmpty) {
      params['search'] = search;
    }

    if (rating != null) {
      params['rating'] = rating.toString();
    }

    if (date != null && date!.isNotEmpty) {
      params['date'] = date;
    }

    if (time != null && time!.isNotEmpty) {
      params['time'] = time;
    }

    return params;
  }

  // Método para verificar si hay filtros activos
  bool get hasActiveFilters {
    return (search != null && search!.isNotEmpty) ||
        rating != null ||
        (date != null && date!.isNotEmpty) ||
        (time != null && time!.isNotEmpty);
  }

  // Método para obtener descripción de filtros activos
  String get activeFiltersDescription {
    final List<String> activeFilters = [];

    if (search != null && search!.isNotEmpty) {
      activeFilters.add('Búsqueda: "$search"');
    }

    if (rating != null) {
      activeFilters.add('Rating: $rating⭐');
    }

    if (date != null && date!.isNotEmpty) {
      activeFilters.add('Fecha: $date');
    }

    if (time != null && time!.isNotEmpty) {
      activeFilters.add('Hora: $time');
    }

    return activeFilters.join(', ');
  }

  @override
  List<Object?> get props => [search, rating, date, time];
}
