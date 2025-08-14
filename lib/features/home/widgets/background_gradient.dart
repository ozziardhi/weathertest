import 'package:flutter/material.dart';

class BackgroundGradient extends StatelessWidget {
  final List<Color> colors;
  final Alignment begin;
  final Alignment end;

  const BackgroundGradient({
    super.key,
    this.colors = const [
      Color.fromARGB(255, 81, 81, 90),
      Color.fromARGB(255, 34, 51, 240),
    ],
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors, begin: begin, end: end),
      ),
    );
  }
}
