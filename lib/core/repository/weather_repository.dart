import 'package:weather/core/models/weather.dart';
import 'package:weather/core/services/weather_api.dart';

class WeatherRepository {
  final WeatherApi api;
  WeatherRepository(this.api);

  Future<Weather> getByLatLon(double lat, double lon) async =>
      Weather.fromJson(await api.byLatLon(lat, lon));

  Future<Weather> getByCity(String city) async =>
      Weather.fromJson(await api.byCity(city));
}
