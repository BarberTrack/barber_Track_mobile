import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/create_appointment_bloc.dart';
import '../../domain/entities/time_slot.dart';
import '../../domain/entities/availability.dart';
import '../../domain/entities/service.dart';

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
              final filteredSlots = _filterSlotsByCurrentTime(
                dayAvailability.slots,
                dayAvailability.date,
              );

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

                  if (filteredSlots.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: filteredSlots
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
                            _isToday(dayAvailability.date)
                                ? 'No hay horarios disponibles para hoy'
                                : 'Todos los horarios están ocupados',
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

  List<TimeSlot> _filterSlotsByCurrentTime(
    List<TimeSlot> slots,
    String slotDate,
  ) {
    try {
      final now = DateTime.now();
      final slotDateTime = DateTime.parse(slotDate);

      // Si no es el día actual, no aplicar filtros adicionales
      if (!_isSameDay(now, slotDateTime)) {
        return slots;
      }

      final currentTimeWithMargin = now.add(const Duration(minutes: 30));

      // Filtrar slots anteriores a la hora actual + 30 minutos
      List<TimeSlot> filteredByTime = slots.where((slot) {
        final slotTime = _parseTimeSlot(slot.time, slotDateTime);
        return slotTime.isAfter(currentTimeWithMargin);
      }).toList();

      // Solo para la fecha actual, aplicar validación de duración del servicio
      if (_isToday(slotDate)) {
        filteredByTime = _filterSlotsByServiceDuration(
          filteredByTime,
          slotDateTime,
        );
      }

      return filteredByTime;
    } catch (e) {
      return slots;
    }
  }

  List<TimeSlot> _filterSlotsByServiceDuration(
    List<TimeSlot> slots,
    DateTime slotDate,
  ) {
    try {
      // Obtener el servicio seleccionado
      final selectedService = _getSelectedService();
      if (selectedService == null) {
        // Si no hay servicio seleccionado, mantener comportamiento actual
        return slots;
      }

      // Si no hay slots disponibles, retornar lista vacía
      if (slots.isEmpty) {
        return slots;
      }

      // Encontrar el último slot disponible del día
      final lastAvailableSlot = _findLastAvailableSlot(slots);
      if (lastAvailableSlot == null) {
        return slots;
      }

      // Calcular el tiempo de fin del último slot disponible
      final lastSlotTime = _parseTimeSlot(lastAvailableSlot.time, slotDate);

      // Filtrar slots que no permitan completar el servicio antes del cierre
      return slots.where((slot) {
        final slotStartTime = _parseTimeSlot(slot.time, slotDate);
        final serviceEndTime = slotStartTime.add(
          Duration(minutes: selectedService.durationMinutes),
        );

        // El servicio debe terminar antes o igual al tiempo del último slot disponible
        return serviceEndTime.isBefore(
              lastSlotTime.add(const Duration(minutes: 30)),
            ) ||
            serviceEndTime.isAtSameMomentAs(
              lastSlotTime.add(const Duration(minutes: 30)),
            );
      }).toList();
    } catch (e) {
      // En caso de error, mantener la lista original
      return slots;
    }
  }

  TimeSlot? _findLastAvailableSlot(List<TimeSlot> slots) {
    // Filtrar solo slots disponibles y encontrar el último por tiempo
    final availableSlots = slots.where((slot) => slot.available).toList();
    if (availableSlots.isEmpty) {
      return null;
    }

    // Ordenar por tiempo y tomar el último
    availableSlots.sort((a, b) {
      final timeA = a.time.replaceAll(':', '');
      final timeB = b.time.replaceAll(':', '');
      return timeA.compareTo(timeB);
    });

    return availableSlots.last;
  }

  Service? _getSelectedService() {
    try {
      if (state is CreateAppointmentServiceSelected) {
        return (state as CreateAppointmentServiceSelected).selectedService;
      }
      if (state is CreateAppointmentDateSelected) {
        return (state as CreateAppointmentDateSelected).selectedService;
      }
      if (state is CreateAppointmentAvailabilityLoaded) {
        return (state as CreateAppointmentAvailabilityLoaded).selectedService;
      }
      if (state is CreateAppointmentTimeSlotSelected) {
        return (state as CreateAppointmentTimeSlotSelected).selectedService;
      }
      if (state is CreateAppointmentWithNotes) {
        return (state as CreateAppointmentWithNotes).selectedService;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  bool _isToday(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      return _isSameDay(now, date);
    } catch (e) {
      return false;
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  DateTime _parseTimeSlot(String timeString, DateTime date) {
    final timeParts = timeString.split(':');
    if (timeParts.length >= 2) {
      final hour = int.tryParse(timeParts[0]) ?? 0;
      final minute = int.tryParse(timeParts[1]) ?? 0;
      return DateTime(date.year, date.month, date.day, hour, minute);
    }
    return date;
  }

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
          final selectedDateTime = _createDateTimeFromSlot(slotDate, slot.time);

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
