import '../models/barber_assignment_model.dart';
import '../../domain/entities/barber_assignment.dart';

class BarberAssignmentMapper {
  static BarberAssignment modelToEntity(BarberAssignmentModel model) {
    return BarberAssignment(
      barberId: model.barberId,
      isPreferred: model.isPreferred,
      specialPrice: model.specialPrice,
    );
  }

  static List<BarberAssignment> modelsToEntities(
    List<BarberAssignmentModel> models,
  ) {
    return models.map((model) => modelToEntity(model)).toList();
  }
}
