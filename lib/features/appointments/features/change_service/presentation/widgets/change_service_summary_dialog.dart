import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../bloc/change_service_bloc.dart';
import '../../../create_appointment/domain/entities/service.dart';
import '../../../appoinments_home/domain/entities/appointment.dart';

class ChangeServiceSummaryDialog extends StatelessWidget {
  final ChangeServiceState state;
  final String clientNotes;
  final VoidCallback onConfirm;

  const ChangeServiceSummaryDialog({
    super.key,
    required this.state,
    required this.clientNotes,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final service = _getSelectedService();
    final appointment = _getOriginalAppointment();
    final keepDateTime = _getKeepDateTime();

    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.swap_horiz_rounded, color: Colors.blueAccent),
          SizedBox(width: 8),
          Text('Confirmar cambio de servicio'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumen del cambio:',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Cambio de servicio
            _buildChangeSection(
              context,
              title: 'Servicio',
              fromValue: appointment.service.name,
              toValue: service.name,
              icon: Icons.content_cut_rounded,
              color: Colors.blue,
            ),
            const SizedBox(height: 12),

            // Cambio de precio
            _buildChangeSection(
              context,
              title: 'Precio',
              fromValue: '\$${appointment.totalPrice}',
              toValue: '\$${service.price}',
              icon: Icons.attach_money_rounded,
              color: Colors.green,
            ),
            const SizedBox(height: 12),

            // Cambio de duración
            _buildChangeSection(
              context,
              title: 'Duración',
              fromValue: '${appointment.durationMinutes} min',
              toValue: '${service.durationMinutes} min',
              icon: Icons.schedule_rounded,
              color: Colors.blueAccent,
            ),

            // Información de fecha y hora
            if (keepDateTime) ...[
              const SizedBox(height: 12),
              _buildInfoSection(
                context,
                title: 'Fecha y hora',
                value: _formatDateTime(
                  appointment.scheduledDatetime,
                  isFromServer: true,
                ),
                subtitle: 'Se mantiene la fecha y hora original',
                icon: Icons.event_rounded,
                color: Colors.purple,
              ),
            ] else ...[
              const SizedBox(height: 12),
              _buildChangeSection(
                context,
                title: 'Fecha y hora',
                fromValue: _formatDateTime(
                  appointment.scheduledDatetime,
                  isFromServer: true,
                ),
                toValue: _getNewDateTime(),
                icon: Icons.event_rounded,
                color: Colors.purple,
              ),
            ],

            // Notas del cliente
            if (clientNotes.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildInfoSection(
                context,
                title: 'Notas especiales',
                value: clientNotes,
                icon: Icons.note_rounded,
                color: Colors.teal,
              ),
            ],

            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.amber.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Una vez confirmado, el cambio no se puede deshacer.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.amber.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
          ),
          onPressed: onConfirm,
          child: const Text('Confirmar cambio'),
        ),
      ],
    );
  }

  Widget _buildChangeSection(
    BuildContext context, {
    required String title,
    required String fromValue,
    required String toValue,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Actual:',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      fromValue,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_rounded,
                size: 16,
                color: Colors.grey.shade400,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nuevo:',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      toValue,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context, {
    required String title,
    required String value,
    String? subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Service _getSelectedService() {
    if (state is ChangeServiceServiceSelected)
      return (state as ChangeServiceServiceSelected).selectedService;
    if (state is ChangeServiceDateTimeOptionSelected)
      return (state as ChangeServiceDateTimeOptionSelected).selectedService;
    if (state is ChangeServiceTimeSlotSelected)
      return (state as ChangeServiceTimeSlotSelected).selectedService;
    if (state is ChangeServiceWithNotes)
      return (state as ChangeServiceWithNotes).selectedService;
    throw Exception('Service not found in state');
  }

  Appointment _getOriginalAppointment() {
    if (state is ChangeServiceServiceSelected)
      return (state as ChangeServiceServiceSelected).originalAppointment;
    if (state is ChangeServiceDateTimeOptionSelected)
      return (state as ChangeServiceDateTimeOptionSelected).originalAppointment;
    if (state is ChangeServiceTimeSlotSelected)
      return (state as ChangeServiceTimeSlotSelected).originalAppointment;
    if (state is ChangeServiceWithNotes)
      return (state as ChangeServiceWithNotes).originalAppointment;
    throw Exception('Appointment not found in state');
  }

  bool _getKeepDateTime() {
    if (state is ChangeServiceDateTimeOptionSelected)
      return (state as ChangeServiceDateTimeOptionSelected).keepDateTime;
    if (state is ChangeServiceWithNotes)
      return (state as ChangeServiceWithNotes).keepDateTime;
    return false;
  }

  String _getNewDateTime() {
    if (state is ChangeServiceTimeSlotSelected) {
      final timeSlotState = state as ChangeServiceTimeSlotSelected;
      final date = timeSlotState.selectedDate;
      final timeSlot = timeSlotState.selectedTimeSlot;
      final timeParts = timeSlot.time.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      final dateTime = DateTime(date.year, date.month, date.day, hour, minute);
      return _formatDateTime(dateTime, isFromServer: false);
    }
    if (state is ChangeServiceWithNotes) {
      final notesState = state as ChangeServiceWithNotes;
      if (!notesState.keepDateTime &&
          notesState.selectedDate != null &&
          notesState.selectedTimeSlot != null) {
        final date = notesState.selectedDate!;
        final timeSlot = notesState.selectedTimeSlot!;
        final timeParts = timeSlot.time.split(':');
        final hour = int.parse(timeParts[0]);
        final minute = int.parse(timeParts[1]);
        final dateTime = DateTime(
          date.year,
          date.month,
          date.day,
          hour,
          minute,
        );
        return _formatDateTime(dateTime, isFromServer: false);
      }
    }
    return 'No definida';
  }

  String _formatDateTime(DateTime dateTime, {bool isFromServer = false}) {
    DateTime mexicoDateTime;

    if (isFromServer) {
      // Fecha que viene del servidor en UTC, convertir a México (UTC-6)
      mexicoDateTime = dateTime.toUtc().subtract(const Duration(hours: 6));
    } else {
      // Fecha ya está en hora local de México, usar directamente
      mexicoDateTime = dateTime;
    }

    final now = DateTime.now();
    final difference = mexicoDateTime.difference(now);

    String date = DateFormat('dd/MM/yyyy').format(mexicoDateTime);
    String time = DateFormat('HH:mm').format(mexicoDateTime);

    if (difference.inDays == 0) {
      return 'Hoy a las $time';
    } else if (difference.inDays == 1) {
      return 'Mañana a las $time';
    } else if (difference.inDays == -1) {
      return 'Ayer a las $time';
    } else if (difference.inDays > 0 && difference.inDays <= 7) {
      String dayName = DateFormat('EEEE', 'es').format(mexicoDateTime);
      return '$dayName a las $time';
    } else {
      return '$date a las $time';
    }
  }
}
