import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/appointment.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;

  const AppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(255, 8, 8, 8),
              const Color.fromARGB(255, 43, 151, 228),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con estado y fecha
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusChip(),
                Text(
                  _formatDateTime(appointment.scheduledDatetime),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Información del negocio
            _buildInfoRow(
              icon: Icons.store,
              title: 'Barbería',
              subtitle: appointment.business.name,
              color: Colors.blue,
            ),
            const SizedBox(height: 12),

            // Información del barbero
            _buildInfoRow(
              icon: Icons.person,
              title: 'Barbero',
              subtitle: appointment.barber.name,
              color: Colors.green,
            ),
            const SizedBox(height: 12),

            // Información del servicio
            _buildInfoRow(
              icon: Icons.content_cut,
              title: 'Servicio',
              subtitle: appointment.service.name,
              color: Colors.orange,
            ),
            const SizedBox(height: 12),

            // Precio y duración
            Row(
              children: [
                Expanded(
                  child: _buildInfoRow(
                    icon: Icons.attach_money,
                    title: 'Precio',
                    subtitle: '\$${appointment.totalPrice}',
                    color: Colors.red,
                  ),
                ),
                Expanded(
                  child: _buildInfoRow(
                    icon: Icons.access_time,
                    title: 'Duración',
                    subtitle: '${appointment.durationMinutes} min',
                    color: Colors.purple,
                  ),
                ),
              ],
            ),

            // Notas del cliente (si existen)
            if (appointment.clientNotes != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 37, 37, 37),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.note,
                          size: 16,
                          color: Colors.amber.shade700,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Notas:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      appointment.clientNotes!,
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color backgroundColor;
    Color textColor;
    String statusText;

    switch (appointment.status.toLowerCase()) {
      case 'scheduled':
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade700;
        statusText = 'Programada';
        break;
      case 'completed':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade700;
        statusText = 'Completada';
        break;
      case 'cancelled':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade700;
        statusText = 'Cancelada';
        break;
      case 'in_progress':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade700;
        statusText = 'En Progreso';
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
        statusText = appointment.status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    String date = DateFormat('dd/MM/yyyy').format(dateTime);
    String time = DateFormat('HH:mm').format(dateTime);

    if (difference.inDays == 0) {
      return 'Hoy $time';
    } else if (difference.inDays == 1) {
      return 'Mañana $time';
    } else if (difference.inDays == -1) {
      return 'Ayer $time';
    } else if (difference.inDays > 0 && difference.inDays <= 7) {
      String dayName = DateFormat('EEEE', 'es').format(dateTime);
      return '$dayName $time';
    } else {
      return '$date $time';
    }
  }
}
