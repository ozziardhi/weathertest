import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../weather_controller.dart';

class HomeState {
  final String cityQuery;
  const HomeState({this.cityQuery = ''});

  HomeState copyWith({String? cityQuery}) =>
      HomeState(cityQuery: cityQuery ?? this.cityQuery);
}

final homeControllerProvider = NotifierProvider<HomeController, HomeState>(
  HomeController.new,
);

class HomeController extends Notifier<HomeState> {
  bool _initialized = false;

  late final TextEditingController cityController;
  bool _ctlReady = false;

  @override
  HomeState build() {
    final initial = const HomeState();
    state = initial;
    _ensureController(initial.cityQuery);
    return initial;
  }

  void _ensureController(String initialText) {
    if (_ctlReady) return;
    _ctlReady = true;
    cityController = TextEditingController(text: initialText);
    cityController.addListener(() {
      final txt = cityController.text;
      if (txt != state.cityQuery) {
        state = state.copyWith(cityQuery: txt);
      }
    });
    ref.onDispose(() => cityController.dispose());
  }

  void init() {
    if (_initialized) return;
    _initialized = true;
    ref.read(weatherControllerProvider.notifier).loadByCurrentLocation();
  }

  void clearCity() {
    if (cityController.text.isNotEmpty) cityController.clear();
    if (state.cityQuery.isNotEmpty) state = state.copyWith(cityQuery: '');
  }

  Future<void> search() async {
    final q = state.cityQuery.trim();
    if (q.isEmpty) return;
    await ref.read(searchWeatherControllerProvider.notifier).loadByCity(q);
  }
}
