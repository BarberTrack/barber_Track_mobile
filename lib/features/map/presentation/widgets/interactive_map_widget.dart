import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/map_business.dart';
import 'map_marker_builder.dart';

class InteractiveMapWidget extends StatefulWidget {
  final List<MapBusiness> businesses;

  const InteractiveMapWidget({super.key, required this.businesses});

  @override
  State<InteractiveMapWidget> createState() => _InteractiveMapWidgetState();
}

class _InteractiveMapWidgetState extends State<InteractiveMapWidget>
    with TickerProviderStateMixin {
  late final MapController _mapController;

  static const LatLng _initialCenter = LatLng(
    16.754618244645826,
    -93.12845107041579,
  );

  bool _isMapReady = false;

  late AnimationController _markerAnimationController;
  late Animation<double> _markerAnimation;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _isMapReady = false; 

    _markerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _markerAnimation = CurvedAnimation(
      parent: _markerAnimationController,
      curve: Curves.elasticOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _markerAnimationController.forward();
    });
  }

  @override
  void didUpdateWidget(InteractiveMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.businesses.length != widget.businesses.length) {
      setState(() {
        _isMapReady = false;
      });
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    _markerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final businessMarkers = MapMarkerBuilder.buildBusinessMarkers(
      widget.businesses,
    );
    final businessesWithCoordinates =
        MapMarkerBuilder.getBusinessesWithCoordinatesCount(widget.businesses);

    if (businessesWithCoordinates == 0) {
      return _buildNoCoordinatesView();
    }

    return AnimatedBuilder(
      animation: _markerAnimation,
      builder: (context, child) {
        return Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _initialCenter,
                initialZoom: 13.0,
                minZoom: 5.0,
                maxZoom: 18.0,
                onMapReady: () => _onMapReady(),
                backgroundColor: Colors.grey.shade100,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.barbertrack.map_app',
                  maxNativeZoom: 19,
                ),

                if (businessMarkers.isNotEmpty)
                  MarkerLayer(
                    markers: businessMarkers
                        .map((marker) => _animateMarker(marker))
                        .toList(),
                  ),

                const RichAttributionWidget(
                  alignment: AttributionAlignment.bottomLeft,
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                      onTap: null,
                    ),
                  ],
                ),
              ],
            ),

            if (!_isMapReady)
              Positioned.fill(
                child: Container(
                  color: Colors.white.withOpacity(0.8),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueAccent.withOpacity(0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.blueAccent,
                            ),
                            strokeWidth: 3,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Inicializando mapa...',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.blueAccent,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Preparando ubicaciones de barberías',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }


  Widget _buildNoCoordinatesView() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.orange.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.location_off_rounded,
                size: 64,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Sin coordenadas GPS',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Los negocios cargados no tienen coordenadas GPS disponibles.\n'
              'El mapa no puede mostrar ubicaciones sin esta información.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'Total de negocios: ${widget.businesses.length}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Con coordenadas: 0',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Marker _animateMarker(Marker originalMarker) {
    return Marker(
      point: originalMarker.point,
      width: originalMarker.width,
      height: originalMarker.height,
      child: Transform.scale(
        scale: _markerAnimation.value,
        child: originalMarker.child,
      ),
    );
  }


  void _onMapReady() {
    setState(() {
      _isMapReady = true;
    });
    debugPrint('🗺️ Mapa interactivo inicializado correctamente');
    debugPrint('📍 Coordenadas iniciales: $_initialCenter');
    debugPrint(
      '🏪 Negocios con coordenadas: ${MapMarkerBuilder.getBusinessesWithCoordinatesCount(widget.businesses)}',
    );
  }
}
