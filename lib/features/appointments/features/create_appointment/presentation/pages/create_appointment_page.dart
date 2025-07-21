import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/di/injection.dart';
import '../../../../../../core/router/app_router.dart';
import '../bloc/create_appointment_bloc.dart';
import '../../domain/entities/service.dart';
import '../../domain/entities/time_slot.dart';
import '../widgets/widgets.dart';

class CreateAppointmentPage extends StatefulWidget {
  final String businessId;

  const CreateAppointmentPage({super.key, required this.businessId});

  @override
  State<CreateAppointmentPage> createState() => _CreateAppointmentPageState();
}

class _CreateAppointmentPageState extends State<CreateAppointmentPage> {
  String clientNotes = '';
  bool showClientNotesCard = false;
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<CreateAppointmentBloc>()
            ..add(LoadBusinessServices(widget.businessId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Crear Cita'),
          centerTitle: true,
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
        ),
        body: BlocConsumer<CreateAppointmentBloc, CreateAppointmentState>(
          listener: (context, state) {
            if (state is CreateAppointmentSuccess) {
              _showSuccessDialog(context, state);
            } else if (state is CreateAppointmentError) {
              _showErrorDialog(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is CreateAppointmentLoading ||
                state is CreateAppointmentCreating) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CreateAppointmentError) {
              return _buildErrorView(context, state.message);
            } else if (state is CreateAppointmentServicesLoaded) {
              return _buildServicesView(context, state);
            } else if (state is CreateAppointmentServiceSelected ||
                state is CreateAppointmentDateSelected ||
                state is CreateAppointmentAvailabilityLoaded ||
                state is CreateAppointmentTimeSlotSelected ||
                state is CreateAppointmentWithNotes) {
              return _buildAppointmentFlow(context, state);
            }
            return const Center(child: Text('Cargando servicios...'));
          },
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return ErrorView(message: message, businessId: widget.businessId);
  }

  Widget _buildServicesView(
    BuildContext context,
    CreateAppointmentServicesLoaded state,
  ) {
    return ServicesView(state: state);
  }

  Widget _buildAppointmentFlow(
    BuildContext context,
    CreateAppointmentState state,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Servicio seleccionado
          if (state is CreateAppointmentServiceSelected ||
              state is CreateAppointmentDateSelected ||
              state is CreateAppointmentAvailabilityLoaded ||
              state is CreateAppointmentTimeSlotSelected) ...[
            ServiceSummary(
              service: _getSelectedService(state),
              businessId: widget.businessId,
            ),
            const SizedBox(height: 24),
          ],

          // Selector de fecha
          if (state is CreateAppointmentServiceSelected) ...[
            const DateSelector(),
          ],

          // Fecha seleccionada y disponibilidad
          if (state is CreateAppointmentDateSelected ||
              state is CreateAppointmentAvailabilityLoaded ||
              state is CreateAppointmentTimeSlotSelected) ...[
            DateSummary(
              date: _getSelectedDate(state),
              businessId: widget.businessId,
            ),
            const SizedBox(height: 16),
            if (state is CreateAppointmentDateSelected) ...[
              LoadAvailabilityButton(state: state),
            ],
          ],

          // Horarios disponibles
          if (state is CreateAppointmentAvailabilityLoaded ||
              state is CreateAppointmentTimeSlotSelected) ...[
            TimeSlotsWidget(
              availability: state is CreateAppointmentAvailabilityLoaded
                  ? state.availability
                  : (state as CreateAppointmentTimeSlotSelected).availability,
              state: state,
            ),
          ],

          // Fecha y hora seleccionada específica
          if (state is CreateAppointmentTimeSlotSelected) ...[
            const SizedBox(height: 24),
            _buildQuickDateTimeCard(context, state),
            const SizedBox(height: 16),
            _buildSelectedDateTimeSummary(context, state),
            const SizedBox(height: 16),
            _buildFinalSummary(context, state),
            // Card de client notes
            if (showClientNotesCard) ...[
              const SizedBox(height: 16),
              ClientNotesCard(
                notesController: _notesController,
                clientNotes: clientNotes,
                onNotesChanged: (value) {
                  setState(() {
                    clientNotes = value;
                  });
                },
                onConfirmPressed: () => _showConfirmationModal(context),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildSelectedDateTimeSummary(
    BuildContext context,
    CreateAppointmentTimeSlotSelected state,
  ) {
    // Verificar si la fecha seleccionada es diferente a la fecha de búsqueda original
    final originalSearchDate = _getOriginalSearchDate(state);
    final isDifferentDate = !_isSameDateOnly(
      state.selectedDate,
      originalSearchDate,
    );

    return Card(
      elevation: 8,
      shadowColor: Colors.green.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey.shade900,
          border: Border.all(
            color: isDifferentDate
                ? Colors.orange.withOpacity(0.4)
                : Colors.green.withOpacity(0.3),
            width: 1,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              isDifferentDate
                  ? Colors.orange.withOpacity(0.1)
                  : Colors.green.withOpacity(0.1),
              Colors.grey.shade900,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDifferentDate
                          ? Colors.orange.withOpacity(0.2)
                          : Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isDifferentDate
                          ? Icons.event_note
                          : Icons.event_available,
                      color: isDifferentDate
                          ? Colors.orange.shade400
                          : Colors.green.shade400,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fecha y hora seleccionada',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        if (isDifferentDate) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.orange.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              'Día diferente al de búsqueda',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.orange.shade300,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          'Fecha cita:',
                          _formatDateForDisplay(
                            state.selectedDate.toIso8601String(),
                          ),
                          isDifferentDate
                              ? Colors.orange.shade300
                              : Colors.blue.shade300,
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          'Hora:',
                          state.selectedTimeSlot.time,
                          Colors.cyan.shade300,
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          'Fecha y hora completa:',
                          '${_formatDateForDisplay(state.selectedDate.toIso8601String())} a las ${state.selectedTimeSlot.time}',
                          Colors.green.shade300,
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          'Barbero:',
                          state.selectedTimeSlot.barberName,
                          Colors.purple.shade300,
                        ),
                        if (isDifferentDate) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.grey.shade400,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Búsqueda inicial: ${DateFormat('dd/MM/yyyy').format(originalSearchDate)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  DateTime _getOriginalSearchDate(CreateAppointmentTimeSlotSelected state) {
    // Intentar obtener la fecha original de búsqueda desde el availability
    if (state.availability.isNotEmpty) {
      try {
        return DateTime.parse(state.availability.first.date);
      } catch (e) {
        return state.selectedDate;
      }
    }
    return state.selectedDate;
  }

  bool _isSameDateOnly(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Widget _buildQuickDateTimeCard(
    BuildContext context,
    CreateAppointmentTimeSlotSelected state,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade600, Colors.blue.shade800],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.check_circle, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cita agendada para:',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDateForDisplay(
                        state.selectedDate.toIso8601String(),
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'a las ${state.selectedTimeSlot.time}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  state.selectedTimeSlot.barberName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color iconColor) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: iconColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade400,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFinalSummary(
    BuildContext context,
    CreateAppointmentTimeSlotSelected state,
  ) {
    return Card(
      color: const Color.fromARGB(255, 0, 0, 0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green.shade600),
                const SizedBox(width: 8),
                const Text(
                  'Resumen de la cita',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Servicio: ${state.selectedService.name}'),
            Text(
              'Fecha: ${DateFormat('dd/MM/yyyy').format(state.selectedDate)}',
            ),
            Text('Hora: ${state.selectedTimeSlot.time}'),
            Text('Barbero: ${state.selectedTimeSlot.barberName}'),
            Text('Precio: \$${state.selectedService.price.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    showClientNotesCard = true;
                  });
                },
                child: const Text('Continuar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now().add(const Duration(days: 1)),
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime.now().add(const Duration(days: 30)),
  //   );

  //   if (picked != null) {
  //     final bloc = context.read<CreateAppointmentBloc>();
  //     final currentState = bloc.state;

  //     // Actualizar la fecha seleccionada
  //     bloc.add(SelectDate(picked));

  //     // Si hay un servicio seleccionado, cargar automáticamente la disponibilidad para la nueva fecha
  //     if (currentState is CreateAppointmentServiceSelected ||
  //         currentState is CreateAppointmentDateSelected ||
  //         currentState is CreateAppointmentAvailabilityLoaded ||
  //         currentState is CreateAppointmentTimeSlotSelected ||
  //         currentState is CreateAppointmentWithNotes) {
  //       final service = _getSelectedService(currentState);

  //       // Obtener el primer barbero del servicio seleccionado
  //       if (service.barberAssignments.isNotEmpty) {
  //         final barberId = service.barberAssignments.first.barberId;
  //         final dateString = DateFormat('yyyy-MM-dd').format(picked);

  //         // Cargar la disponibilidad para la nueva fecha
  //         bloc.add(
  //           LoadAvailability(
  //             businessId: widget.businessId,
  //             barberId: barberId,
  //             date: dateString,
  //             days: 3,
  //           ),
  //         );
  //       }
  //     }
  //   }
  // }

  void _showDebugModal(BuildContext context, CreateAppointmentState state) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Información de Debug'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Business ID: ${widget.businessId}'),
              const SizedBox(height: 8),
              if (state is CreateAppointmentServiceSelected ||
                  state is CreateAppointmentDateSelected ||
                  state is CreateAppointmentAvailabilityLoaded ||
                  state is CreateAppointmentTimeSlotSelected) ...[
                Text('Service ID: ${_getSelectedService(state).id}'),
                Text(
                  'Barber ID: ${_getBarberIdFromService(_getSelectedService(state))}',
                ),
                const SizedBox(height: 8),
              ],
              if (state is CreateAppointmentDateSelected ||
                  state is CreateAppointmentAvailabilityLoaded ||
                  state is CreateAppointmentTimeSlotSelected) ...[
                Text('Date: ${_getFormattedDateTime(state)}'),
                const SizedBox(height: 8),
              ],
              if (clientNotes.isNotEmpty) ...[
                Text('Client Notes: $clientNotes'),
                const SizedBox(height: 8),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Service _getSelectedService(CreateAppointmentState state) {
    if (state is CreateAppointmentServiceSelected) return state.selectedService;
    if (state is CreateAppointmentDateSelected) return state.selectedService;
    if (state is CreateAppointmentAvailabilityLoaded)
      return state.selectedService;
    if (state is CreateAppointmentTimeSlotSelected)
      return state.selectedService;
    if (state is CreateAppointmentWithNotes) return state.selectedService;
    throw Exception('Estado no válido para obtener servicio seleccionado');
  }

  DateTime _getSelectedDate(CreateAppointmentState state) {
    if (state is CreateAppointmentDateSelected) return state.selectedDate;
    if (state is CreateAppointmentAvailabilityLoaded) return state.selectedDate;
    if (state is CreateAppointmentTimeSlotSelected) return state.selectedDate;
    if (state is CreateAppointmentWithNotes) return state.selectedDate;
    throw Exception('Estado no válido para obtener fecha seleccionada');
  }

  String _getBarberIdFromService(Service service) {
    return service.barberAssignments.isNotEmpty
        ? service.barberAssignments.first.barberId
        : 'No disponible';
  }

  String _getFormattedDateTime(CreateAppointmentState state) {
    final selectedDate = _getSelectedDate(state);

    // Si tenemos un time slot seleccionado, combinar fecha y hora
    if (state is CreateAppointmentTimeSlotSelected) {
      final timeSlot = state.selectedTimeSlot;
      final timeParts = timeSlot.time.split(':');
      if (timeParts.length >= 2) {
        final hour = int.tryParse(timeParts[0]) ?? 0;
        final minute = int.tryParse(timeParts[1]) ?? 0;

        final combinedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          hour,
          minute,
        );

        return combinedDateTime.toIso8601String();
      }
    }

    // Si no hay time slot, mostrar solo la fecha
    return selectedDate.toIso8601String();
  }

  // Helper para formatear fechas sin problemas de locale
  String _formatDateForDisplay(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final weekdays = [
        'Domingo',
        'Lunes',
        'Martes',
        'Miércoles',
        'Jueves',
        'Viernes',
        'Sábado',
      ];
      final months = [
        'Enero',
        'Febrero',
        'Marzo',
        'Abril',
        'Mayo',
        'Junio',
        'Julio',
        'Agosto',
        'Septiembre',
        'Octubre',
        'Noviembre',
        'Diciembre',
      ];

      final weekday = weekdays[date.weekday % 7];
      final month = months[date.month - 1];

      return '$weekday, ${date.day} de $month ${date.year}';
    } catch (e) {
      // Fallback en caso de error
      return DateFormat('dd/MM/yyyy').format(DateTime.parse(dateString));
    }
  }

  void _showConfirmationModal(BuildContext context) {
    final bloc = context.read<CreateAppointmentBloc>();
    final state = bloc.state;

    if (state is! CreateAppointmentTimeSlotSelected &&
        state is! CreateAppointmentWithNotes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor complete todos los datos de la cita'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final service = _getSelectedService(state);
    final selectedDate = _getSelectedDate(state);
    final timeSlot = _getSelectedTimeSlot(state);
    final notes = state is CreateAppointmentWithNotes
        ? state.clientNotes
        : clientNotes;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.blue),
            SizedBox(width: 8),
            Text('Confirmar Cita'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Servicio:', service.name),
              _buildDetailRow(
                'Precio:',
                '\$${service.price.toStringAsFixed(2)}',
              ),
              _buildDetailRow(
                'Duración:',
                '${service.durationMinutes} minutos',
              ),
              _buildDetailRow('Barbero:', timeSlot.barberName),
              _buildDetailRow(
                'Fecha:',
                _formatDateForDisplay(selectedDate.toIso8601String()),
              ),
              _buildDetailRow('Hora:', timeSlot.time),
              if (notes.isNotEmpty) _buildDetailRow('Notas:', notes),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 43, 43, 43),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '¿Está seguro que desea agendar esta cita?',
                        style: TextStyle(fontWeight: FontWeight.w500),
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
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              _updateClientNotesAndCreateAppointment(bloc, notes);
            },
            child: const Text('Agendar Cita'),
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
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _updateClientNotesAndCreateAppointment(
    CreateAppointmentBloc bloc,
    String notes,
  ) {
    // Actualizar notas si no están vacías
    if (notes.isNotEmpty) {
      bloc.add(UpdateClientNotes(notes));
    }

    // Crear la cita
    bloc.add(const CreateAppointment());
  }

  void _showSuccessDialog(
    BuildContext context,
    CreateAppointmentSuccess state,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 32),
            SizedBox(width: 8),
            Text('¡Cita Agendada!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Su cita ha sido agendada exitosamente.',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              context.go(AppRouter.home);
            },
            child: const Text('Ir a Inicio'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error, color: Colors.red, size: 32),
            SizedBox(width: 8),
            Text('Error'),
          ],
        ),
        content: Text(
          'Error al agendar la cita: $message',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  TimeSlot _getSelectedTimeSlot(CreateAppointmentState state) {
    if (state is CreateAppointmentTimeSlotSelected)
      return state.selectedTimeSlot;
    if (state is CreateAppointmentWithNotes) return state.selectedTimeSlot;
    throw Exception('Estado no válido para obtener time slot seleccionado');
  }
}
