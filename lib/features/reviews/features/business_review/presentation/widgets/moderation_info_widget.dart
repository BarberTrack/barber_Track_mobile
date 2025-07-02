import 'package:flutter/material.dart';
import '../../domain/entities/moderation_logs.dart';

class ModerationInfoWidget extends StatelessWidget {
  final ModerationLogs moderationLogs;

  const ModerationInfoWidget({Key? key, required this.moderationLogs})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (moderationLogs.moderation == null) {
      return const SizedBox.shrink();
    }

    final moderation = moderationLogs.moderation!;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getActionColor(moderation.action).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getActionColor(moderation.action).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getActionIcon(moderation.action),
            color: _getActionColor(moderation.action),
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getActionText(moderation.action),
                  style: TextStyle(
                    color: _getActionColor(moderation.action),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (moderation.reason.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    moderation.reason,
                    style: TextStyle(color: Colors.grey[600], fontSize: 11),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getActionColor(String action) {
    switch (action.toLowerCase()) {
      case 'approve':
      case 'approved':
        return Colors.green;
      case 'reject':
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  IconData _getActionIcon(String action) {
    switch (action.toLowerCase()) {
      case 'approve':
      case 'approved':
        return Icons.check_circle;
      case 'reject':
      case 'rejected':
        return Icons.cancel;
      case 'pending':
        return Icons.pending;
      default:
        return Icons.info;
    }
  }

  String _getActionText(String action) {
    switch (action.toLowerCase()) {
      case 'approve':
      case 'approved':
        return 'Reseña aprobada';
      case 'reject':
      case 'rejected':
        return 'Reseña rechazada';
      case 'pending':
        return 'Pendiente de moderación';
      default:
        return 'Moderación: $action';
    }
  }
}
