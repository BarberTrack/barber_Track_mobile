import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/di/injection.dart';
import '../../../../../../core/router/app_router.dart';
import '../../../appoinments_home/domain/entities/appointment.dart';
import '../bloc/update_appointment_bloc.dart';
import '../../domain/entities/availability.dart';
import '../widgets/availability_calendar.dart';
import '../widgets/time_slots_grid.dart';
import '../widgets/client_notes_section.dart';

class UpdateAppointmentPage extends StatefulWidget {
  final Appointment appointment;

  const UpdateAppointmentPage({super.key, required this.appointment});

  @override
  State<UpdateAppointmentPage> createState() => _UpdateAppointmentPageState();
}

class _UpdateAppointmentPageState extends State<UpdateAppointmentPage> {
  DateTime? selectedDate;
  String clientNotes = '';
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    clientNotes = widget.appointment.clientNotes ?? '';
    _notesController.text = clientNotes;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<UpdateAppointmentBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Editar Cita'),
          centerTitle: true,
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
        ),
        body: BlocConsumer<UpdateAppointmentBloc, UpdateAppointmentState>(
          listener: (context, state) {
            if (state is UpdateAppointmentSuccess) {
              _showSuccessSnackBar(context);
              context.go(AppRouter.appointments);
            } else if (state is UpdateAppointmentError) {
              _showErrorSnackBar(context, state.message, state.statusCode);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                _buildAppointmentHeader(),

                Expanded(child: _buildContent(context, state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppointmentHeader() {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.2), width: 1),
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
                  Icons.edit_calendar_rounded,
                  size: 20,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Cita Actual',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.store_mall_directory_rounded,
            title: 'Barbería',
            subtitle: widget.appointment.business.name,
            color: Colors.blueAccent,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.person_pin_rounded,
            title: 'Barbero',
            subtitle: widget.appointment.barber.name,
            color: Colors.deepPurple,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.content_cut_rounded,
            title: 'Servicio',
            subtitle: widget.appointment.service.name,
            color: Colors.teal,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.schedule_rounded,
            title: 'Fecha Actual',
            subtitle: _formatCurrentDateTime(
              widget.appointment.scheduledDatetime,
            ),
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, UpdateAppointmentState state) {
    if (state is UpdateAppointmentLoading ||
        state is UpdateAppointmentUpdating) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is UpdateAppointmentError) {
      return _buildErrorView(context, state.message);
    } else if (state is UpdateAppointmentInitial) {
      return _buildInitialView(context);
    } else {
      return _buildAvailabilityView(context, state);
    }
  }

  Widget _buildInitialView(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        color: Colors.blue.shade600,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Selecciona una nueva fecha',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Elige una fecha para ver los horarios disponibles con tu barbero y servicio actual.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  AvailabilityCalendar(
                    onDateSelected: (date) {
                      setState(() {
                        selectedDate = date;
                      });
                      _loadAvailability(context, date);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityView(
    BuildContext context,
    UpdateAppointmentState state,
  ) {
    List<Availability> availability = [];

    if (state is UpdateAppointmentAvailabilityLoaded) {
      availability = state.availability;
    } else if (state is UpdateAppointmentTimeSlotSelected) {
      availability = state.availability;
    } else if (state is UpdateAppointmentWithNotes) {
      availability = state.availability;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        color: Colors.blue.shade600,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Seleccionar fecha',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AvailabilityCalendar(
                    onDateSelected: (date) {
                      setState(() {
                        selectedDate = date;
                      });
                      _loadAvailability(context, date);
                    },
                    selectedDate: selectedDate,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          
          if (availability.isNotEmpty) ...[
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: Colors.green.shade600,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Horarios disponibles',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TimeSlotsGrid(
                      availability: availability,
                      selectedTimeSlot:
                          state is UpdateAppointmentTimeSlotSelected
                          ? state.selectedTimeSlot
                          : state is UpdateAppointmentWithNotes
                          ? state.selectedTimeSlot
                          : null,
                      selectedDate: state is UpdateAppointmentTimeSlotSelected
                          ? state.selectedDate
                          : state is UpdateAppointmentWithNotes
                          ? state.selectedDate
                          : null,
                      originalAppointmentDate:
                          widget.appointment.scheduledDatetime,
                      originalAppointmentTime: _extractTimeFromDateTime(
                        widget.appointment.scheduledDatetime,
                      ),
                      onTimeSlotSelected: (timeSlot, date) {
                        context.read<UpdateAppointmentBloc>().add(
                          SelectTimeSlot(
                            timeSlot: timeSlot,
                            selectedDate: date,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Leyenda:',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildLegendItem(
                          context,
                          icon: Icons.schedule_rounded,
                          color: Colors.orange.shade600,
                          label: 'Horario Actual',
                        ),
                      ),
                      Expanded(
                        child: _buildLegendItem(
                          context,
                          icon: Icons.check_circle_rounded,
                          color: Colors.green.shade600,
                          label: 'Seleccionado',
                        ),
                      ),
                      Expanded(
                        child: _buildLegendItem(
                          context,
                          icon: Icons.access_time_rounded,
                          color: Colors.blue.shade600,
                          label: 'Disponible',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          
          if (state is UpdateAppointmentTimeSlotSelected ||
              state is UpdateAppointmentWithNotes) ...[
            ClientNotesSection(
              controller: _notesController,
              initialNotes: clientNotes,
              onNotesChanged: (notes) {
                setState(() {
                  clientNotes = notes;
                });
                context.read<UpdateAppointmentBloc>().add(
                  UpdateClientNotes(notes),
                );
              },
            ),
            const SizedBox(height: 24),

            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showConfirmationDialog(context, state),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.update_rounded, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Actualizar Cita',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<UpdateAppointmentBloc>().add(const ResetState());
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loadAvailability(BuildContext context, DateTime date) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);

    context.read<UpdateAppointmentBloc>().add(
      LoadAvailability(
        businessId: widget.appointment.businessId,
        barberId: widget.appointment.barberId,
        serviceId: widget.appointment.serviceId,
        date: formattedDate,
        days: 1,
      ),
    );
  }

  void _showConfirmationDialog(
    BuildContext context,
    UpdateAppointmentState state,
  ) {
    TimeSlot? selectedTimeSlot;
    DateTime? selectedDateTime;
    String? notes;

    if (state is UpdateAppointmentTimeSlotSelected) {
      selectedTimeSlot = state.selectedTimeSlot;
      selectedDateTime = state.selectedDate;
      notes = clientNotes;
    } else if (state is UpdateAppointmentWithNotes) {
      selectedTimeSlot = state.selectedTimeSlot;
      selectedDateTime = state.selectedDate;
      notes = state.clientNotes;
    }

    if (selectedTimeSlot == null || selectedDateTime == null) return;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.update_rounded, color: Colors.blue),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                'Confirmar Actualización',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Se actualizará tu cita con los siguientes datos:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                        'Nueva fecha:',
                        _formatSelectedDateTime(
                          selectedDateTime!,
                          selectedTimeSlot!.time,
                        ),
                      ),
                      _buildDetailRow(
                        'Barbero:',
                        widget.appointment.barber.name,
                      ),
                      _buildDetailRow(
                        'Servicio:',
                        widget.appointment.service.name,
                      ),
                      _buildDetailRow(
                        'Precio:',
                        '\$${widget.appointment.totalPrice}',
                      ),
                      if (notes != null && notes.isNotEmpty)
                        _buildDetailRow('Notas:', notes),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<UpdateAppointmentBloc>().add(
                SubmitUpdateAppointment(
                  appointmentId: widget.appointment.id,
                  businessId: widget.appointment.businessId,
                  barberId: widget.appointment.barberId,
                  serviceId: widget.appointment.serviceId,
                ),
              );
            },
            child: const Text('Actualizar Cita'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(value, softWrap: true, overflow: TextOverflow.visible),
          ),
        ],
      ),
    );
  }

  String _formatCurrentDateTime(DateTime dateTime) {
    final date = DateFormat('dd/MM/yyyy').format(dateTime);
    final time = DateFormat('HH:mm').format(dateTime);
    return '$date a las $time';
  }

  String _formatSelectedDateTime(DateTime date, String time) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(date);
    return '$formattedDate a las $time';
  }

  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text('Cita actualizada exitosamente'),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showErrorSnackBar(
    BuildContext context,
    String message,
    int? statusCode,
  ) {
    Color backgroundColor;
    IconData icon;

    switch (statusCode) {
      case 400:
        backgroundColor = Colors.orange.shade600;
        icon = Icons.warning_rounded;
        break;
      case 403:
        backgroundColor = Colors.red.shade600;
        icon = Icons.block_rounded;
        break;
      case 404:
        backgroundColor = Colors.red.shade600;
        icon = Icons.error_rounded;
        break;
      default:
        backgroundColor = Colors.red.shade600;
        icon = Icons.error_rounded;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  String _extractTimeFromDateTime(DateTime dateTime) {
    final timeFormat = DateFormat('HH:mm');
    return timeFormat.format(dateTime);
  }

  Widget _buildLegendItem(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
              fontSize: 11,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
