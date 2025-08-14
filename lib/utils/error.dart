String friendlyError(
  Object error, {
  String fallback = 'Terjadi kesalahan. Silakan coba lagi.',
}) {
  final m = error.toString().toLowerCase();

  bool hasAny(List<String> keys) => keys.any(m.contains);

  if (hasAny(['city not found', '(404)', 'code 404'])) {
    return 'City not found';
  }
  if (hasAny([
    'failed host lookup',
    'socketexception',
    'network is unreachable',
    'connection refused',
    'dns',
  ])) {
    return 'Tidak ada koneksi internet. Periksa jaringan Anda lalu coba lagi.';
  }
  if (hasAny(['permission', 'denied']) && hasAny(['location'])) {
    return 'Izin lokasi ditolak. Aktifkan izin lokasi di Pengaturan.';
  }
  if (hasAny(['location services are disabled', 'gps'])) {
    return 'Layanan lokasi nonaktif. Aktifkan GPS/Lokasi lalu coba lagi.';
  }
  if (hasAny(['timeout', 'timed out'])) {
    return 'Permintaan berakhir (timeout). Coba lagi sebentar.';
  }
  if (hasAny(['401', 'unauthorized', 'invalid api key', 'api key'])) {
    return 'Kunci API tidak valid. Hubungi pengembang.';
  }
  if (hasAny(['429', 'too many requests', 'rate limit'])) {
    return 'Terlalu banyak permintaan. Coba lagi beberapa saat.';
  }
  if (hasAny(['500', '502', '503', '504', 'server error'])) {
    return 'Server sedang bermasalah. Coba lagi nanti.';
  }

  return fallback;
}
