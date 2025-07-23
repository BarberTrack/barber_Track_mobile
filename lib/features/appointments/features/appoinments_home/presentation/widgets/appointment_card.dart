import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/appointment.dart';
import '../../../../../reviews/features/create_review/presentation/widgets/create_review_button.dart';
import '../../../cancel_appointment/presentation/widgets/cancel_appointment_modal.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback? onAppointmentCancelled;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onAppointmentCancelled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 8,
      shadowColor: Colors.blueAccent.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colorScheme.surface, colorScheme.surface.withOpacity(0.8)],
          ),
          border: Border.all(
            color: Colors.blueAccent.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // Header con gradiente
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blueAccent.withOpacity(0.1),
                    Colors.blueAccent.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Status y fecha
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [_buildStatusChip(context)],
                  ),
                  const SizedBox(height: 20),

                  // Información principal con iconos mejorados
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.blueAccent.withOpacity(0.1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Información de fecha y hora
                        _buildInfoRow(
                          context: context,
                          icon: Icons.schedule_rounded,
                          title: 'Fecha y Hora',
                          subtitle: _formatDateTime(
                            appointment.scheduledDatetime,
                          ),
                          color: Colors.blueAccent,
                        ),
                        const SizedBox(height: 20),

                        // Información del negocio
                        _buildInfoRow(
                          context: context,
                          icon: Icons.store_mall_directory_rounded,
                          title: 'Barbería',
                          subtitle: appointment.business.name,
                          color: Colors.blueAccent,
                        ),
                        const SizedBox(height: 20),

                        // Información del barbero
                        _buildInfoRow(
                          context: context,
                          icon: Icons.person_pin_rounded,
                          title: 'Tu Barbero',
                          subtitle: appointment.barber.name,
                          color: Colors.deepPurple,
                        ),
                        const SizedBox(height: 20),

                        // Información del servicio
                        _buildInfoRow(
                          context: context,
                          icon: Icons.content_cut_rounded,
                          title: 'Servicio',
                          subtitle: appointment.service.name,
                          color: Colors.teal,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Sección de precio y duración
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Precio
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.withOpacity(0.1),
                                Colors.green.withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.green.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.attach_money_rounded,
                                  color: Colors.green,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Precio',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.7),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '\$${appointment.totalPrice}',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Duración
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.orange.withOpacity(0.1),
                                Colors.orange.withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.orange.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.schedule_rounded,
                                  color: Colors.orange,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Duración',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.7),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${appointment.durationMinutes} min',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Notas del cliente
                  if (appointment.clientNotes != null) ...[
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blueAccent.withOpacity(0.05),
                            Colors.blueAccent.withOpacity(0.02),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.blueAccent.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.sticky_note_2_rounded,
                                  size: 20,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Notas especiales:',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: colorScheme.outline.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              appointment.clientNotes!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  // Botón de crear reseña (solo si el status es completed)
                  CreateReviewButton(appointment: appointment),

                  // Botón de repetir cita (disponible para todas las citas)
                  const SizedBox(height: 16),
                  _buildRepeatAppointmentButton(context),

                  // Botón de editar cita (solo si el status es scheduled)
                  if (appointment.status.toLowerCase() == 'scheduled') ...[
                    const SizedBox(height: 16),
                    _buildEditAppointmentButton(context),
                  ],

                  // Botón de cancelar cita (solo si el status es scheduled)
                  if (appointment.status.toLowerCase() == 'scheduled') ...[
                    const SizedBox(height: 16),
                    _buildCancelButton(context),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    final theme = Theme.of(context);

    Color backgroundColor;
    Color textColor;
    String statusText;
    IconData icon;

    switch (appointment.status.toLowerCase()) {
      case 'scheduled':
        backgroundColor = Colors.blueAccent;
        textColor = Colors.white;
        statusText = 'Programada';
        icon = Icons.event_available_rounded;
        break;
      case 'completed':
        backgroundColor = Colors.green;
        textColor = Colors.white;
        statusText = 'Completada';
        icon = Icons.check_circle_rounded;
        break;
      case 'cancelled':
        backgroundColor = Colors.red;
        textColor = Colors.white;
        statusText = 'Cancelada';
        icon = Icons.cancel_rounded;
        break;
      case 'no_show':
        backgroundColor = Colors.red;
        textColor = Colors.white;
        statusText = 'No asistió';
        icon = Icons.cancel_rounded;
        break;
      default:
        backgroundColor = Colors.grey;
        textColor = Colors.white;
        statusText = appointment.status;
        icon = Icons.help_outline_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [backgroundColor, backgroundColor.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: textColor),
          const SizedBox(width: 8),
          Text(
            statusText,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.05), color.withOpacity(0.02)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Flecha
          // Container(
          //   padding: const EdgeInsets.all(6),
          //   decoration: BoxDecoration(
          //     color: color.withOpacity(0.1),
          //     shape: BoxShape.circle,
          //   ),
          //   child: Icon(
          //     Icons.arrow_forward_ios_rounded,
          //     size: 12,
          //     color: color,
          //   ),
          // ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    // Convertir de UTC a GMT-6 (hora de México City)
    final mexicoDateTime = dateTime.toUtc().subtract(const Duration(hours: 6));
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

  Widget _buildRepeatAppointmentButton(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          context.go(
            '/repeat-appointment/${appointment.businessId}/${appointment.barberId}/${appointment.serviceId}/${appointment.id}',
          );
        },
        icon: Icon(Icons.repeat_rounded, color: Colors.white, size: 20),
        label: Text(
          'Repetir Cita',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildEditAppointmentButton(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          context.go(
            '/update-appointment/${appointment.id}',
            extra: appointment,
          );
        },
        icon: Icon(Icons.edit_rounded, color: Colors.white, size: 20),
        label: Text(
          'Editar Cita',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () async {
          final result = await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) =>
                CancelAppointmentModal(appointment: appointment),
          );

          // Si se canceló exitosamente, resetear filtro y refrescar
          if (result == true) {
            onAppointmentCancelled?.call();
          }
        },
        icon: Icon(Icons.cancel_rounded, color: Colors.red, size: 20),
        label: Text(
          'Cancelar Cita',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.red, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
