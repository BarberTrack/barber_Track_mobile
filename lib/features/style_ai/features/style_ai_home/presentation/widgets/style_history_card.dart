import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/style_history.dart';

class StyleHistoryCard extends StatelessWidget {
  final Analysis analysis;
  final VoidCallback onTap;

  const StyleHistoryCard({
    super.key,
    required this.analysis,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTypeChip(),
                  Text(
                    _formatDate(analysis.analyzedAt),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.face, color: Colors.blueAccent, size: 20),
                  const SizedBox(width: 8),
                  _buildFaceShapeChip(),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.content_cut, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  _buildTopStyleChip(),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${analysis.recommendedStyles.length} estilos recomendados',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getTypeDisplayName(),
        style: const TextStyle(
          color: Colors.blueAccent,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildFaceShapeChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        analysis.visagismo.formaRostro.toUpperCase(),
        style: const TextStyle(
          color: Colors.orange,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTopStyleChip() {
    final topStyle = analysis.recommendedStyles.isNotEmpty
        ? analysis.recommendedStyles.first
        : null;

    if (topStyle == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        topStyle.nombreEstilo,
        style: const TextStyle(
          color: Colors.green,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _getTypeDisplayName() {
    switch (analysis.analysisType) {
      case 'visagismo_facial':
        return 'Analisis facial';
      case 'style_description':
        return 'Analisis de referencia';
      default:
        return analysis.analysisType.toUpperCase();
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }
}
