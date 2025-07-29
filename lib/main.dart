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

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    throw Exception(e);
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
        secureApplicationController?.unlock();
        return null;
      },
      child: Builder(
        builder: (context) {
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
                Locale('es', 'ES'), 
                Locale('en', 'US'), 
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
