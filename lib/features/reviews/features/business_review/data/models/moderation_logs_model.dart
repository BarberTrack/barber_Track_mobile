class ModerationLogsModel {
  final ModerationModel? moderation;

  ModerationLogsModel({this.moderation});

  factory ModerationLogsModel.fromJson(Map<String, dynamic> json) {
    return ModerationLogsModel(
      moderation: json['moderation'] != null
          ? ModerationModel.fromJson(json['moderation'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'moderation': moderation?.toJson()};
  }
}

class ModerationModel {
  final String action;
  final String reason;

  ModerationModel({required this.action, required this.reason});

  factory ModerationModel.fromJson(Map<String, dynamic> json) {
    return ModerationModel(
      action: json['action'] ?? '',
      reason: json['reason'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'action': action, 'reason': reason};
  }
}
