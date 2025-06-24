import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/di/injection.dart';
import '../../../../../../core/router/app_router.dart';
import '../bloc/create_appointment_bloc.dart';
import '../../domain/entities/service.dart';
import '../../domain/entities/time_slot.dart';

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
        floatingActionButton:
            BlocBuilder<CreateAppointmentBloc, CreateAppointmentState>(
              builder: (context, state) {
                return FloatingActionButton(
                  backgroundColor: Colors.orange.shade600,
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.info),
                  onPressed: () => _showDebugModal(context, state),
                );
              },
            ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
          const SizedBox(height: 16),
          Text(
            'Error: $message',
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<CreateAppointmentBloc>().add(
                LoadBusinessServices(widget.businessId),
              );
            },
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesView(
    BuildContext context,
    CreateAppointmentServicesLoaded state,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selecciona un servicio:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: state.services.length,
              itemBuilder: (context, index) {
                final service = state.services[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(service.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(service.description),
                        const SizedBox(height: 4),
                        Text(
                          '\$${service.price.toStringAsFixed(2)} - ${service.durationMinutes} min',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      context.read<CreateAppointmentBloc>().add(
                        SelectService(service),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
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
            _buildServiceSummary(context, _getSelectedService(state)),
            const SizedBox(height: 24),
          ],

          // Selector de fecha
          if (state is CreateAppointmentServiceSelected) ...[
            _buildDateSelector(context),
          ],

          // Fecha seleccionada y disponibilidad
          if (state is CreateAppointmentDateSelected ||
              state is CreateAppointmentAvailabilityLoaded ||
              state is CreateAppointmentTimeSlotSelected) ...[
            _buildDateSummary(context, _getSelectedDate(state)),
            const SizedBox(height: 16),
            if (state is CreateAppointmentDateSelected) ...[
              _buildLoadAvailabilityButton(context, state),
            ],
          ],

          // Horarios disponibles
          if (state is CreateAppointmentAvailabilityLoaded ||
              state is CreateAppointmentTimeSlotSelected) ...[
            _buildTimeSlots(context, state),
          ],

          // Resumen final
          if (state is CreateAppointmentTimeSlotSelected) ...[
            const SizedBox(height: 24),
            _buildFinalSummary(context, state),
            // Card de client notes
            if (showClientNotesCard) ...[
              const SizedBox(height: 16),
              _buildClientNotesCard(context),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildServiceSummary(BuildContext context, Service service) {
    return Card(
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
                  'Servicio seleccionado',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(service.name, style: const TextStyle(fontSize: 18)),
            Text(
              '\$${service.price.toStringAsFixed(2)} - ${service.durationMinutes} min',
              style: TextStyle(color: Colors.green.shade700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selecciona una fecha:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: const Text('Elegir fecha'),
                onPressed: () => _selectDate(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSummary(BuildContext context, DateTime date) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green.shade600),
            const SizedBox(width: 8),
            Text(
              'Fecha: ${DateFormat('dd/MM/yyyy').format(date)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadAvailabilityButton(
    BuildContext context,
    CreateAppointmentDateSelected state,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.access_time),
        label: const Text('Cargar horarios disponibles'),
        onPressed: () {
          // Obtener el primer barbero del servicio seleccionado
          if (state.selectedService.barberAssignments.isNotEmpty) {
            final barberId =
                state.selectedService.barberAssignments.first.barberId;
            final dateString = DateFormat(
              'yyyy-MM-dd',
            ).format(state.selectedDate);

            context.read<CreateAppointmentBloc>().add(
              LoadAvailability(
                businessId: state.businessId,
                barberId: barberId,
                date: dateString,
                days: 3,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildTimeSlots(BuildContext context, dynamic state) {
    final availability = state is CreateAppointmentAvailabilityLoaded
        ? state.availability
        : (state as CreateAppointmentTimeSlotSelected).availability;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Horarios disponibles:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...availability.map((dayAvailability) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatDateForDisplay(dayAvailability.date),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Solo mostrar horarios si hay slots disponibles
                  if (dayAvailability.slots.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: dayAvailability.slots
                          .where((slot) => slot.available)
                          .map(
                            (slot) => _buildTimeSlotChip(context, slot, state),
                          )
                          .toList(),
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.grey.shade600,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Todos los horaioos estan libre',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotChip(
    BuildContext context,
    TimeSlot slot,
    dynamic state,
  ) {
    final isSelected =
        state is CreateAppointmentTimeSlotSelected &&
        state.selectedTimeSlot.time == slot.time;

    return ChoiceChip(
      label: Text(slot.time),
      selected: isSelected,
      onSelected: (selected) {
        // Siempre disparar el evento de selección para permitir cambios
        context.read<CreateAppointmentBloc>().add(SelectTimeSlot(slot));
      },
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

  Widget _buildClientNotesCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.note_add, color: Colors.blue.shade600),
                const SizedBox(width: 8),
                const Text(
                  'Notas adicionales',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Comentarios o notas especiales (opcional)',
                hintText: 'Ej: Corte específico, preferencias, etc.',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) {
                setState(() {
                  clientNotes = value;
                });
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _showConfirmationModal(context),
                child: const Text('Confirmar cita'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      context.read<CreateAppointmentBloc>().add(SelectDate(picked));
    }
  }

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
    throw Exception('Estado no válido para obtener servicio seleccionado');
  }

  DateTime _getSelectedDate(CreateAppointmentState state) {
    if (state is CreateAppointmentDateSelected) return state.selectedDate;
    if (state is CreateAppointmentAvailabilityLoaded) return state.selectedDate;
    if (state is CreateAppointmentTimeSlotSelected) return state.selectedDate;
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
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 24, 59, 27),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.confirmation_number,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 8),
                      const Text('Código de confirmación:'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    state.response.confirmationCode,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
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
