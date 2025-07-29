import '../../domain/entities/availability.dart';
import '../models/availability_response_model.dart';

class AvailabilityMapper {
  static AvailabilityResponse toEntity(AvailabilityDataModel model) {
    // Extraer el barberId y barberName del primer slot (todos deben ser del mismo barbero)
    String? barberId;
    String? barberName;

    if (model.availability.isNotEmpty &&
        model.availability.first.slots.isNotEmpty) {
      barberId = model.availability.first.slots.first.barberId;
      barberName = model.availability.first.slots.first.barberName;
    }

    // Crear un BarberAvailability único con todos los schedules
    final barberAvailability = BarberAvailability(
      barberId: barberId ?? '',
      barberName: barberName ?? 'Barbero',
      schedule: model.availability
          .map((dayAvailability) => _toDayScheduleEntity(dayAvailability))
          .toList(),
    );

    return AvailabilityResponse(
      businessId: null, // No viene en el nuevo response
      availability: [barberAvailability],
    );
  }

  static DaySchedule _toDayScheduleEntity(DayAvailabilityModel model) {
    return DaySchedule(
      date: model.date,
      availableSlots: model.slots
          .map((slot) => _toTimeSlotEntity(slot))
          .toList(),
    );
  }

  static TimeSlot _toTimeSlotEntity(TimeSlotModel model) {
    return TimeSlot(
      time: model.time,
      available: model.available,
      barberId: model.barberId,
      barberName: model.barberName,
      duration: model.duration,
      appointmentDetails: null, // No viene en el nuevo response
      blockReason: model.blockReason,
    );
  }
}
