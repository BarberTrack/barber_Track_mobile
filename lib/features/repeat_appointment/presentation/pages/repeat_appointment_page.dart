import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';
import '../bloc/repeat_appointment_bloc.dart';
import '../../domain/entities/availability.dart';
import '../widgets/date_picker_widget.dart';
import '../widgets/time_slots_widget.dart';
import '../widgets/confirmation_dialog.dart';

class RepeatAppointmentPage extends StatefulWidget {
  final String businessId;
  final String barberId;
  final String serviceId;
  final String appointmentId;

  const RepeatAppointmentPage({
    super.key,
    required this.businessId,
    required this.barberId,
    required this.serviceId,
    required this.appointmentId,
  });

  @override
  State<RepeatAppointmentPage> createState() => _RepeatAppointmentPageState();
}

class _RepeatAppointmentPageState extends State<RepeatAppointmentPage> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RepeatAppointmentBloc>(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.go('/appointments');
            },
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Regresar a mis citas',
          ),
          title: const Text('Repetir Cita'),
          centerTitle: true,
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
        ),
        body: BlocConsumer<RepeatAppointmentBloc, RepeatAppointmentState>(
          listener: (context, state) {
            if (state is RepeatAppointmentSuccess) {
              _showSuccessMessage(context, state.response);
            } else if (state is RepeatAppointmentError) {
              _showErrorMessage(context, state.message);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  _buildInstructionsCard(),
                  const SizedBox(height: 24),

                  
                  DatePickerWidget(
                    selectedDate: selectedDate,
                    onDateSelected: (date) {
                      setState(() {
                        selectedDate = date;
                      });

                      
                      context.read<RepeatAppointmentBloc>().add(
                        LoadBusinessAvailability(
                          businessId: widget.businessId,
                          barberId: widget.barberId,
                          serviceId: widget.serviceId,
                          selectedDate: date,
                        ),
                      );
                    },
                  ),

                  if (selectedDate != null) ...[
                    const SizedBox(height: 24),

                      
                    if (state is RepeatAppointmentLoading) ...[
                      _buildLoadingWidget(),
                    ] else if (state
                        is RepeatAppointmentAvailabilityLoaded) ...[
                      _buildAvailabilitySection(context, state),
                    ] else if (state is RepeatAppointmentTimeSlotSelected) ...[
                      _buildAvailabilitySection(context, state),
                      const SizedBox(height: 24),
                      _buildConfirmButton(context, state),
                    ] else if (state is RepeatAppointmentCreating) ...[
                      _buildCreatingWidget(),
                    ],
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInstructionsCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Instrucciones',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '1. Selecciona la fecha deseada para tu nueva cita\n'
              '2. Elige el horario disponible que prefieras\n'
              '3. Confirma para agendar tu cita repetida',
              style: TextStyle(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Cargando disponibilidad...',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreatingWidget() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Creando cita repetida...',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailabilitySection(
    BuildContext context,
    RepeatAppointmentState state,
  ) {
    AvailabilityResponse availability;
    TimeSlot? selectedTimeSlot;

    if (state is RepeatAppointmentAvailabilityLoaded) {
      availability = state.availability;
    } else if (state is RepeatAppointmentTimeSlotSelected) {
      availability = state.availability;
      selectedTimeSlot = state.selectedTimeSlot;
    } else {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Horarios Disponibles',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Fecha: ${DateFormat('dd/MM/yyyy - EEEE', 'es').format(selectedDate!)}',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 16),

        TimeSlotsWidget(
          availability: availability,
          selectedDate: selectedDate!,
          selectedTimeSlot: selectedTimeSlot,
          onTimeSlotSelected: (timeSlot) {
            context.read<RepeatAppointmentBloc>().add(
              SelectTimeSlot(timeSlot: timeSlot, selectedDate: selectedDate!),
            );
          },
        ),
      ],
    );
  }

  Widget _buildConfirmButton(
    BuildContext context,
    RepeatAppointmentTimeSlotSelected state,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          final confirmed = await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => ConfirmationDialog(
              selectedDate: state.selectedDate,
              selectedTimeSlot: state.selectedTimeSlot,
            ),
          );

          if (confirmed == true) {
            if (context.mounted) {
              context.read<RepeatAppointmentBloc>().add(
                ConfirmRepeatAppointment(
                  appointmentId: widget.appointmentId,
                  selectedTimeSlot: state.selectedTimeSlot,
                  selectedDate: state.selectedDate,
                ),
              );
            }
          }
        },
        icon: const Icon(Icons.check_circle_outline),
        label: const Text(
          'Confirmar Cita Repetida',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _showSuccessMessage(BuildContext context, dynamic response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Cita repetida exitosamente. ¡Nos vemos pronto!',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    // Navegar de vuelta a la pantalla de citas después de un breve delay
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        context.go('/appointments');
      }
    });
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
