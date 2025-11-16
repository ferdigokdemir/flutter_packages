import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'models.dart';

/// Astrolojik doğum haritasını çizen CustomPainter
class AstroChartPainter extends CustomPainter {
  final List<ChartHouse> houses;
  final List<ChartPlanet> planets;
  final List<ChartAspect> aspects;
  final AstroChartConfig config;

  AstroChartPainter({
    required this.houses,
    required this.planets,
    required this.aspects,
    required this.config,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final metrics = _resolveMetrics(size);

    _drawBackground(canvas, center, metrics);
    if (config.showZodiacRing) {
      _drawZodiacRing(canvas, center, metrics);
    }
    _drawHouseBands(canvas, center, metrics);
    _drawHouseDividers(canvas, center, metrics);
    if (config.showAxis) {
      _drawAxis(canvas, center, metrics);
    }
    if (config.showHouseNumbers) {
      _drawHouseLabels(canvas, center, metrics);
    }
    if (config.showAspectLines) {
      _drawAspects(canvas, center, metrics);
    }
    if (config.showPlanetPointers) {
      _drawPlanetPointers(canvas, center, metrics);
    }
    _drawPlanets(canvas, center, metrics);
  }

  void _drawBackground(Canvas canvas, Offset center, _ChartMetrics metrics) {
    final backgroundPaint = Paint()
      ..color = config.backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, metrics.outerRadius, backgroundPaint);

    final borderPaint = Paint()
      ..color = config.borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.borderWidth;
    canvas.drawCircle(center, metrics.outerRadius, borderPaint);

    final ringPaint = Paint()
      ..color = config.borderColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas
      ..drawCircle(center, metrics.innerRadius, ringPaint)
      ..drawCircle(center, metrics.outerRadius, ringPaint);
  }

  void _drawZodiacRing(Canvas canvas, Offset center, _ChartMetrics metrics) {
    final thickness = metrics.outerRadius - metrics.innerRadius;
    if (thickness <= 0) return;

    final colors = config.zodiacSegmentColors ??
        ZodiacSign.values.map((sign) => sign.color).toList();
    var start = config.zodiacStartOffset;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.butt;

    final rect = Rect.fromCircle(
      center: center,
      radius: metrics.innerRadius + thickness / 2,
    );

    for (var i = 0; i < ZodiacSign.values.length; i++) {
      final baseColor = colors[i % colors.length];
      final opacity = config.zodiacSegmentOpacity.clamp(0.0, 1.0);
      paint.color = opacity == 0
          ? Colors.transparent
          : baseColor.withValues(alpha: opacity);

      canvas.drawArc(
        rect,
        _degreeToRadian(start - 90),
        _degreeToRadian(30),
        false,
        paint,
      );
      start += 30;
    }

    if (!config.showZodiacSymbols) {
      return;
    }

    final symbolStyle = config.zodiacSymbolStyle ??
        const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        );

    final radius = metrics.innerRadius +
        (metrics.outerRadius - metrics.innerRadius) *
            config.zodiacSymbolRadiusFactor.clamp(0.0, 1.0);

