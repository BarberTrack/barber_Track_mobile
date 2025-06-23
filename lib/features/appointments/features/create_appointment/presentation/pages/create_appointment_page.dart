import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/di/injection.dart';
import '../bloc/create_appointment_bloc.dart';
import '../../domain/entities/service.dart';
import '../../domain/entities/time_slot.dart';

class CreateAppointmentPage extends StatelessWidget {
  final String businessId;

  const CreateAppointmentPage({super.key, required this.businessId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<CreateAppointmentBloc>()..add(LoadBusinessServices(businessId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Crear Cita'),
          centerTitle: true,
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
        ),
        body: BlocBuilder<CreateAppointmentBloc, CreateAppointmentState>(
          builder: (context, state) {
            if (state is CreateAppointmentLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CreateAppointmentError) {
              return _buildErrorView(context, state.message);
            } else if (state is CreateAppointmentServicesLoaded) {
              return _buildServicesView(context, state);
            } else if (state is CreateAppointmentServiceSelected ||
                state is CreateAppointmentDateSelected ||
                state is CreateAppointmentAvailabilityLoaded ||
                state is CreateAppointmentTimeSlotSelected) {
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
                LoadBusinessServices(businessId),
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
                            'No hay horarios disponibles este día',
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
        if (selected) {
          context.read<CreateAppointmentBloc>().add(SelectTimeSlot(slot));
        }
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
                  // TODO: Implementar creación de cita
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Funcionalidad de crear cita en desarrollo',
                      ),
                    ),
                  );
                },
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
              Text('Business ID: $businessId'),
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
                Text(
                  'Date: ${DateFormat('yyyy-MM-dd').format(_getSelectedDate(state))}',
                ),
                const SizedBox(height: 8),
              ],
              Text('Estado actual: ${state.runtimeType}'),
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
}
