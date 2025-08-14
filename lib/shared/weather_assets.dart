class WeatherAssets {
  static const base = 'assets/weather';
  static const sunCloud = '$base/sun-cloud.png';
  static const rainyDay = '$base/rainy-day.png';
  static const windyCloud = '$base/windy-cloud.png';
  static const partlySunny = '$base/partly-sunny.png';
}

/// Map kode ikon OpenWeather (01d, 02n, dst) → gambar pilihanmu.
/// Sesuaikan kalau mau.
String assetFromOpenWeather(String icon, {String? main}) {
  // Ambil 2 digit awal: 01..50
  final code = icon.isNotEmpty ? icon.substring(0, 2) : '';
  switch (code) {
    case '01':
      return WeatherAssets.partlySunny;
    case '02':
    case '03':
      return WeatherAssets.sunCloud;
    case '04':
      return WeatherAssets.windyCloud;
    case '09':
    case '10':
      return WeatherAssets.rainyDay;
    case '11':
      return WeatherAssets.rainyDay;
    case '13':
      return WeatherAssets.windyCloud;
    case '50':
      return WeatherAssets.windyCloud;
    default:
      switch ((main ?? '').toLowerCase()) {
        case 'rain':
        case 'drizzle':
        case 'thunderstorm':
          return WeatherAssets.rainyDay;
        case 'clouds':
          return WeatherAssets.sunCloud;
        case 'clear':
          return WeatherAssets.partlySunny;
        default:
          return WeatherAssets.partlySunny;
      }
  }
}
