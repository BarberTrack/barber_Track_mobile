import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/login/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/barberShops/features/barberDetails/presentation/pages/barber_details_page.dart';
import '../../features/appointments/features/create_appointment/presentation/pages/create_appointment_page.dart';
import '../../features/appointments/features/appoinments_home/presentation/pages/appointments_page.dart';
import '../../features/style_ai/features/style_ai_home/presentation/pages/style_ai_home_page.dart';
import '../../features/style_ai/features/analyze_face/presentation/pages/analyze_face_page.dart';
import '../../features/style_ai/features/analyze_reference/presentation/pages/analyze_reference_page.dart';
import '../../features/reviews/features/business_review/presentation/pages/business_review_page.dart';
import '../../features/reviews/features/create_review/presentation/pages/create_review_page.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';
import '../../features/barbers/features/barber_home/presentation/pages/barber_home_page.dart';
import '../../features/map/presentation/pages/map_page.dart';
import '../../features/repeat_appointment/presentation/pages/repeat_appointment_page.dart';
import '../../features/appointments/features/update_appointment/presentation/pages/update_appointment_page.dart';
import '../../features/appointments/features/appoinments_home/domain/entities/appointment.dart';

class AppRouter {
  static const String login = '/login';
  static const String home = '/home';
  static const String barberDetails = '/barber-details';
  static const String createAppointment = '/create-appointment';
  static const String appointments = '/appointments';
  static const String styleAi = '/style-ai';
  static const String analyzeFace = '/analyze-face';
  static const String analyzeReference = '/analyze-reference';
  static const String businessReviews = '/business-reviews';
  static const String createReview = '/create-review';
  static const String favorites = '/favorites';
  static const String barberHome = '/barber-home';
  static const String map = '/map';
  static const String repeatAppointment = '/repeat-appointment';
  static const String updateAppointment = '/update-appointment';

  static final GoRouter router = GoRouter(
    initialLocation: login,
    routes: [
      GoRoute(
        path: login,
        name: 'login',
        builder: (BuildContext context, GoRouterState state) =>
            const LoginPage(),
      ),
      GoRoute(
        path: home,
        name: 'home',
        builder: (BuildContext context, GoRouterState state) =>
            const HomePage(),
      ),
      GoRoute(
        path: '$barberDetails/:businessId',
        name: 'barber-details',
        builder: (BuildContext context, GoRouterState state) {
          final businessId = state.pathParameters['businessId'] ?? '';
          return BarberDetailsPage(businessId: businessId);
        },
      ),
      GoRoute(
        path: '$createAppointment/:businessId',
        name: 'create-appointment',
        builder: (BuildContext context, GoRouterState state) {
          final businessId = state.pathParameters['businessId'] ?? '';
          return CreateAppointmentPage(businessId: businessId);
        },
      ),
      GoRoute(
        path: appointments,
        name: 'appointments',
        builder: (BuildContext context, GoRouterState state) =>
            const AppointmentsPage(),
      ),
      GoRoute(
        path: styleAi,
        name: 'style-ai',
        builder: (BuildContext context, GoRouterState state) =>
            const StyleAiHomePage(),
      ),
      GoRoute(
        path: analyzeFace,
        name: 'analyze-face',
        builder: (BuildContext context, GoRouterState state) =>
            const AnalyzeFacePage(),
      ),
      GoRoute(
        path: analyzeReference,
        name: 'analyze-reference',
        builder: (BuildContext context, GoRouterState state) =>
            const AnalyzeReferencePage(),
      ),
      GoRoute(
        path: '$businessReviews/:businessId',
        name: 'business-reviews',
        builder: (BuildContext context, GoRouterState state) {
          final businessId = state.pathParameters['businessId'] ?? '';
          return BusinessReviewPage(businessId: businessId);
        },
      ),
      GoRoute(
        path: '$createReview/:appointmentId',
        name: 'create-review',
        builder: (BuildContext context, GoRouterState state) {
          final appointmentId = state.pathParameters['appointmentId'] ?? '';
          return CreateReviewPage(appointmentId: appointmentId);
        },
      ),
      GoRoute(
        path: favorites,
        name: 'favorites',
        builder: (BuildContext context, GoRouterState state) =>
            const FavoritesPage(),
      ),
      GoRoute(
        path: '$barberHome/:businessId',
        name: 'barber-home',
        builder: (BuildContext context, GoRouterState state) {
          final businessId = state.pathParameters['businessId'] ?? '';
          return BarberHomePage(businessId: businessId);
        },
      ),
      GoRoute(
        path: map,
        name: 'map',
        builder: (BuildContext context, GoRouterState state) => const MapPage(),
      ),
      GoRoute(
        path:
            '$repeatAppointment/:businessId/:barberId/:serviceId/:appointmentId',
        name: 'repeat-appointment',
        builder: (BuildContext context, GoRouterState state) {
          final businessId = state.pathParameters['businessId'] ?? '';
          final barberId = state.pathParameters['barberId'] ?? '';
          final serviceId = state.pathParameters['serviceId'] ?? '';
          final appointmentId = state.pathParameters['appointmentId'] ?? '';
          return RepeatAppointmentPage(
            businessId: businessId,
            barberId: barberId,
            serviceId: serviceId,
            appointmentId: appointmentId,
          );
        },
      ),
      GoRoute(
        path: '$updateAppointment/:appointmentId',
        name: 'update-appointment',
        builder: (BuildContext context, GoRouterState state) {
          final appointmentId = state.pathParameters['appointmentId'] ?? '';
          final appointment = state.extra as Appointment?;

          if (appointment == null) {
            // Si no se pasa la cita como extra, redirigir a appointments
            return const Scaffold(
              body: Center(
                child: Text('Error: Información de cita no disponible'),
              ),
            );
          }

          return UpdateAppointmentPage(appointment: appointment);
        },
      ),
    ],
  );
}
