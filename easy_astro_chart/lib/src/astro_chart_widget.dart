import 'package:flutter/material.dart';

import 'astro_chart_painter.dart';
import 'models.dart';

/// Doğum haritası widget'ı
class AstroChart extends StatelessWidget {
  final List<ChartHouse> houses;
  final List<ChartPlanet> planets;
  final List<ChartAspect> aspects;
  final AstroChartConfig config;

  const AstroChart({
    super.key,
    required this.houses,
    required this.planets,
    required this.aspects,
    this.config = const AstroChartConfig(),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: config.size,
      height: config.size,
      child: CustomPaint(
        painter: AstroChartPainter(
          houses: houses,
          planets: planets,
          aspects: aspects,
          config: config,
        ),
      ),
    );
  }
}
