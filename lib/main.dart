import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:secure_application/secure_application.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/services/security_service.dart';
import 'features/favorites/presentation/bloc/favorites_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cargar variables de entorno
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    // Si no existe el archivo .env, continúa con valores por defecto
    print('No se pudo cargar el archivo .env: $e');
  }

  await initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SecureApplication(
      onNeedUnlock: (secureApplicationController) async {
        // Auto-unlock - permitir acceso normal
        secureApplicationController?.unlock();
        return null;
      },
      child: Builder(
        builder: (context) {
          // Inicializar el servicio de seguridad
          final secureController = SecureApplicationProvider.of(context);
          SecurityService.instance.initialize(secureController);

          return BlocProvider<FavoritesBloc>(
            create: (context) => sl<FavoritesBloc>(),
            child: MaterialApp.router(
              title: 'BarberTrack',
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('es', 'ES'), // Español
                Locale('en', 'US'), // Inglés
              ],
              locale: const Locale('es', 'ES'),
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.blue,
                  brightness: Brightness.dark,
                ),
                useMaterial3: true,
              ),
              routerConfig: AppRouter.router,
            ),
          );
        },
      ),
    );
  }
}
