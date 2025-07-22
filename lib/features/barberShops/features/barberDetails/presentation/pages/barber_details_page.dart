import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/di/injection.dart';
import '../bloc/barberdetails_bloc.dart';
import '../../../../../appointments/features/create_appointment/presentation/pages/create_appointment_page.dart';
import '../widgets/hero_section_widget.dart';
//import '../widgets/quick_actions_widget.dart';
import '../widgets/info_grid_widget.dart';
import '../widgets/schedule_timeline_widget.dart';
import '../widgets/action_buttons_section.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../../../../../favorites/presentation/bloc/favorites_bloc.dart';
import '../../../../../favorites/presentation/bloc/favorites_event.dart';
import '../../../../../favorites/presentation/bloc/favorites_state.dart';
import '../../../../../favorites/domain/entities/favorite.dart';
import '../../../../../../core/storage/favorites_storage.dart';

class BarberDetailsPage extends StatefulWidget {
  final String businessId;

  const BarberDetailsPage({super.key, required this.businessId});

  @override
  State<BarberDetailsPage> createState() => _BarberDetailsPageState();
}

class _BarberDetailsPageState extends State<BarberDetailsPage> {
  late FavoritesStorage _favoritesStorage;
  List<Favorite> _currentFavorites = [];
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _favoritesStorage = sl<FavoritesStorage>();
    _initializeFavoriteStatus();
    // Cargar favoritos de manera segura
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _safeAddFavoriteEvent(const LoadFavorites());
      }
    });
  }

  // NO cerrar el bloc singleton
  @override
  void dispose() {
    super.dispose();
  }

  // Inicializar estado de favorito desde storage local
  Future<void> _initializeFavoriteStatus() async {
    final isFavorite = await _favoritesStorage.isFavorite(widget.businessId);
    if (mounted) {
      setState(() {
        _isFavorite = isFavorite;
      });
    }
  }

  // Función helper para agregar eventos de manera segura al FavoritesBloc
  void _safeAddFavoriteEvent(FavoritesEvent event) {
    if (mounted) {
      try {
        final favoritesBloc = context.read<FavoritesBloc>();
        if (!favoritesBloc.isClosed) {
          favoritesBloc.add(event);
        }
      } catch (e) {
        debugPrint('Error adding favorite event: $e');
      }
    }
  }

  void _checkIfFavorite() {
    setState(() {
      _isFavorite = _currentFavorites.any(
        (favorite) => favorite.businessId == widget.businessId,
      );
    });
  }

  // Helper para validar si hay imágenes válidas
  bool _hasValidGalleryImages(dynamic galleryImages) {
    if (galleryImages == null) return false;
    if (galleryImages is! List) return false;

    List<dynamic> images = galleryImages as List;
    return images.any((img) {
      if (img == null) return false;
      String imageStr = img.toString().trim();
      return imageStr.isNotEmpty;
    });
  }

  // Helper para obtener lista limpia de imágenes
  List<String> _getValidGalleryImages(dynamic galleryImages) {
    if (galleryImages == null) return [];
    if (galleryImages is! List) return [];

    List<dynamic> images = galleryImages as List;
    return images
        .where((img) => img != null && img.toString().trim().isNotEmpty)
        .map((img) => img.toString().trim())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<BarberdetailsBloc>()..add(LoadBusinessDetails(widget.businessId)),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocBuilder<BarberdetailsBloc, BarberdetailsState>(
          builder: (context, state) {
            if (state is BarberdetailsLoading) {
              return const LoadingWidget();
            } else if (state is BarberdetailsLoaded) {
              return _buildBusinessDetails(context, state.business);
            } else if (state is BarberdetailsError) {
              return ErrorDisplayWidget(
                message: state.message,
                onRetry: () {
                  context.read<BarberdetailsBloc>().add(
                    LoadBusinessDetails(widget.businessId),
                  );
                },
              );
            }
            return _buildInitialState();
          },
        ),
        floatingActionButton: _buildFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildBusinessDetails(BuildContext context, dynamic business) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, const Color(0xFF121212)],
        ),
      ),
      child: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: 100,
            floating: true,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blueAccent.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            title: Text(
              "Detalles de Barbería",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            centerTitle: true,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade900.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.blueAccent.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 8),

                // Hero Section - Información principal destacada
                HeroSectionWidget(business: business),

                const SizedBox(height: 24),

                // Business Card con funcionalidad de favoritos
                _buildFavoritesSection(context, business),

                const SizedBox(height: 24),

                // Botón de galería como sección destacada
                if (_hasValidGalleryImages(business.galleryImages))
                  _buildGallerySection(
                    context,
                    _getValidGalleryImages(business.galleryImages),
                  ),

                const SizedBox(height: 24),

                // Action Buttons - Reviews y Ver barberos (después de galería)
                ActionButtonsSection(businessId: widget.businessId),

                const SizedBox(height: 32),

                // Info Grid - Información de contacto compacta
                InfoGridWidget(business: business),

                const SizedBox(height: 32),

                // Schedule Timeline - Horarios en formato timeline
                ScheduleTimelineWidget(businessHours: business.businessHours),

                const SizedBox(height: 120), // Espacio para FAB
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesSection(BuildContext context, dynamic business) {
    return BlocListener<FavoritesBloc, FavoritesState>(
      listener: (context, state) {
        if (state is FavoritesLoaded) {
          _currentFavorites = state.favorites;
          _checkIfFavorite();
        } else if (state is AddToFavoritesSuccess) {
          // Actualizar inmediatamente desde storage local
          _initializeFavoriteStatus();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Negocio agregado a favoritos exitosamente'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is AddToFavoritesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message.contains('Espera y vuelve a intentarlo')
                    ? 'Espera y vuelve a intentarlo'
                    : 'Error al agregar a favoritos',
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (state is RemoveFromFavoritesSuccess) {
          // Actualizar inmediatamente desde storage local
          _initializeFavoriteStatus();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Negocio eliminado de favoritos exitosamente'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is RemoveFromFavoritesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message.contains('Espera y vuelve a intentarlo')
                    ? 'Espera y vuelve a intentarlo'
                    : 'Error al quitar de favoritos',
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: _buildFavoriteButton(context, business),
    );
  }

  Widget _buildFavoriteButton(BuildContext context, dynamic business) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        final isLoading =
            state is AddingToFavorites || state is RemovingFromFavorites;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: (_isFavorite ? Colors.grey : Colors.red).withOpacity(
                  0.3,
                ),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: isLoading
                ? null
                : () {
                    if (_isFavorite) {
                      // Quitar de favoritos
                      _safeAddFavoriteEvent(
                        RemoveFavoriteEvent(business.id ?? ''),
                      );
                    } else {
                      // Agregar a favoritos
                      _safeAddFavoriteEvent(
                        AddFavoriteEvent(business.id ?? ''),
                      );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: _isFavorite
                  ? Colors.grey.shade600
                  : Colors.red.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
            ),
            icon: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 20,
                    ),
                  ),
            label: Text(
              isLoading
                  ? 'Procesando...'
                  : _isFavorite
                  ? 'Quitar de Favoritos'
                  : 'Agregar a Favoritos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGallerySection(
    BuildContext context,
    List<String> galleryImages,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.withOpacity(0.1),
            Colors.blue.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.purple.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.photo_library_rounded,
              color: Colors.purple.shade300,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Galería de Fotos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${galleryImages.length} foto${galleryImages.length > 1 ? 's' : ''} disponible${galleryImages.length > 1 ? 's' : ''}',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.purple.shade600,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () => _showGalleryModal(context, galleryImages),
              icon: Icon(Icons.arrow_forward_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showGalleryModal(BuildContext context, List<String> galleryImages) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.95),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                // Header del modal
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900.withOpacity(0.8),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.photo_library_rounded,
                        color: Colors.purple.shade300,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Galería de Fotos',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Galería de imágenes
                Expanded(child: _buildImageGallery(galleryImages)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageGallery(List<String> galleryImages) {
    return PageView.builder(
      itemCount: galleryImages.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Contador de imágenes
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${index + 1} de ${galleryImages.length}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Imagen
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      galleryImages[index],
                      fit: BoxFit.contain,
                      width: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: Colors.purple.shade300,
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Cargando imagen...',
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported_rounded,
                                  color: Colors.grey.shade600,
                                  size: 48,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Error al cargar imagen',
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return BlocBuilder<BarberdetailsBloc, BarberdetailsState>(
      builder: (context, state) {
        if (state is BarberdetailsLoaded) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CreateAppointmentPage(businessId: widget.businessId),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              icon: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.calendar_today_rounded, size: 24),
              ),
              label: Text(
                'Agendar Cita Ahora',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey.shade900, Colors.grey.shade800],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.blueAccent.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.store_rounded, size: 64, color: Colors.blueAccent),
            const SizedBox(height: 16),
            Text(
              'Preparando información...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
