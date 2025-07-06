import '../../domain/entities/service.dart';
import '../../domain/entities/business_services_response.dart';
import '../models/service_model.dart';
import '../models/business_services_response_model.dart';

class BusinessServicesMapper {
  static Service serviceModelToEntity(ServiceModel model) {
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
          .map((assignment) => _barberAssignmentModelToEntity(assignment))
          .toList(),
      createdAt: DateTime.tryParse(model.createdAt) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(model.updatedAt) ?? DateTime.now(),
    );
  }

  static BarberAssignment _barberAssignmentModelToEntity(
    BarberAssignmentModel model,
  ) {
    return BarberAssignment(
      barberId: model.barberId,
      isPreferred: model.isPreferred,
      specialPrice: model.specialPrice,
      firstName: model.firstName,
      lastName: model.lastName,
    );
  }

  static BusinessServicesResponse responseModelToEntity(
    BusinessServicesResponseModel model,
  ) {
    return BusinessServicesResponse(
      services: model.data.services
          .map((service) => serviceModelToEntity(service))
          .toList(),
      packages: model.data.packages,
    );
  }
}
