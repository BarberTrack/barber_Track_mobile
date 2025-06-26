import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/create_appointment_bloc.dart';

class LoadAvailabilityButton extends StatelessWidget {
  final CreateAppointmentDateSelected state;

  const LoadAvailabilityButton({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
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
}
