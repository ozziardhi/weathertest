// ... import yang sudah ada
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather/core/models/weather.dart';
import 'package:weather/core/repository/weather_repository.dart';
import 'package:weather/core/services/location_service.dart';

// --- provider yang SUDAH ADA, jangan dihapus ---
final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  throw UnimplementedError('Override in main with API key');
});
final locationServiceProvider = Provider<LocationService>(
  (_) => LocationService(),
);

class WeatherController extends AsyncNotifier<Weather?> {
  @override
  Future<Weather?> build() async => null;

  Future<void> loadByCurrentLocation() async {
    state = const AsyncLoading();
    final repo = ref.read(weatherRepositoryProvider);
    final loc = await ref.read(locationServiceProvider).getCurrentPosition();
    state = await AsyncValue.guard(
      () => repo.getByLatLon(loc.latitude, loc.longitude),
    );
  }

  void clear() => state = const AsyncData(null);
}

final weatherControllerProvider =
    AsyncNotifierProvider<WeatherController, Weather?>(
      () => WeatherController(),
    );

// === ⬇️ TAMBAH: controller khusus hasil pencarian kota
class SearchWeatherController extends AsyncNotifier<Weather?> {
  @override
  Future<Weather?> build() async => null;

  Future<void> loadByCity(String city) async {
    final q = city.trim();
    if (q.isEmpty) return;
    state = const AsyncLoading();
    final repo = ref.read(weatherRepositoryProvider);
    state = await AsyncValue.guard(() => repo.getByCity(q));
  }

  void clear() => state = const AsyncData(null);
}

final searchWeatherControllerProvider =
    AsyncNotifierProvider<SearchWeatherController, Weather?>(
      () => SearchWeatherController(),
    );
