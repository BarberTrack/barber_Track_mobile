import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/map_business.dart';
import '../../../../core/router/app_router.dart';

class MapMarkerBuilder {
  /// Convierte una lista de negocios en marcadores para el mapa
  static List<Marker> buildBusinessMarkers(List<MapBusiness> businesses) {
    final List<Marker> markers = [];

    for (final business in businesses) {
      // Solo crear marcadores para negocios con coordenadas válidas
      if (business.latitude != null && business.longitude != null) {
        final marker = Marker(
          point: LatLng(business.latitude!, business.longitude!),
          width: 60,
          height: 60,
          child: _BusinessMarkerWidget(business: business),
        );
        markers.add(marker);
      }
    }

    return markers;
  }

  /// Crea un marcador personalizado para ubicaciones tocadas por el usuario
  static Marker buildCustomMarker(LatLng point, String label) {
    return Marker(
      point: point,
      width: 50,
      height: 50,
      child: _CustomMarkerWidget(label: label),
    );
  }

  /// Obtiene el número de negocios con coordenadas válidas
  static int getBusinessesWithCoordinatesCount(List<MapBusiness> businesses) {
    return businesses
        .where(
          (business) => business.latitude != null && business.longitude != null,
        )
        .length;
  }

  /// Obtiene la información de un negocio por sus coordenadas
  static MapBusiness? getBusinessByCoordinates(
    List<MapBusiness> businesses,
    LatLng coordinates,
  ) {
    return businesses.firstWhere(
      (business) =>
          business.latitude == coordinates.latitude &&
          business.longitude == coordinates.longitude,
      orElse: () => throw StateError('Business not found'),
    );
  }
}

/// Widget personalizado para marcadores de negocios
class _BusinessMarkerWidget extends StatelessWidget {
  final MapBusiness business;

  const _BusinessMarkerWidget({required this.business});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showBusinessInfo(context, business),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(21),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.red.shade400, Colors.red.shade600],
            ),
          ),
          child: const Icon(Icons.cut, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  void _showBusinessInfo(BuildContext context, MapBusiness business) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con título
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.cut, color: Colors.red, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      business.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Descripción
              if (business.description.isNotEmpty) ...[
                Text(
                  business.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
              ],

              // Dirección
              Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 18,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      business.address,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Teléfono
              if (business.phone.isNotEmpty) ...[
                Row(
                  children: [
                    Icon(
                      Icons.phone_rounded,
                      size: 18,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      business.phone,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],

              // Rating y estado
              Row(
                children: [
                  Icon(
                    Icons.star_rounded,
                    size: 18,
                    color: Colors.amber.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${business.ratingAverage.toStringAsFixed(1)} (${business.totalReviews})',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: business.isActive ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      business.isActive ? 'Activo' : 'Inactivo',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Botón para navegar a detalles de la barbería
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar el modal
                    context.pushNamed(
                      'barber-details',
                      pathParameters: {'businessId': business.id},
                    );
                  },
                  icon: const Icon(Icons.store_rounded, size: 20),
                  label: const Text(
                    'Ver Detalles de la Barbería',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    shadowColor: Colors.blueAccent.withOpacity(0.3),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget personalizado para marcadores agregados por el usuario
class _CustomMarkerWidget extends StatelessWidget {
  final String label;

  const _CustomMarkerWidget({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blueAccent.shade400, Colors.blueAccent.shade700],
          ),
        ),
        child: const Icon(Icons.place, color: Colors.white, size: 24),
      ),
    );
  }
}
