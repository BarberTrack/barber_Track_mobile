import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/style_history.dart';

class StyleDetailModal extends StatelessWidget {
  final Analysis analysis;

  const StyleDetailModal({super.key, required this.analysis});

  static void show(BuildContext context, Analysis analysis) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StyleDetailModal(analysis: analysis),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 0, 0, 0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Análisis Detallado',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const Divider(),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRecommendationsSection(context),
                  const SizedBox(height: 24),
                  _buildVisagismoSection(context),
                  const SizedBox(height: 24),
                  _buildAnalysisInfo(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisInfo(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Información del Análisis',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Fecha de análisis: ',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat('dd/MM/yyyy HH:mm').format(analysis.analyzedAt),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisagismoSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Análisis de rostro',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 16),
            _buildVisagismoItem(
              context,
              'Forma del Rostro',
              analysis.visagismo.formaRostro.toUpperCase(),
              Icons.face,
              Colors.orange,
            ),
            const SizedBox(height: 16),
            Text(
              'Análisis Frontal',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _buildAnalysisRow(
              context,
              'Ancho Frente',
              analysis
                  .visagismo
                  .proporcionesFaciales
                  .analisisFrontal
                  .anchoFrente,
            ),
            _buildAnalysisRow(
              context,
              'Largo Rostro',
              analysis
                  .visagismo
                  .proporcionesFaciales
                  .analisisFrontal
                  .largoRostro,
            ),
            _buildAnalysisRow(
              context,
              'Ancho Pómulos',
              analysis
                  .visagismo
                  .proporcionesFaciales
                  .analisisFrontal
                  .anchoPomulos,
            ),
            _buildAnalysisRow(
              context,
              'Ancho Mandíbula',
              analysis
                  .visagismo
                  .proporcionesFaciales
                  .analisisFrontal
                  .anchoMandibula,
            ),
            const SizedBox(height: 16),
            Text(
              'Análisis de Perfil',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _buildAnalysisRow(
              context,
              'Perfil Nariz',
              analysis
                  .visagismo
                  .proporcionesFaciales
                  .analisisPerfil
                  .perfilNariz,
            ),
            _buildAnalysisRow(
              context,
              'Proyección Mentón',
              analysis
                  .visagismo
                  .proporcionesFaciales
                  .analisisPerfil
                  .proyeccionMenton,
            ),
            _buildAnalysisRow(
              context,
              'Inclinación Frente',
              analysis
                  .visagismo
                  .proporcionesFaciales
                  .analisisPerfil
                  .inclinacionFrente,
            ),
            _buildAnalysisRow(
              context,
              'Definición Mandíbula',
              analysis
                  .visagismo
                  .proporcionesFaciales
                  .analisisPerfil
                  .definicionMandibula,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estilos Recomendados',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            ...analysis.recommendedStyles.map(
              (style) => _buildStyleCard(context, style),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisagismoItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                value,
                style: TextStyle(color: color, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnalysisRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 22, 22, 22),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value.toUpperCase(),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStyleCard(BuildContext context, RecommendedStyle style) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  style.nombreEstilo,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getScoreColor(
                    style.puntuacionAdecuacion,
                  ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${style.puntuacionAdecuacion}%',
                  style: TextStyle(
                    color: _getScoreColor(style.puntuacionAdecuacion),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            style.descripcion,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildStyleAttribute(
                'Dificultad',
                style.dificultad,
                _getDifficultyColor(style.dificultad),
              ),
              const SizedBox(width: 8),
              _buildStyleAttribute(
                'Mantenimiento',
                style.nivelMantenimiento,
                _getMaintenanceColor(style.nivelMantenimiento),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStyleAttribute(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$label: ${value.toUpperCase()}',
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return Colors.green;
    if (score >= 75) return Colors.orange;
    return Colors.red;
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'fácil':
        return Colors.green;
      case 'medio':
        return Colors.orange;
      case 'difícil':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getMaintenanceColor(String maintenance) {
    switch (maintenance.toLowerCase()) {
      case 'bajo':
        return Colors.green;
      case 'medio':
        return Colors.orange;
      case 'alto':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
