import 'package:equatable/equatable.dart';

class BusinessFilters extends Equatable {
  final int page;
  final int limit;
  final String? search;
  final int? rating;
  final String? date; // YYYY-MM-DD
  final String? time; // HH:mm

  const BusinessFilters({
    this.page = 1,
    this.limit = 4,
    this.search,
    this.rating,
    this.date,
    this.time,
  });

  BusinessFilters copyWith({
    int? page,
    int? limit,
    String? search,
    bool clearSearch = false,
    int? rating,
    bool clearRating = false,
    String? date,
    bool clearDate = false,
    String? time,
    bool clearTime = false,
  }) {
    return BusinessFilters(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      search: clearSearch ? null : (search ?? this.search),
      rating: clearRating ? null : (rating ?? this.rating),
      date: clearDate ? null : (date ?? this.date),
      time: clearTime ? null : (time ?? this.time),
    );
  }

  
  Map<String, dynamic> toQueryParameters() {
    final Map<String, dynamic> params = {'page': page, 'limit': limit};

    if (search != null && search!.isNotEmpty) {
      params['search'] = search;
    }

    if (rating != null) {
      params['rating'] = rating;
    }

    if (date != null && date!.isNotEmpty) {
      params['date'] = date;
    }

    if (time != null && time!.isNotEmpty) {
      params['time'] = time;
    }

    return params;
  }

  @override
  List<Object?> get props => [page, limit, search, rating, date, time];
}
