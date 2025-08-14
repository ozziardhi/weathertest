import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather/shared/weather_assets.dart';

class FloatingGlows extends StatelessWidget {
  const FloatingGlows({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: const [
          _CloudSprite(
            asset: WeatherAssets.sunCloud,
            top: 40,
            left: 40,
            width: 100,
            opacity: .26,
            blur: 2.0,
          ),
          _CloudSprite(
            asset: WeatherAssets.windyCloud,
            top: 80,
            right: 10,
            width: 100,
            opacity: .22,
            blur: 3.0,
          ),
          _CloudSprite(
            asset: WeatherAssets.partlySunny,
            bottom: 10,
            left: -10,
            width: 100,
            opacity: .20,
            blur: 1.5,
          ),
          _CloudSprite(
            asset: WeatherAssets.rainyDay,
            bottom: 50,
            right: 20,
            width: 100,
            opacity: .22,
            blur: 2.5,
          ),
          _CloudSprite(
            asset: WeatherAssets.rainyDay,
            top: 400,
            right: 20,
            width: 100,
            opacity: .22,
            blur: 2.5,
          ),
        ],
      ),
    );
  }
}

class _CloudSprite extends StatelessWidget {
  final double? top, left, right, bottom, width, blur, opacity;
  final String asset;
  const _CloudSprite({
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.asset,
    this.width,
    this.blur,
    this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    final w = width ?? 200.0;
    final b = blur ?? 0.0;
    final o = opacity ?? .3;
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: b, sigmaY: b),
        child: Opacity(
          opacity: o,
          child: Image.asset(
            asset,
            width: w,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.medium,
          ),
        ),
      ),
    );
  }
}
