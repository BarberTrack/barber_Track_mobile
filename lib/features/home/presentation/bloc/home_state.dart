part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Business> businesses;

  const HomeLoaded(this.businesses);

  @override
  List<Object> get props => [businesses];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}

class HomeLoadedWithFilters extends HomeState {
  final List<Business> businesses;
  final BusinessFilters currentFilters;
  final int total;
  final int page;
  final int totalPages;
  final bool isLoadingMore;
  final bool hasReceivedEmptyResponse;

  const HomeLoadedWithFilters({
    required this.businesses,
    required this.currentFilters,
    required this.total,
    required this.page,
    required this.totalPages,
    this.isLoadingMore = false,
    this.hasReceivedEmptyResponse = false,
  });

  bool get hasMore => !hasReceivedEmptyResponse;

  HomeLoadedWithFilters copyWith({
    List<Business>? businesses,
    BusinessFilters? currentFilters,
    int? total,
    int? page,
    int? totalPages,
    bool? isLoadingMore,
    bool? hasReceivedEmptyResponse,
  }) {
    return HomeLoadedWithFilters(
      businesses: businesses ?? this.businesses,
      currentFilters: currentFilters ?? this.currentFilters,
      total: total ?? this.total,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReceivedEmptyResponse:
          hasReceivedEmptyResponse ?? this.hasReceivedEmptyResponse,
    );
  }

  @override
  List<Object> get props => [
    businesses,
    currentFilters,
    total,
    page,
    totalPages,
    isLoadingMore,
    hasReceivedEmptyResponse,
  ];
}
