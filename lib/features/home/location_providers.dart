import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/services/location_service.dart';

final locationServiceProvider = Provider<LocationService>(
  (ref) => LocationService(),
);

final cityQueryProvider = StateProvider<String>((ref) => '');

class LocationController extends StateNotifier<AsyncValue<Position?>> {
  LocationController(this.ref) : super(const AsyncData(null));

  final Ref ref;

  Future<void> useCurrentLocation() async {
    state = const AsyncLoading();
    final svc = ref.read(locationServiceProvider);
    state = await AsyncValue.guard(() => svc.getCurrentPosition());
  }

  void clear() => state = const AsyncData(null);
}

final locationControllerProvider =
    StateNotifierProvider<LocationController, AsyncValue<Position?>>(
      (ref) => LocationController(ref),
    );
