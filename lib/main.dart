import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather/core/repository/weather_repository.dart';
import 'package:weather/features/splash/splashscreen.dart';

import 'features/auth/login_page.dart';
import 'features/home/home_page.dart';
import 'core/services/weather_api.dart';

import 'features/home/weather_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  final apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';

  runApp(
    ProviderScope(
      overrides: [
        weatherRepositoryProvider.overrideWithValue(
          WeatherRepository(WeatherApi(apiKey)),
        ),
      ],
      child: const WeatherApp(),
    ),
  );
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF6FBF8), // hijau sangat muda
      ),
      routes: {
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginPage(),
        '/home': (_) => const HomePage(),
      },
      initialRoute: '/',
    );
  }
}
