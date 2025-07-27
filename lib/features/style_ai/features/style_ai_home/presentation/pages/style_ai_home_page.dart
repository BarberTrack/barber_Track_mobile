import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/di/injection.dart';
import '../../../../../../core/router/app_router.dart';
import '../bloc/style_ai_home_bloc.dart';
import '../widgets/style_history_card.dart';
import '../widgets/style_detail_modal.dart';

class StyleAiHomePage extends StatefulWidget {
  const StyleAiHomePage({super.key});

  @override
  State<StyleAiHomePage> createState() => _StyleAiHomePageState();
}

class _StyleAiHomePageState extends State<StyleAiHomePage>
    with WidgetsBindingObserver, RouteAware {
  late StyleAiHomeBloc _bloc;
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bloc = sl<StyleAiHomeBloc>()..add(const LoadStyleHistoryEvent());
    _hasInitialized = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe to route changes only after initialization
    if (_hasInitialized) {
      final route = ModalRoute.of(context);
      if (route is PageRoute) {
        // This will be called when we return from other pages
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _bloc.add(const LoadStyleHistoryEvent());
          }
        });
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _bloc.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Reload history when app comes back to foreground (resumed from background)
    if (state == AppLifecycleState.resumed && mounted) {
      _bloc.add(const LoadStyleHistoryEvent());
    }
  }

  @override
  void didPopNext() {
    // Called when returning from another route via Navigator.pop()
    super.didPopNext();
    if (mounted) {
      _bloc.add(const LoadStyleHistoryEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blueAccent.withOpacity(0.1),
                Colors.blue.withOpacity(0.05),
              ],
            ),
          ),
          child: BlocBuilder<StyleAiHomeBloc, StyleAiHomeState>(
            builder: (context, state) {
              if (state is StyleAiHomeLoading) {
                return _buildLoadingState();
              } else if (state is StyleAiHomeSuccess) {
                return _buildSuccessState(context, state);
              } else if (state is StyleAiHomeEmpty) {
                return _buildEmptyState(context);
              } else if (state is StyleAiHomeError) {
                return _buildErrorState(context, state);
              }
              return _buildInitialState();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ),
          SizedBox(height: 16),
          Text(
            'Cargando historial de estilos...',
            style: TextStyle(color: Colors.blueAccent, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState(BuildContext context, StyleAiHomeSuccess state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<StyleAiHomeBloc>().add(const LoadStyleHistoryEvent());
      },
      child: Column(
        children: [
          // Daily Usage Info
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black.withOpacity(0.3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Uso Diario',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    Text(
                      '${state.styleHistory.dailyUsage.usedToday}/${state.styleHistory.dailyUsage.usedToday + state.styleHistory.dailyUsage.remainingToday}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Restantes',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    Text(
                      '${state.styleHistory.dailyUsage.remainingToday}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Available Analysis Section
          _buildAnalysisSection(context),

          // History List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: state.styleHistory.analyses.length,
              itemBuilder: (context, index) {
                final analysis = state.styleHistory.analyses[index];
                return StyleHistoryCard(
                  analysis: analysis,
                  onTap: () => StyleDetailModal.show(context, analysis),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      children: [
        // Available Analysis Section
        _buildAnalysisSection(context),

        // Empty State Message
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.history,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'No hay historial de estilos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Aún no has realizado ningún análisis de estilo. ¡Comienza ahora para ver recomendaciones personalizadas!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade500, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, StyleAiHomeError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red.shade400,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Error al cargar',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade600,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              state.message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, height: 1.5),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<StyleAiHomeBloc>().add(
                const LoadStyleHistoryEvent(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Icons.auto_fix_high_rounded,
              size: 80,
              color: Colors.blueAccent.shade400,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            '¡Bienvenido a Estilo IA!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent.shade700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Descubre nuevos estilos y tendencias mediante inteligencia artificial',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.withOpacity(0.8),
                height: 1.5,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisSection(BuildContext context) {
    return BlocBuilder<StyleAiHomeBloc, StyleAiHomeState>(
      builder: (context, state) {
        bool hasReachedLimit = false;
        if (state is StyleAiHomeSuccess) {
          hasReachedLimit = state.styleHistory.dailyUsage.remainingToday <= 0;
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Análisis Disponibles',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 12),

              // Tarjeta de límite alcanzado
              if (hasReachedLimit && state is StyleAiHomeSuccess) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade300, Colors.orange.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.schedule, color: Colors.white, size: 32),
                      const SizedBox(height: 8),
                      const Text(
                        'Límite de Uso Alcanzado',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Has excedido tu límite de uso diario.\nEstará disponible hasta el siguiente día.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Disponible en: ${_getTimeUntilReset(state.styleHistory.dailyUsage.resetTime)}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              Row(
                children: [
                  // Analyze Face Button
                  Expanded(
                    child: _buildAnalysisButton(
                      context: context,
                      title: 'Analizar Rostro',
                      icon: Icons.face_retouching_natural,
                      colors: [Colors.blueAccent, Colors.blue.shade700],
                      shadowColor: Colors.blueAccent,
                      isEnabled: !hasReachedLimit,
                      onTap: () => context.push(AppRouter.analyzeFace),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Analyze Reference Button
                  Expanded(
                    child: _buildAnalysisButton(
                      context: context,
                      title: 'Analizar Referencia',
                      icon: Icons.auto_awesome,
                      colors: [Colors.green, Colors.green.shade700],
                      shadowColor: Colors.green,
                      isEnabled: !hasReachedLimit,
                      onTap: () => context.push(AppRouter.analyzeReference),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnalysisButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Color> colors,
    required Color shadowColor,
    required bool isEnabled,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: isEnabled
              ? colors
              : [Colors.grey.shade400, Colors.grey.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: (isEnabled ? shadowColor : Colors.grey).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isEnabled) ...[
                  Icon(icon, color: Colors.white, size: 28),
                  const SizedBox(height: 8),
                  Flexible(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ] else ...[
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        icon,
                        color: Colors.white.withOpacity(0.3),
                        size: 28,
                      ),
                      Icon(
                        Icons.lock,
                        color: Colors.white.withOpacity(0.9),
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTimeUntilReset(DateTime resetTime) {
    final now = DateTime.now();
    final difference = resetTime.difference(now);

    if (difference.isNegative) {
      return 'Disponible ahora';
    }

    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
