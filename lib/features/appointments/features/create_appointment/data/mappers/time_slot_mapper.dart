import '../models/time_slot_model.dart';
import '../../domain/entities/time_slot.dart';

class TimeSlotMapper {
  static TimeSlot modelToEntity(TimeSlotModel model) {
    return TimeSlot(
      time: model.time,
      available: model.available,
      barberId: model.barberId,
      barberName: model.barberName,
      duration: model.duration,
    );
  }

  static List<TimeSlot> modelsToEntities(List<TimeSlotModel> models) {
    return models.map((model) => modelToEntity(model)).toList();
  }
}
