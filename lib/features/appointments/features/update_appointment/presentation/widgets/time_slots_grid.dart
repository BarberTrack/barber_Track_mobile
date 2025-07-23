import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/availability.dart';

class TimeSlotsGrid extends StatelessWidget {
  final List<Availability> availability;
  final Function(TimeSlot, DateTime) onTimeSlotSelected;

  const TimeSlotsGrid({
    super.key,
    required this.availability,
    required this.onTimeSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (availability.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: availability.map((dayAvailability) {
        return _buildDaySection(context, dayAvailability);
      }).toList(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.schedule_rounded, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No hay horarios disponibles',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Selecciona otra fecha para ver más opciones',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDaySection(BuildContext context, Availability dayAvailability) {
    final theme = Theme.of(context);
    final date = DateTime.parse(dayAvailability.date);
    final availableSlots = _filterAvailableSlots(dayAvailability.slots, date);

    if (availableSlots.isEmpty) {
      return Container();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del día
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green.withOpacity(0.1),
                  Colors.green.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.green.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.calendar_today_rounded,
                    size: 16,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  _formatDayHeader(date),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${availableSlots.length} disponibles',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Grid de horarios
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: availableSlots.map((slot) {
              return _buildTimeSlotChip(context, slot, date);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotChip(
    BuildContext context,
    TimeSlot slot,
    DateTime date,
  ) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: slot.available ? () => onTimeSlotSelected(slot, date) : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: slot.available
                ? LinearGradient(
                    colors: [
                      Colors.blue.withOpacity(0.1),
                      Colors.blue.withOpacity(0.05),
                    ],
                  )
                : LinearGradient(
                    colors: [
                      Colors.grey.withOpacity(0.1),
                      Colors.grey.withOpacity(0.05),
                    ],
                  ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: slot.available
                  ? Colors.blue.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                slot.available
                    ? Icons.access_time_rounded
                    : Icons.block_rounded,
                size: 16,
                color: slot.available
                    ? Colors.blue.shade600
                    : Colors.grey.shade400,
              ),
              const SizedBox(width: 8),
              Text(
                slot.time,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: slot.available
                      ? Colors.blue.shade700
                      : Colors.grey.shade400,
                ),
              ),
              if (!slot.available && slot.blockReason != null) ...[
                const SizedBox(width: 8),
                Tooltip(
                  message: slot.blockReason!,
                  child: Icon(
                    Icons.info_outline_rounded,
                    size: 14,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<TimeSlot> _filterAvailableSlots(List<TimeSlot> slots, DateTime date) {
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    if (!isToday) {
      // Si no es hoy, mostrar todos los horarios disponibles
      return slots.where((slot) => slot.available).toList();
    }

    // Si es hoy, filtrar horarios que ya pasaron con margen de 30 minutos
    final currentTime = TimeOfDay.fromDateTime(now);
    final marginTime = TimeOfDay(
      hour: currentTime.hour,
      minute: currentTime.minute + 30,
    );

    return slots.where((slot) {
      if (!slot.available) return false;

      final slotTimeParts = slot.time.split(':');
      final slotHour = int.parse(slotTimeParts[0]);
      final slotMinute = int.parse(slotTimeParts[1]);
      final slotTime = TimeOfDay(hour: slotHour, minute: slotMinute);

      // Convertir a minutos para comparar fácilmente
      final slotMinutes = slotTime.hour * 60 + slotTime.minute;
      final marginMinutes = marginTime.hour * 60 + marginTime.minute;

      return slotMinutes >= marginMinutes;
    }).toList();
  }

  String _formatDayHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final checkDate = DateTime(date.year, date.month, date.day);

    if (checkDate == today) {
      return 'Hoy, ${DateFormat('dd/MM').format(date)}';
    } else if (checkDate == tomorrow) {
      return 'Mañana, ${DateFormat('dd/MM').format(date)}';
    } else {
      return '${DateFormat('EEEE dd/MM', 'es').format(date)}';
    }
  }
}
