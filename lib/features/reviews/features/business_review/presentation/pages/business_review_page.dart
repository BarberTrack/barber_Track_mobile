import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/di/injection.dart';
import '../bloc/business_review_bloc.dart';
import '../widgets/review_card.dart';
import '../widgets/review_status_filter.dart';

class BusinessReviewPage extends StatefulWidget {
  final String businessId;

  const BusinessReviewPage({Key? key, required this.businessId})
    : super(key: key);

  @override
  State<BusinessReviewPage> createState() => _BusinessReviewPageState();
}

class _BusinessReviewPageState extends State<BusinessReviewPage> {
  String? selectedStatus;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<BusinessReviewBloc>()..add(LoadBusinessReviews(widget.businessId)),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: const Text('Reseñas del Negocio'),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            body: Column(
              children: [
                // Filter Widget
                ReviewStatusFilter(
                  selectedStatus: selectedStatus,
                  onStatusChanged: (status) {
                    setState(() {
                      selectedStatus = status;
                    });
                    context.read<BusinessReviewBloc>().add(
                      FilterBusinessReviews(widget.businessId, status),
                    );
                  },
                ),

                // Content
                Expanded(
                  child: BlocBuilder<BusinessReviewBloc, BusinessReviewState>(
                    builder: (context, state) {
                      if (state is BusinessReviewLoading) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: Colors.blue),
                              const SizedBox(height: 16),
                              Text(
                                'Cargando reseñas...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      if (state is BusinessReviewError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Error',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                ),
                                child: Text(
                                  state.message,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: () {
                                  context.read<BusinessReviewBloc>().add(
                                    LoadBusinessReviews(
                                      widget.businessId,
                                      status: selectedStatus,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.refresh),
                                label: const Text('Reintentar'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      if (state is BusinessReviewLoaded) {
                        final reviewResponse = state.reviewResponse;

                        if (reviewResponse.reviews.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.rate_review_outlined,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _getEmptyStateTitle(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _getEmptyStateMessage(),
                                  style: TextStyle(color: Colors.grey[400]),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: () async {
                            context.read<BusinessReviewBloc>().add(
                              RefreshBusinessReviews(
                                widget.businessId,
                                status: selectedStatus,
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              // Header with rating info
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                color: Colors.blue,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          reviewResponse.averageRating
                                              .toStringAsFixed(1),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${reviewResponse.totalReviews} reseña${reviewResponse.totalReviews != 1 ? 's' : ''} ${_getFilterLabel()}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ),

                              // Reviews list
                              Expanded(
                                child: ListView.builder(
                                  itemCount: reviewResponse.reviews.length,
                                  itemBuilder: (context, index) {
                                    final review =
                                        reviewResponse.reviews[index];
                                    return ReviewCard(review: review);
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getEmptyStateTitle() {
    switch (selectedStatus) {
      case 'approved':
        return 'Sin reseñas aprobadas';
      case 'pending':
        return 'Sin reseñas pendientes';
      default:
        return 'Sin reseñas';
    }
  }

  String _getEmptyStateMessage() {
    switch (selectedStatus) {
      case 'approved':
        return 'Este negocio no tiene reseñas aprobadas aún.';
      case 'pending':
        return 'Este negocio no tiene reseñas pendientes de moderación.';
      default:
        return 'Este negocio aún no tiene reseñas.';
    }
  }

  String _getFilterLabel() {
    switch (selectedStatus) {
      case 'approved':
        return '(aprobadas)';
      case 'pending':
        return '(pendientes)';
      default:
        return '';
    }
  }
}
