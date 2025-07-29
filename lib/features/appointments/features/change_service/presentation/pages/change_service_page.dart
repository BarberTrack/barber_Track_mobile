import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/di/injection.dart';
import '../../../../../../core/router/app_router.dart';
import '../../../appoinments_home/domain/entities/appointment.dart';
import '../../../create_appointment/domain/entities/service.dart';

import '../bloc/change_service_bloc.dart';
import '../widgets/service_selection_card.dart';
import '../widgets/datetime_option_card.dart';
import '../widgets/date_selection_card.dart';
import '../widgets/time_slots_grid.dart';
import '../widgets/client_notes_card.dart';
import '../widgets/change_service_summary_dialog.dart';

class ChangeServicePage extends StatefulWidget {
  final String appointmentId;
  final Appointment appointment;

  const ChangeServicePage({
    super.key,
    required this.appointmentId,
    required this.appointment,
  });

  @override
  State<ChangeServicePage> createState() => _ChangeServicePageState();
}

class _ChangeServicePageState extends State<ChangeServicePage> {
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
      create: (_) {
        final bloc = sl<ChangeServiceBloc>();
        
        bloc.loadBusinessServicesWithAppointment(
          widget.appointment.businessId,
          widget.appointment,
        );
        return bloc;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Cambiar Servicio'),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blueAccent, Colors.blueAccent.withOpacity(0.8)],
              ),
            ),
          ),
        ),
        body: BlocConsumer<ChangeServiceBloc, ChangeServiceState>(
          listener: (context, state) {
            if (state is ChangeServiceSuccess) {
              _showSuccessDialog(context, state);
            } else if (state is ChangeServiceError) {
              _showErrorSnackBar(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is ChangeServiceLoading ||
                state is ChangeServiceSubmitting) {
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black, Color(0xFF121212)],
                  ),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.blueAccent,
                    ),
                  ),
                ),
              );
            } else if (state is ChangeServiceError) {
              return _buildErrorView(context, state.message);
            } else if (state is ChangeServiceServicesLoaded) {
              return _buildServicesView(context, state);
            } else if (state is ChangeServiceServiceSelected ||
                state is ChangeServiceDateTimeOptionSelected ||
                state is ChangeServiceDateSelected ||
                state is ChangeServiceAvailabilityLoaded ||
                state is ChangeServiceTimeSlotSelected ||
                state is ChangeServiceWithNotes) {
              return _buildChangeServiceFlow(context, state);
            }
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Color(0xFF121212)],
                ),
              ),
              child: const Center(
                child: Text(
                  'Cargando servicios...',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Color(0xFF121212)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final bloc = context.read<ChangeServiceBloc>();
                bloc.loadBusinessServicesWithAppointment(
                  widget.appointment.businessId,
                  widget.appointment,
                );
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesView(
    BuildContext context,
    ChangeServiceServicesLoaded state,
  ) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Color(0xFF121212)],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCurrentServiceInfo(context, state.originalAppointment),
            const SizedBox(height: 24),
            Text(
              'Selecciona el nuevo servicio:',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 16),
            ...state.services.map(
              (service) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ServiceSelectionCard(
                  service: service,
                  isSelected: false,
                  onTap: () {
                    context.read<ChangeServiceBloc>().add(
                      SelectService(service),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentServiceInfo(
    BuildContext context,
    Appointment appointment,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blueAccent.withOpacity(0.1),
            Colors.blueAccent.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade600, size: 20),
              const SizedBox(width: 8),
              Text(
                'Información actual de la cita',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Servicio actual:', appointment.service.name),
          _buildInfoRow('Barbero:', appointment.barber.name),
          _buildInfoRow(
            'Fecha y hora:',
            _formatDateTime(appointment.scheduledDatetime),
          ),
          _buildInfoRow('Precio:', '\$${appointment.totalPrice}'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildChangeServiceFlow(
    BuildContext context,
    ChangeServiceState state,
  ) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Color(0xFF121212)],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            if (state is ChangeServiceServiceSelected ||
                state is ChangeServiceDateTimeOptionSelected ||
                state is ChangeServiceDateSelected ||
                state is ChangeServiceAvailabilityLoaded ||
                state is ChangeServiceTimeSlotSelected ||
                state is ChangeServiceWithNotes) ...[
              _buildSelectedServiceInfo(context, _getSelectedService(state)),
              const SizedBox(height: 24),
            ],

            
            if (state is ChangeServiceServiceSelected) ...[
              Text(
                '¿Deseas mantener la fecha y hora actual?',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 16),
              DateTimeOptionCard(
                title: 'Mantener fecha y hora actual',
                subtitle: _formatDateTime(
                  _getOriginalAppointment(state).scheduledDatetime,
                ),
                icon: Icons.schedule_rounded,
                onTap: () {
                  context.read<ChangeServiceBloc>().add(
                    const SelectKeepDateTime(),
                  );
                },
              ),
              const SizedBox(height: 12),
              DateTimeOptionCard(
                title: 'Cambiar fecha y hora',
                subtitle: 'Seleccionar nueva fecha y horario',
                icon: Icons.calendar_today_rounded,
                onTap: () {
                  context.read<ChangeServiceBloc>().add(
                    const SelectChangeDateTime(),
                  );
                },
              ),
            ],

            
            if (state is ChangeServiceDateTimeOptionSelected &&
                !state.keepDateTime) ...[
              Text(
                'Selecciona la nueva fecha:',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 16),
              DateSelectionCard(
                onDateSelected: (date) {
                  final bloc = context.read<ChangeServiceBloc>();
                  bloc.add(SelectDate(date));

                  
                  final originalAppointment = _getOriginalAppointment(state);
                  final selectedService = _getSelectedService(state);
                  final serviceBarberId = _getBarberIdFromService(
                    selectedService,
                  );

                  if (serviceBarberId != null) {
                    bloc.add(
                      LoadAvailability(
                        businessId: originalAppointment.businessId,
                        barberId: serviceBarberId,
                        date: date.toIso8601String().split('T')[0],
                        days: 1,
                      ),
                    );
                  }
                },
              ),
            ],

            
            if (state is ChangeServiceDateSelected) ...[
              Text(
                'Cargando horarios disponibles...',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
            ],

            if (state is ChangeServiceAvailabilityLoaded) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Selecciona el horario:',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      
                      context.read<ChangeServiceBloc>().add(
                        SelectChangeDateTime(),
                      );
                    },
                    icon: const Icon(
                      Icons.calendar_today_rounded,
                      size: 18,
                    ),
                    label: const Text('Cambiar fecha'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.event_rounded,
                      color: Colors.blue.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Fecha seleccionada: ${DateFormat('dd/MM/yyyy', 'es').format(state.selectedDate)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TimeSlotsGrid(
                availability: state.availability,
                selectedDate: state.selectedDate,
                onTimeSlotSelected: (timeSlot) {
                  context.read<ChangeServiceBloc>().add(
                    SelectTimeSlot(timeSlot),
                  );
                },
              ),
            ],


            if (state is ChangeServiceDateTimeOptionSelected &&
                    state.keepDateTime ||
                state is ChangeServiceTimeSlotSelected ||
                state is ChangeServiceWithNotes) ...[
              const SizedBox(height: 24),
              Text(
                'Notas especiales (opcional):',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 16),
              ClientNotesCard(
                controller: _notesController,
                initialNotes: clientNotes,
                onNotesChanged: (notes) {
                  setState(() {
                    clientNotes = notes;
                  });
                  context.read<ChangeServiceBloc>().add(
                    UpdateClientNotes(notes),
                  );
                },
              ),
              const SizedBox(height: 24),
              _buildChangeServiceButton(context, state),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedServiceInfo(BuildContext context, Service service) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blueAccent.withOpacity(0.1),
            Colors.blueAccent.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Colors.green.shade600,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Nuevo servicio seleccionado',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Servicio:', service.name),
          _buildInfoRow('Duración:', '${service.durationMinutes} minutos'),
          _buildInfoRow('Precio:', '\$${service.price}'),
          if (service.description.isNotEmpty)
            _buildInfoRow('Descripción:', service.description),
        ],
      ),
    );
  }

  Widget _buildChangeServiceButton(
    BuildContext context,
    ChangeServiceState state,
  ) {
    final canSubmit = _canSubmitChangeService(state);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canSubmit
            ? () => _showConfirmationDialog(context, state)
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Cambiar Servicio',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  bool _canSubmitChangeService(ChangeServiceState state) {
    if (state is ChangeServiceDateTimeOptionSelected && state.keepDateTime) {
      return true;
    }
    if (state is ChangeServiceTimeSlotSelected ||
        state is ChangeServiceWithNotes) {
      return true;
    }
    return false;
  }

  void _showConfirmationDialog(BuildContext context, ChangeServiceState state) {
    showDialog(
      context: context,
      builder: (dialogContext) => ChangeServiceSummaryDialog(
        state: state,
        clientNotes: clientNotes,
        onConfirm: () {
          Navigator.of(dialogContext).pop();
          context.read<ChangeServiceBloc>().add(const SubmitChangeService());
        },
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, ChangeServiceSuccess state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('¡Éxito!'),
          ],
        ),
        content: Text(state.response.message),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.go(AppRouter.appointments);
            },
            child: const Text('Ir a Mis Citas'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    Color backgroundColor;
    String displayMessage;

    if (message.contains('400')) {
      backgroundColor = Colors.blueAccent;
      displayMessage = 'Datos de entrada inválidos';
    } else if (message.contains('403')) {
      backgroundColor = Colors.red.shade600;
      displayMessage =
          'No se puede modificar la cita (muy cerca de la fecha programada)';
    } else {
      backgroundColor = Colors.red.shade600;
      displayMessage = message;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(displayMessage),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    // Las fechas de appointment.scheduledDatetime vienen del servidor en UTC
    // y necesitan convertirse a hora de México (UTC-6)
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

  Service _getSelectedService(ChangeServiceState state) {
    if (state is ChangeServiceServiceSelected) return state.selectedService;
    if (state is ChangeServiceDateTimeOptionSelected)
      return state.selectedService;
    if (state is ChangeServiceDateSelected) return state.selectedService;
    if (state is ChangeServiceAvailabilityLoaded) return state.selectedService;
    if (state is ChangeServiceTimeSlotSelected) return state.selectedService;
    if (state is ChangeServiceWithNotes) return state.selectedService;
    throw Exception('Service not found in state');
  }

  Appointment _getOriginalAppointment(ChangeServiceState state) {
    if (state is ChangeServiceServiceSelected) return state.originalAppointment;
    if (state is ChangeServiceDateTimeOptionSelected)
      return state.originalAppointment;
    if (state is ChangeServiceDateSelected) return state.originalAppointment;
    if (state is ChangeServiceAvailabilityLoaded)
      return state.originalAppointment;
    if (state is ChangeServiceTimeSlotSelected)
      return state.originalAppointment;
    if (state is ChangeServiceWithNotes) return state.originalAppointment;
    throw Exception('Appointment not found in state');
  }

  
  String? _getBarberIdFromService(Service service) {
    if (service.barberAssignments.isEmpty) {
      return null;
    }

    
    final preferredBarber = service.barberAssignments
        .where((assignment) => assignment.isPreferred)
        .firstOrNull;

    if (preferredBarber != null) {
      return preferredBarber.barberId;
    }

    
    return service.barberAssignments.first.barberId;
  }
}
