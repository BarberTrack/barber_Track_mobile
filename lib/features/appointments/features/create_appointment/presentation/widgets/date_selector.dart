import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/create_appointment_bloc.dart';
import '../../domain/entities/service.dart';

class DateSelector extends StatelessWidget {
  const DateSelector({super.key});

  @override
  Widget build(BuildContext context) {
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
              businessId: _getBusinessId(currentState),
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

  String _getBusinessId(CreateAppointmentState state) {
    if (state is CreateAppointmentServiceSelected) return state.businessId;
    if (state is CreateAppointmentDateSelected) return state.businessId;
    if (state is CreateAppointmentAvailabilityLoaded) return state.businessId;
    if (state is CreateAppointmentTimeSlotSelected) return state.businessId;
    if (state is CreateAppointmentWithNotes) return state.businessId;
    throw Exception('Estado no válido para obtener business ID');
  }
}
