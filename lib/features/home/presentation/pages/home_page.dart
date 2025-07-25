import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../bloc/home_bloc.dart';
import '../widgets/business_card.dart';
import '../widgets/business_filters_widget.dart';
import '../../domain/entities/business_filters.dart';
import '../../../appointments/features/appoinments_home/presentation/pages/appointments_page.dart';
import '../../../style_ai/features/style_ai_home/presentation/pages/style_ai_home_page.dart';
import '../../../favorites/presentation/pages/favorites_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: _buildAppBar(),
      body: Container(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              _buildHomeContent(),
              AppointmentsPage(
                onNavigateToHome: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                  _animationController.reset();
                  _animationController.forward();
                },
              ),
              const StyleAiHomePage(),
              FavoritesPage(
                onNavigateToHome: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                  _animationController.reset();
                  _animationController.forward();
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.go(AppRouter.map);
        },
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.map_rounded),
        label: const Text(
          'Ver Mapa',
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
        elevation: 6,
        tooltip: 'Abrir mapa de barberías',
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Text(
          _selectedIndex == 0
              ? 'Barber Track'
              : _selectedIndex == 1
              ? 'Mis Citas'
              : _selectedIndex == 2
              ? 'Estilo IA'
              : 'Mis Favoritos',
          key: ValueKey(_selectedIndex),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
      ),
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
      actions: [
        IconButton(
          onPressed: () {
            context.go(AppRouter.map);
          },
          icon: const Icon(Icons.map_rounded, color: Colors.white),
          tooltip: 'Ver mapa de barberías',
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(),
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_rounded),
            label: 'Citas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_fix_high_rounded),
            label: 'Estilo IA',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_rounded),
            label: 'Favoritos',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey.withOpacity(0.6),
        backgroundColor: Theme.of(
          context,
        ).bottomNavigationBarTheme.backgroundColor,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          letterSpacing: 0.5,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildHomeContent() {
    return BlocProvider(
      create: (context) =>
          sl<HomeBloc>()
            ..add(const LoadBusinessesWithFilters(BusinessFilters())),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return _buildLoadingState();
          }

          if (state is HomeError) {
            return _buildErrorState(context, state.message);
          }

          if (state is HomeLoaded) {
            if (state.businesses.isEmpty) {
              return _buildEmptyState();
            }

            return _buildLoadedState(context, state);
          }

          if (state is HomeLoadedWithFilters) {
            if (state.businesses.isEmpty) {
              return _buildEmptyStateWithFilters(context, state);
            }

            return _buildLoadedStateWithFilters(context, state);
          }

          return const SizedBox.shrink();
        },
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
            'Cargando barberías...',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.blueAccent,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Esto solo tomará un momento',
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
              'Oops! Algo salió mal',
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
                context.read<HomeBloc>().add(const LoadBusinesses());
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

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.business_rounded,
                size: 64,
                color: Colors.blueAccent.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No hay barberías disponibles',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Intenta nuevamente más tarde o verifica tu conexión',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey.withOpacity(0.7),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, HomeLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomeBloc>().add(const RefreshBusinesses());
      },
      color: Colors.blueAccent,
      backgroundColor: Theme.of(context).cardColor,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blueAccent.withOpacity(0.1),
                    Colors.blueAccent.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: Colors.blueAccent,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Barberías cerca de ti',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                                letterSpacing: 0.5,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${state.businesses.length} disponibles',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey.withOpacity(0.7)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final business = state.businesses[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: BusinessCard(business: business),
                );
              }, childCount: state.businesses.length),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildEmptyStateWithFilters(
    BuildContext context,
    HomeLoadedWithFilters state,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          BusinessFiltersWidget(
            initialFilters: state.currentFilters,
            onFiltersChanged: (filters) {
              context.read<HomeBloc>().add(LoadBusinessesWithFilters(filters));
            },
          ),
          const SizedBox(height: 20),
          Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.search_off_rounded,
                      size: 64,
                      color: Colors.blueAccent.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No se encontraron barberías',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Intenta modificar los filtros de búsqueda',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey.withOpacity(0.7),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedStateWithFilters(
    BuildContext context,
    HomeLoadedWithFilters state,
  ) {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
            state.hasMore &&
            !state.isLoadingMore) {
          context.read<HomeBloc>().add(
            LoadMoreBusinesses(state.currentFilters),
          );
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<HomeBloc>().add(
            LoadBusinessesWithFilters(state.currentFilters.copyWith(page: 1)),
          );
        },
        color: Colors.blueAccent,
        backgroundColor: Theme.of(context).cardColor,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Filtros
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(20),
                child: BusinessFiltersWidget(
                  initialFilters: state.currentFilters,
                  onFiltersChanged: (filters) {
                    context.read<HomeBloc>().add(
                      LoadBusinessesWithFilters(filters),
                    );
                  },
                ),
              ),
            ),

            // Información de resultados
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blueAccent.withOpacity(0.1),
                      Colors.blueAccent.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.store_rounded,
                        color: Colors.blueAccent,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Resultados encontrados',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                          ),
                          Text(
                            '${state.businesses.length} de ${state.total} barberías',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey.withOpacity(0.7)),
                          ),
                        ],
                      ),
                    ),
                    if (state.totalPages > 1)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Página ${state.page} de ${state.totalPages}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Lista de negocios
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final business = state.businesses[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: BusinessCard(business: business),
                  );
                }, childCount: state.businesses.length),
              ),
            ),

            // Botón "Ver más barberías"
            if (state.hasMore && !state.isLoadingMore)
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<HomeBloc>().add(
                          LoadMoreBusinesses(state.currentFilters),
                        );
                      },
                      icon: const Icon(Icons.expand_more_rounded),
                      label: const Text(
                        'Ver más barberías',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
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
                ),
              ),

            // Indicador de carga para más elementos
            if (state.isLoadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.blueAccent,
                      ),
                    ),
                  ),
                ),
              ),

            // Mensaje de fin de resultados
            if (!state.hasMore && state.businesses.isNotEmpty)
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: Colors.grey.withOpacity(0.6),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Has visto todas las barberías',
                        style: TextStyle(
                          color: Colors.grey.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}
