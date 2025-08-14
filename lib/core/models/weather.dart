class Weather {
  final String city;
  final double tempC;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;

  Weather({
    required this.city,
    required this.tempC,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String? ?? '-';
    final main = (json['main'] as Map?) ?? {};
    final list = ((json['weather'] as List?)?.cast<Map>()) ?? const [];
    final first = list.isNotEmpty ? list.first : const {};
    final wind = (json['wind'] as Map?) ?? {};

    return Weather(
      city: name,
      tempC: (main['temp'] as num?)?.toDouble() ?? 0,
      description: (first['description'] as String? ?? '').toUpperCase(),
      icon: (first['icon'] as String? ?? '01d'),
      humidity: (main['humidity'] as num?)?.toInt() ?? 0,
      windSpeed: (wind['speed'] as num?)?.toDouble() ?? 0,
    );
  }
}
