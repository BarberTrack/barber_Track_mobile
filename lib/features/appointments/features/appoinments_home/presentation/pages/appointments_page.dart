import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/di/injection.dart' as di;
import '../../domain/entities/appointment.dart';
import '../bloc/appointments_bloc.dart';
import '../widgets/appointment_card.dart';
import '../widgets/appointment_status_filter.dart';

class AppointmentsPage extends StatelessWidget {
  final VoidCallback? onNavigateToHome;

  const AppointmentsPage({super.key, this.onNavigateToHome});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          di.sl<AppointmentsBloc>()..add(const LoadAppointments()),
      child: AppointmentsView(onNavigateToHome: onNavigateToHome),
    );
  }
}

class AppointmentsView extends StatefulWidget {
  final VoidCallback? onNavigateToHome;

  const AppointmentsView({super.key, this.onNavigateToHome});

  @override
  State<AppointmentsView> createState() => _AppointmentsViewState();
}

class _AppointmentsViewState extends State<AppointmentsView> {
  AppointmentStatus? _selectedStatus;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<AppointmentsBloc>().add(
        LoadMoreAppointments(status: _selectedStatus?.value),
      );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 200);
  }

  void _resetFilterAndRefresh() {
    setState(() {
      _selectedStatus = null;
    });
    context.read<AppointmentsBloc>().add(
      const RefreshAppointments(status: null),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<AppointmentsBloc>().add(
            RefreshAppointments(status: _selectedStatus?.value),
          );
        },
        color: Colors.blueAccent,
        backgroundColor: colorScheme.surface,
        child: BlocBuilder<AppointmentsBloc, AppointmentsState>(
          builder: (context, state) {
            if (state is AppointmentsLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.1),
                        shape: BoxShape.circle,
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
                      'Cargando tus citas...',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onBackground,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Un momento por favor',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onBackground.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is AppointmentsError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: colorScheme.errorContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.wifi_off_rounded,
                          color: colorScheme.onErrorContainer,
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        '¡Oops! Algo salió mal',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: colorScheme.onBackground,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onBackground.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<AppointmentsBloc>().add(
                            RefreshAppointments(status: _selectedStatus?.value),
                          );
                        },
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Reintentar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is AppointmentsLoaded) {
              if (state.appointments.isEmpty) {
                return _buildEmptyState(state.currentFilter);
              }

              return CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Header con estadísticas mejoradas
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Tarjeta principal de estadísticas
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blueAccent,
                                  Colors.blueAccent.withOpacity(0.8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueAccent.withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Mis Citas',
                                          style: theme.textTheme.titleLarge
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Total de citas programadas',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                color: Colors.white.withOpacity(
                                                  0.9,
                                                ),
                                              ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        '${state.total}',
                                        style: theme.textTheme.headlineLarge
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Filtro de estado
                          AppointmentStatusFilter(
                            selectedStatus: _selectedStatus,
                            onStatusChanged: (status) {
                              setState(() {
                                _selectedStatus = status;
                              });
                              context.read<AppointmentsBloc>().add(
                                FilterAppointmentsByStatus(
                                  status: status?.value,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          // Título de la lista
                          Row(
                            children: [
                              Container(
                                width: 4,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _getFilteredTitle(),
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: colorScheme.onBackground,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (state.total > 0) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${state.total}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Lista de citas con mejor separación
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: AppointmentCard(
                            appointment: state.appointments[index],
                            onAppointmentCancelled: _resetFilterAndRefresh,
                          ),
                        );
                      }, childCount: state.appointments.length),
                    ),
                  ),
                  // Loading indicator para más elementos
                  if (state.isLoadingMore)
                    SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blueAccent,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Cargando más citas...',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  // Espaciado inferior con botón flotante
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          // Botón para agendar nueva cita
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                widget.onNavigateToHome?.call();
                              },
                              icon: const Icon(Icons.add_rounded),
                              label: const Text('Agendar Nueva Cita'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.blueAccent,
                                side: BorderSide(
                                  color: Colors.blueAccent,
                                  width: 2,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  String _getFilteredTitle() {
    if (_selectedStatus == null) {
      return 'Todas las Citas';
    }

    switch (_selectedStatus!) {
      case AppointmentStatus.scheduled:
        return 'Citas Programadas';
      case AppointmentStatus.completed:
        return 'Citas Completadas';
      case AppointmentStatus.cancelled:
        return 'Citas Canceladas';
      case AppointmentStatus.noShow:
        return 'Ausencias';
    }
  }

  Widget _buildEmptyState(String? currentFilter) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Si hay un filtro aplicado, mostrar mensaje de filtro sin resultados
    if (currentFilter != null) {
      final status = AppointmentStatus.fromString(currentFilter);
      final statusDisplayName = status?.displayName ?? 'este estado';

      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.withOpacity(0.2),
                      Colors.orange.withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.orange.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.filter_list_off_rounded,
                  color: Colors.orange,
                  size: 64,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'No hay citas ${statusDisplayName.toLowerCase()}',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onBackground,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'No tienes citas con el estado "$statusDisplayName".\nPrueba con otro filtro o agenda una nueva cita.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onBackground.withOpacity(0.8),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedStatus = null;
                      });
                      context.read<AppointmentsBloc>().add(
                        const FilterAppointmentsByStatus(status: null),
                      );
                    },
                    icon: const Icon(Icons.clear_all_rounded),
                    label: const Text('Ver Todas'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange,
                      side: const BorderSide(color: Colors.orange, width: 2),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      widget.onNavigateToHome?.call();
                    },
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Agendar Cita'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    // Si no hay filtro, mostrar mensaje de agenda vacía
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blueAccent.withOpacity(0.2),
                    Colors.blueAccent.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.blueAccent.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.calendar_month_rounded,
                color: Colors.blueAccent,
                size: 64,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              '¡Tu agenda está vacía!',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onBackground,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Es el momento perfecto para agendar\ntu primera cita y lucir increíble',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onBackground.withOpacity(0.8),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: () {
                widget.onNavigateToHome?.call();
              },
              icon: const Icon(Icons.content_cut_rounded),
              label: const Text('Agendar Mi Primera Cita'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 4,
                shadowColor: Colors.blueAccent.withOpacity(0.3),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Mostrar información sobre los servicios
              },
              child: Text(
                'Ver servicios disponibles',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
