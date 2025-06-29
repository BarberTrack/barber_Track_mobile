import 'package:flutter/material.dart';
import '../../domain/entities/face_analysis.dart';

class AnalysisResultsWidget extends StatelessWidget {
  final FaceAnalysis faceAnalysis;

  const AnalysisResultsWidget({super.key, required this.faceAnalysis});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildDailyUsageCard(context),
          const SizedBox(height: 24),
          _buildAnalysisInfoCard(context),
          const SizedBox(height: 24),
          _buildVisagismoCard(context),
          const SizedBox(height: 24),
          _buildRecommendationsCard(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '¡Análisis Completado!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Forma de rostro: ${faceAnalysis.visagismo.formaRostro.toUpperCase()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyUsageCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black.withOpacity(0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Uso Diario',
                  style: TextStyle(color: Colors.grey[300], fontSize: 14),
                ),
                Text(
                  '${faceAnalysis.dailyUsage.usedToday}/${faceAnalysis.dailyUsage.usedToday + faceAnalysis.dailyUsage.remainingToday}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Restantes',
                  style: TextStyle(color: Colors.grey[300], fontSize: 14),
                ),
                Text(
                  '${faceAnalysis.dailyUsage.remainingToday}',
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
    );
  }

  Widget _buildAnalysisInfoCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black.withOpacity(0.3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Información del Análisis',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem(
                  'Confianza',
                  '${faceAnalysis.analysisInfo.confidence}%',
                ),
                _buildInfoItem(
                  'Tiempo',
                  '${(faceAnalysis.analysisInfo.processingTime / 1000).toStringAsFixed(1)}s',
                ),
                _buildInfoItem(
                  'Modelo',
                  faceAnalysis.analysisInfo.llmModel.toUpperCase(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildVisagismoCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black.withOpacity(0.3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.face, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Análisis de Rostro',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Face shape
            _buildVisagismoItem(
              'Forma del Rostro',
              faceAnalysis.visagismo.formaRostro.toUpperCase(),
              Icons.face,
              Colors.orange,
            ),
            const SizedBox(height: 16),

            // Facial harmony
            Text(
              'Armonía Facial',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildHarmonyItem(
                  'Proporción Áurea',
                  faceAnalysis.visagismo.armoniaFacial.proporcionAurea
                      .toStringAsFixed(3),
                ),
                _buildHarmonyItem(
                  'Simetría',
                  '${faceAnalysis.visagismo.armoniaFacial.puntuacionSimetria}%',
                ),
                _buildHarmonyItem(
                  'Equilibrio',
                  '${faceAnalysis.visagismo.armoniaFacial.indiceEquilibrio}%',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Frontal analysis
            Text(
              'Análisis Frontal',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 8),
            _buildAnalysisRow(
              'Ancho Frente',
              faceAnalysis
                  .visagismo
                  .proporcionesFaciales
                  .analisisFrontal
                  .anchoFrente,
            ),
            _buildAnalysisRow(
              'Largo Rostro',
              faceAnalysis
                  .visagismo
                  .proporcionesFaciales
                  .analisisFrontal
                  .largoRostro,
            ),
            _buildAnalysisRow(
              'Ancho Pómulos',
              faceAnalysis
                  .visagismo
                  .proporcionesFaciales
                  .analisisFrontal
                  .anchoPomulos,
            ),
            _buildAnalysisRow(
              'Ancho Mandíbula',
              faceAnalysis
                  .visagismo
                  .proporcionesFaciales
                  .analisisFrontal
                  .anchoMandibula,
            ),
            const SizedBox(height: 16),

            // Profile analysis
            Text(
              'Análisis de Perfil',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 8),
            _buildAnalysisRow(
              'Perfil Nariz',
              faceAnalysis
                  .visagismo
                  .proporcionesFaciales
                  .analisisPerfil
                  .perfilNariz,
            ),
            _buildAnalysisRow(
              'Proyección Mentón',
              faceAnalysis
                  .visagismo
                  .proporcionesFaciales
                  .analisisPerfil
                  .proyeccionMenton,
            ),
            _buildAnalysisRow(
              'Inclinación Frente',
              faceAnalysis
                  .visagismo
                  .proporcionesFaciales
                  .analisisPerfil
                  .inclinacionFrente,
            ),
            _buildAnalysisRow(
              'Definición Mandíbula',
              faceAnalysis
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

  Widget _buildVisagismoItem(
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
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
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

  Widget _buildHarmonyItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 11)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildAnalysisRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 22, 22, 22),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black.withOpacity(0.3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.content_cut, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Estilos Recomendados',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...faceAnalysis.recommendations.map(
              (style) => _buildStyleCard(style),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyleCard(StyleRecommendation style) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[600]!),
        borderRadius: BorderRadius.circular(8),
        color: Colors.black.withOpacity(0.2),
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getScoreColor(
                    style.puntuacionAdecuacion,
                  ).withOpacity(0.2),
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
            style: TextStyle(color: Colors.grey[300], fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            style.razonamientoVisagismo,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
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
        color: color.withOpacity(0.2),
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
