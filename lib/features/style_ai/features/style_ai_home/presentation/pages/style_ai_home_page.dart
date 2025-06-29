import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/di/injection.dart';
import '../bloc/style_ai_home_bloc.dart';
import '../widgets/style_history_card.dart';
import '../widgets/style_detail_modal.dart';

class StyleAiHomePage extends StatelessWidget {
  const StyleAiHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<StyleAiHomeBloc>()..add(const LoadStyleHistoryEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Historial de Estilos IA',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
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
                return _buildEmptyState();
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.history, size: 80, color: Colors.grey.shade400),
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
}
