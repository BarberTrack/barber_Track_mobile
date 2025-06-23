import '../models/service_model.dart';
import '../../domain/entities/service.dart';
import 'barber_assignment_mapper.dart';

class ServiceMapper {
  static Service modelToEntity(ServiceModel model) {
    return Service(
      id: model.id,
      businessId: model.businessId,
      name: model.name,
      description: model.description,
      price: model.price,
      durationMinutes: model.durationMinutes,
      imageUrl: model.imageUrl,
      isActive: model.isActive,
      barberAssignments: model.barberAssignments
          .map((assignment) => BarberAssignmentMapper.modelToEntity(assignment))
          .toList(),
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  static List<Service> modelsToEntities(List<ServiceModel> models) {
    return models.map((model) => modelToEntity(model)).toList();
  }
}
