import '../../domain/entities/availability.dart';
import '../models/availability_model.dart';

class AvailabilityMapper {
  static List<Availability> modelsToEntities(List<AvailabilityModel> models) {
    return models.map((model) => modelToEntity(model)).toList();
  }

  static Availability modelToEntity(AvailabilityModel model) {
    return Availability(
      date: model.date,
      slots: model.slots.map((slot) => _timeSlotModelToEntity(slot)).toList(),
    );
  }

  static TimeSlot _timeSlotModelToEntity(TimeSlotModel model) {
    return TimeSlot(
      time: model.time,
      available: model.available,
      barberId: model.barberId,
      barberName: model.barberName,
      duration: model.duration,
      blockReason: model.blockReason,
    );
  }
}
