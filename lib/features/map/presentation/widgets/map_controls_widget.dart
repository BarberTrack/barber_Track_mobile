import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapControlsWidget extends StatelessWidget {
  final MapController mapController;
  final LatLng initialCenter;
  final VoidCallback onClearCustomMarkers;
  final int customMarkersCount;
  final int businessMarkersCount;
  final bool isMapReady;

  const MapControlsWidget({
    super.key,
    required this.mapController,
    required this.initialCenter,
    required this.onClearCustomMarkers,
    required this.customMarkersCount,
    required this.businessMarkersCount,
    required this.isMapReady,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      top: 100,
      child: Column(
        children: [
          // Zoom In
          _buildControlButton(
            heroTag: "zoom_in",
            icon: Icons.zoom_in_rounded,
            onPressed: () => _zoomIn(context),
            tooltip: 'Acercar',
          ),
          const SizedBox(height: 8),

          // Zoom Out
          _buildControlButton(
            heroTag: "zoom_out",
            icon: Icons.zoom_out_rounded,
            onPressed: () => _zoomOut(context),
            tooltip: 'Alejar',
          ),
          const SizedBox(height: 8),

          // Centrar en ubicación inicial
          _buildControlButton(
            heroTag: "center_location",
            icon: Icons.my_location_rounded,
            onPressed: () => _centerLocation(context),
            tooltip: 'Centrar mapa',
          ),
          const SizedBox(height: 8),

          // Limpiar marcadores personalizados (solo si hay marcadores personalizados)
          if (customMarkersCount > 0)
            _buildControlButton(
              heroTag: "clear_markers",
              icon: Icons.clear_all_rounded,
              onPressed: () => _clearCustomMarkers(context),
              tooltip: 'Limpiar marcadores',
              backgroundColor: Colors.orange,
            ),

          // Información de marcadores
          if (businessMarkersCount > 0 || customMarkersCount > 0) ...[
            const SizedBox(height: 16),
            _buildInfoCard(context),
          ],
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required String heroTag,
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
    Color? backgroundColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: FloatingActionButton(
        heroTag: heroTag,
        onPressed: onPressed,
        tooltip: tooltip,
        mini: true,
        backgroundColor: backgroundColor ?? Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: backgroundColor != null
                  ? [backgroundColor, backgroundColor.withOpacity(0.8)]
                  : [Colors.blueAccent, Colors.blueAccent.withOpacity(0.8)],
            ),
          ),
          child: Icon(icon, size: 20),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (businessMarkersCount > 0) ...[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '$businessMarkersCount Barberías',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ],
          if (customMarkersCount > 0) ...[
            if (businessMarkersCount > 0) const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '$customMarkersCount Personalizado${customMarkersCount > 1 ? 's' : ''}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _zoomIn(BuildContext context) {
    if (!isMapReady) {
      _showErrorSnackBar(context, 'El mapa aún se está cargando...');
      return;
    }

    try {
      final currentZoom = mapController.camera.zoom;
      final newZoom = (currentZoom + 1).clamp(5.0, 18.0);
      mapController.move(mapController.camera.center, newZoom);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Zoom: ${newZoom.toStringAsFixed(1)}'),
          duration: const Duration(milliseconds: 800),
          backgroundColor: Colors.blueAccent,
        ),
      );
    } catch (e) {
      _showErrorSnackBar(context, 'Error al hacer zoom');
    }
  }

  void _zoomOut(BuildContext context) {
    if (!isMapReady) {
      _showErrorSnackBar(context, 'El mapa aún se está cargando...');
      return;
    }

    try {
      final currentZoom = mapController.camera.zoom;
      final newZoom = (currentZoom - 1).clamp(5.0, 18.0);
      mapController.move(mapController.camera.center, newZoom);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Zoom: ${newZoom.toStringAsFixed(1)}'),
          duration: const Duration(milliseconds: 800),
          backgroundColor: Colors.blueAccent,
        ),
      );
    } catch (e) {
      _showErrorSnackBar(context, 'Error al hacer zoom');
    }
  }

  void _centerLocation(BuildContext context) {
    if (!isMapReady) {
      _showErrorSnackBar(context, 'El mapa aún se está cargando...');
      return;
    }

    try {
      mapController.move(initialCenter, 13.0);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mapa centrado en Tuxtla Gutiérrez'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      _showErrorSnackBar(context, 'Error al centrar el mapa');
    }
  }

  void _clearCustomMarkers(BuildContext context) {
    try {
      onClearCustomMarkers();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Marcadores personalizados eliminados'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      _showErrorSnackBar(context, 'Error al limpiar marcadores');
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

/// Widget de información flotante sobre el estado del mapa
class MapInfoWidget extends StatelessWidget {
  final int totalBusinesses;
  final int businessesWithCoordinates;
  final double? currentZoom;
  final LatLng? currentCenter;

  const MapInfoWidget({
    super.key,
    required this.totalBusinesses,
    required this.businessesWithCoordinates,
    this.currentZoom,
    this.currentCenter,
  });

  @override
  Widget build(BuildContext context) {
    final businessesWithoutCoordinates =
        totalBusinesses - businessesWithCoordinates;

    return Positioned(
      left: 16,
      bottom: 100,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Información del Mapa',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 8),

            if (businessesWithCoordinates > 0)
              _buildInfoRow(
                context,
                '✅ Con coordenadas',
                '$businessesWithCoordinates negocios',
                Colors.green,
              ),

            if (businessesWithoutCoordinates > 0)
              _buildInfoRow(
                context,
                '⚠️ Sin coordenadas',
                '$businessesWithoutCoordinates negocios',
                Colors.orange,
              ),

            if (currentZoom != null) ...[
              const SizedBox(height: 4),
              _buildInfoRow(
                context,
                '🔍 Zoom actual',
                currentZoom!.toStringAsFixed(1),
                Colors.blueAccent,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
