import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/map_business_filters.dart';
import '../bloc/map_bloc.dart';
import '../bloc/map_event.dart';
import '../bloc/map_state.dart';
import '../widgets/interactive_map_widget.dart';
import '../widgets/map_filters_dialog.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapBusinessFilters _currentFilters = const MapBusinessFilters();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            context.pushReplacementNamed('home');
          },
          icon: const Icon(Icons.home_rounded, color: Colors.white, size: 28),
          tooltip: 'Regresar al Inicio',
        ),
        title: const Text(
          'Mapa de Barberías',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showFiltersDialog,
            icon: const Icon(
              Icons.filter_list_rounded,
              color: Colors.white,
              size: 24,
            ),
            tooltip: 'Filtros',
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blueAccent, Colors.blueAccent.withOpacity(0.8)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
      body: BlocListener<MapBloc, MapState>(
        listener: (context, state) {
          if (state is MapLoadedWithFilters) {
            setState(() {
              _currentFilters = state.filters;
            });
          }
        },
        child: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            if (state is MapLoading) {
              return _buildLoadingState();
            }

            if (state is MapError) {
              return _buildErrorState(context, state.message);
            }

            if (state is MapLoaded) {
              return _buildLoadedState(context, state);
            }

            if (state is MapLoadedWithFilters) {
              return _buildLoadedStateWithFilters(context, state);
            }

            return _buildInitialState();
          },
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // FAB secundario para limpiar filtros (solo visible cuando hay filtros activos)
        if (_currentFilters.hasActiveFilters)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: FloatingActionButton(
              heroTag: 'clear_filters',
              onPressed: _clearFilters,
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              child: const Icon(Icons.clear_all_rounded),
              tooltip: 'Limpiar filtros',
            ),
          ),
        // FAB principal para filtros
        FloatingActionButton(
          heroTag: 'filters',
          onPressed: _showFiltersDialog,
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          child: const Icon(Icons.filter_list_rounded),
          tooltip: 'Aplicar filtros',
        ),
      ],
    );
  }

  Widget _buildInitialState() {
    return const Center(
      child: Text(
        'Preparando mapa...',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
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
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Cargando negocios para el mapa...',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.blueAccent,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Obteniendo ubicaciones de barberías',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.red.withOpacity(0.2), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Error al cargar mapa',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.red.withOpacity(0.8),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<MapBloc>().add(const LoadMapBusinesses());
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(
                'Reintentar',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, MapLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<MapBloc>().add(const RefreshMapBusinesses());
      },
      color: Colors.blueAccent,
      backgroundColor: Theme.of(context).cardColor,
      child: InteractiveMapWidget(businesses: state.response.businesses),
    );
  }

  Widget _buildLoadedStateWithFilters(
    BuildContext context,
    MapLoadedWithFilters state,
  ) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async {
            context.read<MapBloc>().add(
              LoadMapBusinessesWithFilters(_currentFilters),
            );
          },
          color: Colors.blueAccent,
          backgroundColor: Theme.of(context).cardColor,
          child: InteractiveMapWidget(businesses: state.response.businesses),
        ),
        // Indicador flotante de filtros activos
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.filter_list_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${state.response.total} resultados con filtros',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _clearFilters,
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showFiltersDialog() {
    final mapBloc = context.read<MapBloc>();
    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: mapBloc,
        child: MapFiltersDialog(
          initialFilters: _currentFilters,
          mapBloc: mapBloc,
        ),
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _currentFilters = const MapBusinessFilters();
    });
    context.read<MapBloc>().add(const ClearMapFilters());
  }
}
