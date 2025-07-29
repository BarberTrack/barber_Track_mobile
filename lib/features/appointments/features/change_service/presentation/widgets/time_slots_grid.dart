import 'package:flutter/material.dart';
import '../../../create_appointment/domain/entities/availability.dart';
import '../../../create_appointment/domain/entities/time_slot.dart';

class TimeSlotsGrid extends StatefulWidget {
  final List<Availability> availability;
  final DateTime selectedDate;
  final Function(TimeSlot) onTimeSlotSelected;

  const TimeSlotsGrid({
    super.key,
    required this.availability,
    required this.selectedDate,
    required this.onTimeSlotSelected,
  });

  @override
  State<TimeSlotsGrid> createState() => _TimeSlotsGridState();
}

class _TimeSlotsGridState extends State<TimeSlotsGrid> {
  TimeSlot? selectedTimeSlot;

  @override
  Widget build(BuildContext context) {
    final availableTimeSlots = _getAvailableTimeSlots();

    if (availableTimeSlots.isEmpty) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.event_busy_rounded,
                size: 48,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No hay horarios disponibles',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Intenta seleccionar otra fecha',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.schedule_rounded,
                    color: Colors.blueAccent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Horarios disponibles',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: availableTimeSlots.length,
              itemBuilder: (context, index) {
                final timeSlot = availableTimeSlots[index];
                final isSelected =
                    selectedTimeSlot?.time == timeSlot.time &&
                    selectedTimeSlot?.barberId == timeSlot.barberId;

                return _buildTimeSlotCard(timeSlot, isSelected);
              },
            ),
            if (selectedTimeSlot != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.green.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Horario seleccionado: ${selectedTimeSlot!.time}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotCard(TimeSlot timeSlot, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedTimeSlot = timeSlot;
        });
        widget.onTimeSlotSelected(timeSlot);
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent : Colors.grey.shade500,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Colors.blueAccent.shade700
                : Colors.grey.shade600,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            timeSlot.time,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isSelected ? Colors.white : Colors.grey.shade200,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  List<TimeSlot> _getAvailableTimeSlots() {
    final now = DateTime.now();
    final currentTime = TimeOfDay.now();
    final selectedDateOnly = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
    );
    final todayOnly = DateTime(now.year, now.month, now.day);
    final isToday = selectedDateOnly.isAtSameMomentAs(todayOnly);

    List<TimeSlot> allTimeSlots = [];

    for (final availability in widget.availability) {
      final availabilityDate = DateTime.parse(availability.date);
      final availabilityDateOnly = DateTime(
        availabilityDate.year,
        availabilityDate.month,
        availabilityDate.day,
      );

      if (availabilityDateOnly.isAtSameMomentAs(selectedDateOnly)) {
        final availableSlots = availability.slots
            .where((slot) => slot.available)
            .toList();
        allTimeSlots.addAll(availableSlots);
      }
    }

    if (isToday) {
      final currentMinutes = currentTime.hour * 60 + currentTime.minute;
      const marginMinutes = 30; 

      allTimeSlots = allTimeSlots.where((timeSlot) {
        final timeParts = timeSlot.time.split(':');
        final slotHour = int.parse(timeParts[0]);
        final slotMinute = int.parse(timeParts[1]);
        final slotMinutes = slotHour * 60 + slotMinute;

        return slotMinutes > (currentMinutes + marginMinutes);
      }).toList();
    }

    return allTimeSlots;
  }
}
