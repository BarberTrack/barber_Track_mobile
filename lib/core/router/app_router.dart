import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/login/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/barberShops/features/barberDetails/presentation/pages/barber_details_page.dart';
import '../../features/appointments/features/create_appointment/presentation/pages/create_appointment_page.dart';

class AppRouter {
  static const String login = '/login';
  static const String home = '/home';
  static const String barberDetails = '/barber-details';
  static const String createAppointment = '/create-appointment';

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
    ],
  );
}
