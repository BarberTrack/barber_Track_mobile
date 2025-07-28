abstract class User {
  final String id;
  final String email;
  final String phone;
  final String firstName;
  final String lastName;
  final String? profileImageUrl;
  final String? location;
  final NotificationPreferences notificationPreferences;
  final BehaviorPatterns behaviorPatterns;
  final DateTime createdAt;
  final bool emailVerified;
  final bool phoneVerified;
  final String authProvider;

  const User({
    required this.id,
    required this.email,
    required this.phone,
    required this.firstName,
    required this.lastName,
    this.profileImageUrl,
    this.location,
    required this.notificationPreferences,
    required this.behaviorPatterns,
    required this.createdAt,
    required this.emailVerified,
    required this.phoneVerified,
    required this.authProvider,
  });
}

abstract class NotificationPreferences {
  final PushNotifications push;
  final EmailNotifications email;

  const NotificationPreferences({required this.push, required this.email});
}

abstract class PushNotifications {
  final bool reminders;
  final bool promotions;
  final bool appointments;

  const PushNotifications({
    required this.reminders,
    required this.promotions,
    required this.appointments,
  });
}

abstract class EmailNotifications {
  final bool reminders;
  final bool promotions;
  final bool appointments;

  const EmailNotifications({
    required this.reminders,
    required this.promotions,
    required this.appointments,
  });
}

abstract class BehaviorPatterns {
  final LoginPatterns loginPatterns;
  final BookingPatterns bookingPatterns;
  final EngagementPatterns engagementPatterns;

  const BehaviorPatterns({
    required this.loginPatterns,
    required this.bookingPatterns,
    required this.engagementPatterns,
  });
}

abstract class LoginPatterns {
  final List<String> deviceTypes;
  final List<String> preferredDays;
  final List<String> preferredHours;
  final List<String> locationPatterns;

  const LoginPatterns({
    required this.deviceTypes,
    required this.preferredDays,
    required this.preferredHours,
    required this.locationPatterns,
  });
}

abstract class BookingPatterns {
  final String priceSensitivity;
  final String seasonalPreferences;
  final int averageAdvanceBooking;
  final int preferredAppointmentDuration;

  const BookingPatterns({
    required this.priceSensitivity,
    required this.seasonalPreferences,
    required this.averageAdvanceBooking,
    required this.preferredAppointmentDuration,
  });
}

abstract class EngagementPatterns {
  final double churnRisk;
  final int loyaltyScore;
  final double reviewFrequency;
  final double referralLikelihood;

  const EngagementPatterns({
    required this.churnRisk,
    required this.loyaltyScore,
    required this.reviewFrequency,
    required this.referralLikelihood,
  });
}
