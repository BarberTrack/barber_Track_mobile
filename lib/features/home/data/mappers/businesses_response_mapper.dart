import '../models/businesses_response_model.dart';
import '../../domain/entities/businesses_response.dart';
import 'business_mapper.dart';

class BusinessesResponseMapper {
  static BusinessesResponse modelToEntity(BusinessesResponseModel model) {
    return BusinessesResponse(
      businesses: BusinessMapper.modelListToEntityList(model.businesses),
      total: model.total,
      page: model.page,
      totalPages: model.totalPages,
    );
  }
}