    start = config.zodiacStartOffset + 15;
    for (final sign in ZodiacSign.values) {
      final position = _positionForDegree(
        center: center,
        radius: radius,
        degree: start,
      );

      final painter = TextPainter(
        text: TextSpan(
          text: sign.symbol,
          style: symbolStyle,
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      painter.paint(
        canvas,
        position - Offset(painter.width / 2, painter.height / 2),
      );
      start += 30;
    }
  }

  void _drawHouseBands(Canvas canvas, Offset center, _ChartMetrics metrics) {
    final thickness = metrics.outerRadius - metrics.innerRadius;
    if (thickness <= 0) return;
    if (houses.isEmpty) return;

    for (final house in houses) {
      final baseColor = house.color ?? house.sign.color;
      final opacity = config.houseBandOpacity.clamp(0.0, 1.0);
      if (opacity <= 0 && house.color == null) continue;

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.butt
        ..strokeWidth = thickness
        ..color = opacity <= 0
            ? house.color ?? Colors.transparent
            : baseColor.withValues(alpha: opacity);

      final startAngle = _degreeToRadian(house.startDegree - 90);
      var sweepAngle = house.endDegree - house.startDegree;
      if (sweepAngle <= 0) {
        sweepAngle += 360;
      }

      final rect = Rect.fromCircle(
        center: center,
        radius: metrics.innerRadius + thickness / 2,
      );
      canvas.drawArc(
          rect, startAngle, _degreeToRadian(sweepAngle), false, paint);
    }
  }

  void _drawHouseDividers(Canvas canvas, Offset center, _ChartMetrics metrics) {
    if (houses.isEmpty) return;
    final dividerPaint = Paint()
      ..color = config.houseDividerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.houseDividerWidth;

    for (final house in houses) {
      final startOffset = _positionForDegree(
        center: center,
        radius: metrics.innerRadius,
        degree: house.startDegree,
      );
      final endOffset = _positionForDegree(
        center: center,
        radius: metrics.outerRadius,
        degree: house.startDegree,
      );
      canvas.drawLine(startOffset, endOffset, dividerPaint);
    }
  }

  void _drawHouseLabels(Canvas canvas, Offset center, _ChartMetrics metrics) {
    if (houses.isEmpty) return;
    final textStyle = config.houseNumberStyle ??
        const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        );

    for (final house in houses) {
      final middleDegree = _middleOfHouse(house);
      final position = _positionForDegree(
        center: center,
        radius: metrics.outerRadius + config.houseLabelOffset,
        degree: middleDegree,
      );

      final label = house.label ?? house.number.toString();
      final textPainter = TextPainter(
        text: TextSpan(text: label, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        position - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }
  }

  void _drawAxis(Canvas canvas, Offset center, _ChartMetrics metrics) {
    if (houses.isEmpty) return;
    final axisMap = config.axisLabels ??
        const {
          1: 'ASC',
          4: 'IC',
          7: 'DESC',
          10: 'MC',
        };

    final linePaint = Paint()
      ..color = config.axisColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.houseDividerWidth * 1.2;

    final labelStyle = config.axisLabelStyle ??
        const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        );

    final houseLookup = <int, ChartHouse>{
      for (final house in houses) house.number: house,
    };

    for (final entry in axisMap.entries) {
      final house = houseLookup[entry.key];
      if (house == null) continue;

      final angleDegree = house.startDegree;
      final start = _positionForDegree(
        center: center,
        radius: metrics.innerRadius,
        degree: angleDegree,
      );
      final end = _positionForDegree(
        center: center,
        radius: metrics.outerRadius + config.houseLabelOffset / 2,
        degree: angleDegree,
      );
      canvas.drawLine(start, end, linePaint);

      final labelPosition = _positionForDegree(
        center: center,
        radius: metrics.outerRadius + config.houseLabelOffset + 8,
        degree: angleDegree,
      );

      final painter = TextPainter(
        text: TextSpan(text: entry.value, style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      painter.paint(
        canvas,
        labelPosition - Offset(painter.width / 2, painter.height / 2),
      );
    }
  }

  void _drawPlanetPointers(
      Canvas canvas, Offset center, _ChartMetrics metrics) {
    final pointerPaint = Paint()
      ..color = config.houseDividerColor.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.planetPointerWidth;

    for (final planet in planets) {
      final start = _positionForDegree(
        center: center,
        radius: metrics.innerRadius,
        degree: planet.degree,
      );
      final end = _positionForDegree(
        center: center,
        radius: metrics.planetOrbitRadius,
        degree: planet.degree,
      );
      canvas.drawLine(start, end, pointerPaint);
    }
  }

  void _drawPlanets(Canvas canvas, Offset center, _ChartMetrics metrics) {
    final planetStyle = config.planetSymbolStyle ??
        const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        );

    for (final planet in planets) {
      final position = _positionForDegree(
        center: center,
        radius: metrics.planetOrbitRadius,
        degree: planet.degree,
      );

      final color = config.planetColors?[planet.type] ??
          planet.color ??
          planet.type.color;

      final effectiveStyle = (planet.size != null
              ? planetStyle.copyWith(fontSize: planet.size)
              : planetStyle)
          .copyWith(color: color);

      final symbol = config.showRetrogradeSymbols && planet.retrograde
          ? '℞${planet.type.symbol}'
          : planet.type.symbol;

      final textPainter = TextPainter(
        text: TextSpan(text: symbol, style: effectiveStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        position - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }
  }

  void _drawAspects(Canvas canvas, Offset center, _ChartMetrics metrics) {
    for (final aspect in aspects) {
      if (!aspect.showLine) continue;

      final start = _positionForDegree(
        center: center,
        radius: metrics.aspectOrbitRadius,
        degree: aspect.planet1.degree,
      );
      final end = _positionForDegree(
        center: center,
        radius: metrics.aspectOrbitRadius,
        degree: aspect.planet2.degree,
      );

      final paint = Paint()
        ..color = config.aspectColors?[aspect.type] ??
            aspect.color ??
            aspect.type.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = config.aspectLineWidth;

      canvas.drawLine(start, end, paint);
    }
  }

  _ChartMetrics _resolveMetrics(Size size) {
    final canvasRadius = math.max(0.0, math.min(size.width, size.height) / 2);
    final fallbackOuter =
        (canvasRadius * config.outerRadiusFactor).clamp(0.0, canvasRadius);
    final outerCandidate = config.outerRadius ??
        math.min(canvasRadius - config.margin, canvasRadius);
    final outerRadius = outerCandidate.isFinite
        ? outerCandidate.clamp(0.0, canvasRadius).toDouble()
        : canvasRadius;
    final effectiveOuter =
        outerRadius == 0 ? fallbackOuter.toDouble() : outerRadius;

    final innerCandidate =
        config.innerRadius ?? effectiveOuter * config.innerRadiusFactor;
    final innerRadius =
        innerCandidate.clamp(0.0, math.max(effectiveOuter - 1, 0)).toDouble();

    final orbitSpan = math.max(effectiveOuter - innerRadius, 1);
    final planetOrbitFactor =
        config.planetOrbitFactor.clamp(0.0, 1.0).toDouble();
    final aspectOrbitFactor =
        config.aspectOrbitFactor.clamp(0.0, 1.0).toDouble();

    final planetOrbitRadius = innerRadius + orbitSpan * planetOrbitFactor;
    final aspectOrbitRadius = innerRadius + orbitSpan * aspectOrbitFactor;

    return _ChartMetrics(
      innerRadius: innerRadius,
      outerRadius: effectiveOuter,
      planetOrbitRadius: planetOrbitRadius,
      aspectOrbitRadius: aspectOrbitRadius,
    );
  }

  double _middleOfHouse(ChartHouse house) {
    var start = house.startDegree;
    var end = house.endDegree;
    if (end < start) {
      end += 360;
    }
    final middle = (start + end) / 2;
    return middle >= 360 ? middle - 360 : middle;
  }

  Offset _positionForDegree({
    required Offset center,
    required double radius,
    required double degree,
  }) {
    final angle = _degreeToRadian(degree - 90);
    return Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );
  }

  double _degreeToRadian(double degree) => degree * math.pi / 180;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is! AstroChartPainter) {
      return true;
    }
    return houses != oldDelegate.houses ||
        planets != oldDelegate.planets ||
        aspects != oldDelegate.aspects ||
        config != oldDelegate.config;
  }
}

class _ChartMetrics {
  final double innerRadius;
  final double outerRadius;
  final double planetOrbitRadius;
  final double aspectOrbitRadius;

  const _ChartMetrics({
    required this.innerRadius,
    required this.outerRadius,
    required this.planetOrbitRadius,
    required this.aspectOrbitRadius,
  });
}
