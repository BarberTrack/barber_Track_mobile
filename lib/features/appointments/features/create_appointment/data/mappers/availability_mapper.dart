import '../models/availability_model.dart';
import '../../domain/entities/availability.dart';
import 'time_slot_mapper.dart';

class AvailabilityMapper {
  static Availability modelToEntity(AvailabilityModel model) {
    return Availability(
      date: model.date,
      slots: model.slots
          .map((slot) => TimeSlotMapper.modelToEntity(slot))
          .toList(),
    );
  }

  static List<Availability> modelsToEntities(List<AvailabilityModel> models) {
    return models.map((model) => modelToEntity(model)).toList();
  }
}
