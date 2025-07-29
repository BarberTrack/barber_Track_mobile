import 'package:equatable/equatable.dart';
import '../../../appoinments_home/data/models/appointments_response_model.dart';

class ChangeServiceResponseModel extends Equatable {
  final bool success;
  final String message;
  final ChangeServiceDataModel data;

  const ChangeServiceResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ChangeServiceResponseModel.fromJson(Map<String, dynamic> json) {
    return ChangeServiceResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: ChangeServiceDataModel.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }

  @override
  List<Object> get props => [success, message, data];
}

class ChangeServiceDataModel extends Equatable {
  final AppointmentModel appointment;
  final bool updated;
  final Map<String, dynamic> changes;

  const ChangeServiceDataModel({
    required this.appointment,
    required this.updated,
    required this.changes,
  });

  factory ChangeServiceDataModel.fromJson(Map<String, dynamic> json) {
    return ChangeServiceDataModel(
      appointment: AppointmentModel.fromJson(
        json['appointment'] as Map<String, dynamic>,
      ),
      updated: json['updated'] as bool,
      changes: json['changes'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointment': appointment.toJson(),
      'updated': updated,
      'changes': changes,
    };
  }

  @override
  List<Object> get props => [appointment, updated, changes];
}
