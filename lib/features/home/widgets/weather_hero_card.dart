import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather/core/models/weather.dart';

class WeatherHeroCard extends StatelessWidget {
  final Weather w;

  /// tinggi minimum kartu
  final double minHeight;

  /// jarak tepi kartu
  final EdgeInsets margin;

  /// jika true, sudut bawah kotak dibuat rata (tanpa radius)
  final bool flatBottom;

  const WeatherHeroCard(
    this.w, {
    super.key,
    this.minHeight = 220,
    this.margin = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    this.flatBottom = true, // <- default: bawah rata
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius =
        flatBottom
            ? const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),
            )
            : BorderRadius.circular(28);

    return Padding(
      padding: margin,
      child: ClipRRect(
        borderRadius: radius, // <- clip sesuai bentuk
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            constraints: BoxConstraints(minHeight: minHeight),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            decoration: BoxDecoration(
              borderRadius: radius, // <- dekorasi sesuai bentuk
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.18),
                  Colors.white.withOpacity(0.10),
                ],
              ),
              border: Border.all(color: Colors.white.withOpacity(0.28)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _IconBubble(icon: w.icon, size: 84),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      const SizedBox(height: 4),
                      Text(
                        w.city,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${w.tempC.toStringAsFixed(1)} °C',
                        style: const TextStyle(
                          fontSize: 46,
                          height: 1,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        w.description.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white70,
                          letterSpacing: .6,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _MetricChip(
                            icon: Icons.water_drop,
                            label: '${w.humidity}%',
                          ),
                          _MetricChip(
                            icon: Icons.air,
                            label: '${w.windSpeed.toStringAsFixed(1)} m/s',
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({required this.icon, this.size = 76});
  final String icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      alignment: Alignment.center,
      child: Image.network(
        'https://openweathermap.org/img/wn/$icon@2x.png',
        width: size * 0.76,
        height: size * 0.76,
        fit: BoxFit.contain,
        errorBuilder:
            (_, __, ___) =>
                const Icon(Icons.cloud, size: 40, color: Colors.white),
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
