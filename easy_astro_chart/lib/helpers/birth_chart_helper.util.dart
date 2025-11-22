import 'package:easy_astro_chart/easy_astro_chart.dart';
import 'package:flutter/material.dart';

/// 🌌 Birth Chart Helper
///
/// Doğum haritası için zodiac, planet ve aspect parsing yardımcı metodları
class BirthChartHelper {
  /// Zodiac sign adını al
  static String getZodiacName(String key) {
    final signs = {
      'aries': 'Koç ♈',
      'taurus': 'Boğa ♉',
      'gemini': 'İkizler ♊',
      'cancer': 'Yengeç ♋',
      'leo': 'Aslan ♌',
      'virgo': 'Başak ♍',
      'libra': 'Terazi ♎',
      'scorpio': 'Akrep ♏',
      'sagittarius': 'Yay ♐',
      'capricorn': 'Oğlak ♑',
      'aquarius': 'Kova ♒',
      'pisces': 'Balık ♓',
    };
    return signs[key.toLowerCase()] ?? 'Koç ♈';
  }

  /// String'den ZodiacSign enum'a dönüştür
  static ZodiacSign getZodiacSignFromString(String key) {
    final signMap = {
      'aries': ZodiacSign.aries,
      'taurus': ZodiacSign.taurus,
      'gemini': ZodiacSign.gemini,
      'cancer': ZodiacSign.cancer,
      'leo': ZodiacSign.leo,
      'virgo': ZodiacSign.virgo,
      'libra': ZodiacSign.libra,
      'scorpio': ZodiacSign.scorpio,
      'sagittarius': ZodiacSign.sagittarius,
      'capricorn': ZodiacSign.capricorn,
      'aquarius': ZodiacSign.aquarius,
      'pisces': ZodiacSign.pisces,
    };
    return signMap[key.toLowerCase()] ?? ZodiacSign.aries;
  }

  /// String'den PlanetType enum'a dönüştür
  static PlanetType getPlanetTypeFromString(String key) {
    final planetMap = {
      'sun': PlanetType.sun,
      'moon': PlanetType.moon,
      'mercury': PlanetType.mercury,
      'venus': PlanetType.venus,
      'mars': PlanetType.mars,
      'jupiter': PlanetType.jupiter,
      'saturn': PlanetType.saturn,
      'uranus': PlanetType.uranus,
      'neptune': PlanetType.neptune,
      'pluto': PlanetType.pluto,
    };
    return planetMap[key.toLowerCase()] ?? PlanetType.sun;
  }

  /// Parse houses from Map format
  static List<ChartHouse> parseHouses(Map<String, dynamic> housesData) {
    if (housesData.isEmpty) return [];

    final parsed = housesData.entries.map<_HouseData>((entry) {
      final value = Map<String, dynamic>.from(entry.value as Map);
      final houseNumber = int.tryParse(entry.key) ?? 1;
      final longitude = _normalizeDegree(
        value['longitude'] ?? value['lng'] ?? value['degree'] ?? 0,
      );
      final sign = getZodiacSignFromString(value['sign'] ?? 'aries');
      final color = _parseColor(value['color']);
      final label = value['label']?.toString();

      return _HouseData(
        number: houseNumber,
        longitude: longitude,
        sign: sign,
        color: color,
        label: label,
      );
    }).toList()
      ..sort((a, b) => a.number.compareTo(b.number));

    final houses = <ChartHouse>[];
    for (var i = 0; i < parsed.length; i++) {
      final current = parsed[i];
      final next = parsed[(i + 1) % parsed.length];

      var endDegree = next.longitude;
      if (endDegree <= current.longitude) {
        endDegree += 360;
      }

      houses.add(
        ChartHouse(
          number: current.number,
          startDegree: current.longitude,
          endDegree: _normalizeDegree(endDegree),
          sign: current.sign,
          color: current.color,
          label: current.label,
        ),
      );
    }

    return houses;
  }

  /// Parse planets from Map format
  static List<ChartPlanet> parsePlanets(Map<String, dynamic> planetsData) {
    final planets = <ChartPlanet>[];

    planetsData.forEach((key, value) {
      final planetData = value as Map<String, dynamic>;
      final longitude = (planetData['longitude'] ?? 0.0).toDouble();

      planets.add(
        ChartPlanet(
          type: getPlanetTypeFromString(key),
          degree: longitude,
          sign: getZodiacSignFromString(planetData['sign'] ?? 'aries'),
          house: planetData['house'] ?? 1,
          retrograde: planetData['retrograde'] ?? false,
        ),
      );
    });

    return planets;
  }

  /// Parse aspects from Map format
  static List<ChartAspect> parseAspects(
    Map<String, dynamic> aspectsData,
    List<ChartPlanet> planets,
  ) {
    if (planets.isEmpty) return [];

    final aspects = <ChartAspect>[];

    aspectsData.forEach((key, value) {
      final aspectData = value as Map<String, dynamic>;
      final planetKeys = key.split('_');
      if (planetKeys.length != 2) return;

      final planet1Type = getPlanetTypeFromString(planetKeys[0]);
      final planet2Type = getPlanetTypeFromString(planetKeys[1]);

      final planet1 = planets.firstWhere(
        (p) => p.type == planet1Type,
        orElse: () => planets.first,
      );
      final planet2 = planets.firstWhere(
        (p) => p.type == planet2Type,
        orElse: () => planet1,
      );

      final aspectTypeMap = {
        'conjunction': AspectType.conjunction,
        'opposition': AspectType.opposition,
        'trine': AspectType.trine,
        'square': AspectType.square,
        'sextile': AspectType.sextile,
        'quincunx': AspectType.quincunx,
      };

      aspects.add(
        ChartAspect(
          planet1: planet1,
          planet2: planet2,
          type: aspectTypeMap[aspectData['type']] ?? AspectType.conjunction,
          orb: (aspectData['orb'] ?? 0.0).toDouble(),
        ),
      );
    });

    return aspects;
  }

  static double _parseDegree(dynamic raw) {
    if (raw is num) return raw.toDouble();
    if (raw is String) {
      final sanitized = raw.replaceAll(',', '.').trim();
      final parsed = double.tryParse(sanitized);
      if (parsed != null) return parsed;
    }
    return 0;
  }

  static double _normalizeDegree(dynamic raw) {
    final value = _parseDegree(raw);
    final normalized = value % 360;
    return normalized < 0 ? normalized + 360 : normalized;
  }

  static Color? _parseColor(dynamic raw) {
    if (raw == null) return null;
    if (raw is Color) return raw;
    if (raw is int) return Color(raw);
    if (raw is String) {
      final value = raw.trim();
      if (value.isEmpty) return null;
      final hex = value.replaceFirst('#', '').toUpperCase();
      final normalized = hex.length == 6 ? 'FF$hex' : hex;
      final parsed = int.tryParse(normalized, radix: 16);
      if (parsed != null) return Color(parsed);
    }
    return null;
  }
}

class _HouseData {
  final int number;
  final double longitude;
  final ZodiacSign sign;
  final Color? color;
  final String? label;

  const _HouseData({
    required this.number,
    required this.longitude,
    required this.sign,
    this.color,
    this.label,
  });
}
