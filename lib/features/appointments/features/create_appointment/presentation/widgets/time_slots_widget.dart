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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade800, Colors.grey.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade600, Colors.green.shade800],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.access_time,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Horarios disponibles',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Selecciona el horario que prefieras',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            
            ...availability.map((dayAvailability) {
              final filteredSlots = _filterSlotsByCurrentTime(
                dayAvailability.slots,
                dayAvailability.date,
              );

              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade800,
                              Colors.blue.shade900,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue.shade600,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: Colors.blue.shade300,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _formatDateForDisplay(dayAvailability.date),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade200,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      if (filteredSlots.isNotEmpty) ...[
                        
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final availableSlots = filteredSlots
                                .where((slot) => slot.available)
                                .toList();

                            if (availableSlots.isEmpty) {
                              return _buildNoSlotsMessage();
                            }

                            return Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: availableSlots.map((slot) {
                                return SizedBox(
                                  width:
                                      (constraints.maxWidth - 16) /
                                      3, 
                                  child: _TimeSlotChip(
                                    slot: slot,
                                    state: state,
                                    slotDate: dayAvailability.date,
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ] else ...[
                        _buildNoSlotsMessage(),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildNoSlotsMessage() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange.shade900.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade600, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange.shade300, size: 24),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'No hay horarios disponibles',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
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

      
      if (!_isSameDay(now, slotDateTime)) {
        return slots;
      }

      final currentTimeWithMargin = now.add(const Duration(minutes: 30));

      
      List<TimeSlot> filteredByTime = slots.where((slot) {
        final slotTime = _parseTimeSlot(slot.time, slotDateTime);
        return slotTime.isAfter(currentTimeWithMargin);
      }).toList();

      
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
      
      final selectedService = _getSelectedService();
      if (selectedService == null) {
        
        return slots;
      }

      
      if (slots.isEmpty) {
        return slots;
      }


      final lastAvailableSlot = _findLastAvailableSlot(slots);
      if (lastAvailableSlot == null) {
        return slots;
      }

      
      final lastSlotTime = _parseTimeSlot(lastAvailableSlot.time, slotDate);

      
      return slots.where((slot) {
        final slotStartTime = _parseTimeSlot(slot.time, slotDate);
        final serviceEndTime = slotStartTime.add(
          Duration(minutes: selectedService.durationMinutes),
        );

        
        return serviceEndTime.isBefore(
              lastSlotTime.add(const Duration(minutes: 30)),
            ) ||
            serviceEndTime.isAtSameMomentAs(
              lastSlotTime.add(const Duration(minutes: 30)),
            );
      }).toList();
    } catch (e) {
      
      return slots;
    }
  }

  TimeSlot? _findLastAvailableSlot(List<TimeSlot> slots) {
    
    final availableSlots = slots.where((slot) => slot.available).toList();
    if (availableSlots.isEmpty) {
      return null;
    }

    
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

    return Container(
      height: 50, 
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(
                colors: [Colors.blue.shade600, Colors.blue.shade700],
              )
            : LinearGradient(
                colors: [Colors.grey.shade700, Colors.grey.shade800],
              ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
        border: Border.all(
          color: isSelected ? Colors.blue.shade300 : Colors.grey.shade500,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            final selectedDateTime = _createDateTimeFromSlot(
              slotDate,
              slot.time,
            );
            context.read<CreateAppointmentBloc>().add(
              SelectTimeSlotWithDate(
                timeSlot: slot,
                selectedDate: selectedDateTime,
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: isSelected ? Colors.white : Colors.grey.shade300,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    slot.time,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.grey.shade200,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
