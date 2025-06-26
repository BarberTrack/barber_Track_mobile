import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/create_appointment_bloc.dart';
import '../../domain/entities/service.dart';

class DateSummary extends StatelessWidget {
  final DateTime date;
  final String businessId;

  const DateSummary({super.key, required this.date, required this.businessId});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green.shade600),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Fecha de búsqueda: ${DateFormat('dd/MM/yyyy').format(date)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            BlocBuilder<CreateAppointmentBloc, CreateAppointmentState>(
              builder: (context, state) {
                final isLoading = state is CreateAppointmentLoading;

                return IconButton(
                  onPressed: isLoading ? null : () => _selectDate(context),
                  icon: isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.blue.shade600,
                          ),
                        )
                      : Icon(Icons.edit_calendar, color: Colors.blue.shade600),
                  tooltip: isLoading
                      ? 'Cargando nueva disponibilidad...'
                      : 'Cambiar fecha de búsqueda',
                );
              },
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
      final bloc = context.read<CreateAppointmentBloc>();
      final currentState = bloc.state;

      // Actualizar la fecha seleccionada
      bloc.add(SelectDate(picked));

      // Si hay un servicio seleccionado, cargar automáticamente la disponibilidad para la nueva fecha
      if (currentState is CreateAppointmentServiceSelected ||
          currentState is CreateAppointmentDateSelected ||
          currentState is CreateAppointmentAvailabilityLoaded ||
          currentState is CreateAppointmentTimeSlotSelected ||
          currentState is CreateAppointmentWithNotes) {
        final service = _getSelectedService(currentState);

        // Obtener el primer barbero del servicio seleccionado
        if (service.barberAssignments.isNotEmpty) {
          final barberId = service.barberAssignments.first.barberId;
          final dateString = DateFormat('yyyy-MM-dd').format(picked);

          // Cargar la disponibilidad para la nueva fecha
          bloc.add(
            LoadAvailability(
              businessId: businessId,
              barberId: barberId,
              date: dateString,
              days: 3,
            ),
          );
        }
      }
    }
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
}
