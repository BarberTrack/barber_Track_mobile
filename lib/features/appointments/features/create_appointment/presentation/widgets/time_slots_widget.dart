import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/create_appointment_bloc.dart';
import '../../domain/entities/time_slot.dart';
import '../../domain/entities/availability.dart';

class TimeSlotsWidget extends StatelessWidget {
  final List<Availability> availability;
  final CreateAppointmentState state;

  const TimeSlotsWidget({
    super.key,
    required this.availability,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
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
                            (slot) => _TimeSlotChip(
                              slot: slot,
                              state: state,
                              slotDate: dayAvailability.date,
                            ),
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
                            'Todos los horarios están libres',
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

class _TimeSlotChip extends StatelessWidget {
  final TimeSlot slot;
  final CreateAppointmentState state;
  final String slotDate;

  const _TimeSlotChip({
    required this.slot,
    required this.state,
    required this.slotDate,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected =
        state is CreateAppointmentTimeSlotSelected &&
        (state as CreateAppointmentTimeSlotSelected).selectedTimeSlot.time ==
            slot.time &&
        _isSameDate(
          (state as CreateAppointmentTimeSlotSelected).selectedDate,
          slotDate,
        );

    return ChoiceChip(
      label: Text(slot.time),
      selected: isSelected,
      selectedColor: const Color.fromARGB(255, 66, 135, 190),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      onSelected: (selected) {
        if (selected) {
          // Crear una nueva fecha combinando el día del slot con la hora seleccionada
          final selectedDateTime = _createDateTimeFromSlot(slotDate, slot.time);

          // Usar el nuevo evento que maneja tanto el time slot como la fecha específica
          context.read<CreateAppointmentBloc>().add(
            SelectTimeSlotWithDate(
              timeSlot: slot,
              selectedDate: selectedDateTime,
            ),
          );
        }
      },
    );
  }

  DateTime _createDateTimeFromSlot(String dateString, String timeString) {
    try {
      final date = DateTime.parse(dateString);
      final timeParts = timeString.split(':');

      if (timeParts.length >= 2) {
        final hour = int.tryParse(timeParts[0]) ?? 0;
        final minute = int.tryParse(timeParts[1]) ?? 0;

        return DateTime(date.year, date.month, date.day, hour, minute);
      }

      return date;
    } catch (e) {
      // En caso de error, devolver la fecha actual
      return DateTime.now();
    }
  }

  bool _isSameDate(DateTime selectedDate, String slotDateString) {
    try {
      final slotDate = DateTime.parse(slotDateString);
      return selectedDate.year == slotDate.year &&
          selectedDate.month == slotDate.month &&
          selectedDate.day == slotDate.day;
    } catch (e) {
      return false;
    }
  }
}
