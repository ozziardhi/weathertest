import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherApi {
  final String apiKey;
  WeatherApi(this.apiKey);

  Future<Map<String, dynamic>> _get(Uri uri) async {
    try {
      final res = await http.get(uri).timeout(const Duration(seconds: 10));
      if (res.statusCode == 401) {
        throw Exception('Invalid API key (401).');
      }
      if (res.statusCode == 404) {
        throw Exception('City not found (404).');
      }
      if (res.statusCode != 200) {
        throw Exception('API error: ${res.statusCode} ${res.reasonPhrase}');
      }
      return jsonDecode(res.body) as Map<String, dynamic>;
    } on TimeoutException {
      throw Exception('Request timed out. Please check your connection.');
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> byLatLon(double lat, double lon) async {
    final uri = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
      'lat': '$lat',
      'lon': '$lon',
      'appid': apiKey,
      'units': 'metric',
    });
    return _get(uri);
  }

  Future<Map<String, dynamic>> byCity(String city) async {
    final uri = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
      'q': city,
      'appid': apiKey,
      'units': 'metric',
    });
    return _get(uri);
  }
}
