import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/di/injection.dart';
import '../../../appoinments_home/domain/entities/appointment.dart';
import '../bloc/cancel_appointment_bloc.dart';
import '../bloc/cancel_appointment_event.dart';
import '../bloc/cancel_appointment_state.dart';

class CancelAppointmentModal extends StatefulWidget {
  final Appointment appointment;

  const CancelAppointmentModal({super.key, required this.appointment});

  @override
  State<CancelAppointmentModal> createState() => _CancelAppointmentModalState();
}

class _CancelAppointmentModalState extends State<CancelAppointmentModal> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocProvider(
      create: (context) => sl<CancelAppointmentBloc>(),
      child: BlocListener<CancelAppointmentBloc, CancelAppointmentState>(
        listener: (context, state) {
          if (state is CancelAppointmentSuccess) {
            Navigator.of(context).pop(true);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is CancelAppointmentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.surface,
                  colorScheme.surface.withOpacity(0.9),
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.red.withOpacity(0.1),
                        Colors.red.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.red.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.cancel_rounded,
                          color: Colors.red,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cancelar Cita',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Esta acción no se puede deshacer',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Información de la cita
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.outline.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detalles de la cita:',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoItem(
                        context,
                        Icons.store_rounded,
                        'Barbería',
                        widget.appointment.business.name,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoItem(
                        context,
                        Icons.person_rounded,
                        'Barbero',
                        widget.appointment.barber.name,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoItem(
                        context,
                        Icons.content_cut_rounded,
                        'Servicio',
                        widget.appointment.service.name,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Formulario de cancelación
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Motivo de cancelación *',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _reasonController,
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor ingresa el motivo de cancelación';
                          }
                          if (value.trim().length < 6) {
                            return 'El motivo debe tener al menos 6 caracteres';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText:
                              'Explica brevemente por qué cancelas la cita...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: colorScheme.outline.withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: colorScheme.surface,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Botones
                BlocBuilder<CancelAppointmentBloc, CancelAppointmentState>(
                  builder: (context, state) {
                    return Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: state is CancelAppointmentLoading
                                ? null
                                : () => Navigator.of(context).pop(false),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Mantener Cita',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: state is CancelAppointmentLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<CancelAppointmentBloc>().add(
                                        CancelAppointmentRequested(
                                          appointmentId: widget.appointment.id,
                                          reason: _reasonController.text.trim(),
                                        ),
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: state is CancelAppointmentLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'Cancelar Cita',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(icon, size: 16, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
