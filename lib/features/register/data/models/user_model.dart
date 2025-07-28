import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.phone,
    required super.firstName,
    required super.lastName,
    super.profileImageUrl,
    super.location,
    required super.notificationPreferences,
    required super.behaviorPatterns,
    required super.createdAt,
    required super.emailVerified,
    required super.phoneVerified,
    required super.authProvider,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      location: json['location'] as String?,
      notificationPreferences: NotificationPreferencesModel.fromJson(
        json['notificationPreferences'] as Map<String, dynamic>,
      ),
      behaviorPatterns: BehaviorPatternsModel.fromJson(
        json['behaviorPatterns'] as Map<String, dynamic>,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      emailVerified: json['emailVerified'] as bool,
      phoneVerified: json['phoneVerified'] as bool,
      authProvider: json['authProvider'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'firstName': firstName,
      'lastName': lastName,
      'profileImageUrl': profileImageUrl,
      'location': location,
      'notificationPreferences':
          (notificationPreferences as NotificationPreferencesModel).toJson(),
      'behaviorPatterns': (behaviorPatterns as BehaviorPatternsModel).toJson(),
      'createdAt': createdAt.toIso8601String(),
      'emailVerified': emailVerified,
      'phoneVerified': phoneVerified,
      'authProvider': authProvider,
    };
  }
}

class NotificationPreferencesModel extends NotificationPreferences {
  const NotificationPreferencesModel({
    required super.push,
    required super.email,
  });

  factory NotificationPreferencesModel.fromJson(Map<String, dynamic> json) {
    return NotificationPreferencesModel(
      push: PushNotificationsModel.fromJson(
        json['push'] as Map<String, dynamic>,
      ),
      email: EmailNotificationsModel.fromJson(
        json['email'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'push': (push as PushNotificationsModel).toJson(),
      'email': (email as EmailNotificationsModel).toJson(),
    };
  }
}

class PushNotificationsModel extends PushNotifications {
  const PushNotificationsModel({
    required super.reminders,
    required super.promotions,
    required super.appointments,
  });

  factory PushNotificationsModel.fromJson(Map<String, dynamic> json) {
    return PushNotificationsModel(
      reminders: json['reminders'] as bool,
      promotions: json['promotions'] as bool,
      appointments: json['appointments'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reminders': reminders,
      'promotions': promotions,
      'appointments': appointments,
    };
  }
}

class EmailNotificationsModel extends EmailNotifications {
  const EmailNotificationsModel({
    required super.reminders,
    required super.promotions,
    required super.appointments,
  });

  factory EmailNotificationsModel.fromJson(Map<String, dynamic> json) {
    return EmailNotificationsModel(
      reminders: json['reminders'] as bool,
      promotions: json['promotions'] as bool,
      appointments: json['appointments'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reminders': reminders,
      'promotions': promotions,
      'appointments': appointments,
    };
  }
}

class BehaviorPatternsModel extends BehaviorPatterns {
  const BehaviorPatternsModel({
    required super.loginPatterns,
    required super.bookingPatterns,
    required super.engagementPatterns,
  });

  factory BehaviorPatternsModel.fromJson(Map<String, dynamic> json) {
    return BehaviorPatternsModel(
      loginPatterns: LoginPatternsModel.fromJson(
        json['login_patterns'] as Map<String, dynamic>,
      ),
      bookingPatterns: BookingPatternsModel.fromJson(
        json['booking_patterns'] as Map<String, dynamic>,
      ),
      engagementPatterns: EngagementPatternsModel.fromJson(
        json['engagement_patterns'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'login_patterns': (loginPatterns as LoginPatternsModel).toJson(),
      'booking_patterns': (bookingPatterns as BookingPatternsModel).toJson(),
      'engagement_patterns': (engagementPatterns as EngagementPatternsModel)
          .toJson(),
    };
  }
}

class LoginPatternsModel extends LoginPatterns {
  const LoginPatternsModel({
    required super.deviceTypes,
    required super.preferredDays,
    required super.preferredHours,
    required super.locationPatterns,
  });

  factory LoginPatternsModel.fromJson(Map<String, dynamic> json) {
    return LoginPatternsModel(
      deviceTypes: List<String>.from(json['device_types'] as List),
      preferredDays: List<String>.from(json['preferred_days'] as List),
      preferredHours: List<String>.from(json['preferred_hours'] as List),
      locationPatterns: List<String>.from(json['location_patterns'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'device_types': deviceTypes,
      'preferred_days': preferredDays,
      'preferred_hours': preferredHours,
      'location_patterns': locationPatterns,
    };
  }
}

class BookingPatternsModel extends BookingPatterns {
  const BookingPatternsModel({
    required super.priceSensitivity,
    required super.seasonalPreferences,
    required super.averageAdvanceBooking,
    required super.preferredAppointmentDuration,
  });

  factory BookingPatternsModel.fromJson(Map<String, dynamic> json) {
    return BookingPatternsModel(
      priceSensitivity: json['price_sensitivity'] as String,
      seasonalPreferences: json['seasonal_preferences'] as String,
      averageAdvanceBooking: json['average_advance_booking'] as int,
      preferredAppointmentDuration:
          json['preferred_appointment_duration'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price_sensitivity': priceSensitivity,
      'seasonal_preferences': seasonalPreferences,
      'average_advance_booking': averageAdvanceBooking,
      'preferred_appointment_duration': preferredAppointmentDuration,
    };
  }
}

class EngagementPatternsModel extends EngagementPatterns {
  const EngagementPatternsModel({
    required super.churnRisk,
    required super.loyaltyScore,
    required super.reviewFrequency,
    required super.referralLikelihood,
  });

  factory EngagementPatternsModel.fromJson(Map<String, dynamic> json) {
    return EngagementPatternsModel(
      churnRisk: (json['churn_risk'] as num).toDouble(),
      loyaltyScore: json['loyalty_score'] as int,
      reviewFrequency: (json['review_frequency'] as num).toDouble(),
      referralLikelihood: (json['referral_likelihood'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'churn_risk': churnRisk,
      'loyalty_score': loyaltyScore,
      'review_frequency': reviewFrequency,
      'referral_likelihood': referralLikelihood,
    };
  }
}
