import 'package:flutter/material.dart';
import '../../domain/entities/availability.dart';

class TimeSlotsWidget extends StatelessWidget {
  final AvailabilityResponse availability;
  final DateTime selectedDate;
  final TimeSlot? selectedTimeSlot;
  final Function(TimeSlot) onTimeSlotSelected;

  const TimeSlotsWidget({
    super.key,
    required this.availability,
    required this.selectedDate,
    required this.onTimeSlotSelected,
    this.selectedTimeSlot,
  });

  @override
  Widget build(BuildContext context) {
    if (availability.availability.isEmpty) {
      return _buildNoAvailabilityCard(context);
    }

    final widgets = availability.availability
        .map((barberAvailability) {
          return _buildBarberAvailabilityCard(context, barberAvailability);
        })
        .where(
          (widget) => widget is! SizedBox || (widget as SizedBox).height != 0,
        )
        .toList();

    if (widgets.isEmpty) {
      return Column(children: [_buildNoAvailabilityForDateCard(context)]);
    }

    return Column(children: widgets);
  }

  /// Busca el schedule correspondiente a la fecha seleccionada
  /// Maneja diferentes formatos de fecha y comparaciones robustas
  DaySchedule? _findScheduleForDate(List<DaySchedule> schedules) {
    if (schedules.isEmpty) {
      return null;
    }

    final targetDateString = selectedDate.toIso8601String().split('T')[0];

    // Intento 1: Búsqueda por string exacto
    for (var schedule in schedules) {
      if (schedule.date == targetDateString) {
        return schedule;
      }
    }

    // Intento 2: Comparación de fechas parseadas (más robusto)
    try {
      final targetDate = DateTime.parse(targetDateString);

      for (var schedule in schedules) {
        try {
          final scheduleDate = DateTime.parse(schedule.date);
          if (_isSameDay(targetDate, scheduleDate)) {
            return schedule;
          }
        } catch (e) {
          // Si no se puede parsear esta fecha del schedule, continúa con la siguiente
          continue;
        }
      }
    } catch (e) {
      // Si no se puede parsear la fecha objetivo, intentar con comparación de strings
    }

    return null;
  }

  /// Compara si dos fechas son el mismo día
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Widget _buildNoAvailabilityCard(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Sin horarios disponibles',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No hay horarios disponibles para la fecha seleccionada. Intenta con otra fecha.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoAvailabilityForDateCard(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(
              Icons.access_time_filled,
              size: 48,
              color: Colors.orange.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Sin coincidencias de fecha',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No se encontraron horarios para la fecha específica seleccionada. Los datos están disponibles pero para otras fechas.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarberAvailabilityCard(
    BuildContext context,
    BarberAvailability barberAvailability,
  ) {
    // Buscar el schedule para la fecha seleccionada
    final daySchedule = _findScheduleForDate(barberAvailability.schedule);

    if (daySchedule == null) {
      return const SizedBox.shrink();
    }

    if (daySchedule.availableSlots.isEmpty) {
      return const SizedBox.shrink();
    }

    // Filtrar solo los slots disponibles
    final availableSlots = daySchedule.availableSlots
        .where((slot) => slot.available)
        .toList();

    if (availableSlots.isEmpty) {
      return _buildNoSlotsForBarberCard(context, barberAvailability.barberName);
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con información del barbero
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.blue.shade700,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        barberAvailability.barberName,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${availableSlots.length} horarios disponibles',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade100,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Grid de horarios
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: availableSlots.map((slot) {
                final isSelected =
                    selectedTimeSlot?.time == slot.time &&
                    selectedTimeSlot?.barberId == slot.barberId;
                return _buildTimeSlotChip(context, slot, isSelected);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoSlotsForBarberCard(BuildContext context, String barberName) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.person, color: Colors.grey.shade400, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    barberName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    'Sin horarios disponibles',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotChip(
    BuildContext context,
    TimeSlot slot,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () => onTimeSlotSelected(slot),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade600 : Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue.shade600 : Colors.blue.shade200,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.blue.shade200,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.access_time,
              size: 16,
              color: isSelected ? Colors.white : Colors.blue.shade700,
            ),
            const SizedBox(width: 6),
            Text(
              slot.time,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.blue.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
