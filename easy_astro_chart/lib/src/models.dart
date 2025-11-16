import 'package:flutter/material.dart';

/// Burç sembolleri
enum ZodiacSign {
  aries('♈', 'Koç', 'Aries', Color(0xFFFF4500)),
  taurus('♉', 'Boğa', 'Taurus', Color(0xFF8B4513)),
  gemini('♊', 'İkizler', 'Gemini', Color(0xFF87CEEB)),
  cancer('♋', 'Yengeç', 'Cancer', Color(0xFF27AE60)),
  leo('♌', 'Aslan', 'Leo', Color(0xFFE67E22)),
  virgo('♍', 'Başak', 'Virgo', Color(0xFF8B4513)),
  libra('♎', 'Terazi', 'Libra', Color(0xFF3498DB)),
  scorpio('♏', 'Akrep', 'Scorpio', Color(0xFF1ABC9C)),
  sagittarius('♐', 'Yay', 'Sagittarius', Color(0xFFD35400)),
  capricorn('♑', 'Oğlak', 'Capricorn', Color(0xFF5D4037)),
  aquarius('♒', 'Kova', 'Aquarius', Color(0xFF5DADE2)),
  pisces('♓', 'Balık', 'Pisces', Color(0xFF16A085));

  const ZodiacSign(this.symbol, this.nameTr, this.nameEn, this.color);
  final String symbol;
  final String nameTr;
  final String nameEn;
  final Color color;
}

/// Gezegen türleri
enum PlanetType {
  sun('☉', 'Güneş', Colors.orange),
  moon('☽', 'Ay', Colors.grey),
  mercury('☿', 'Merkür', Colors.blueGrey),
  venus('♀', 'Venüs', Colors.pink),
  mars('♂', 'Mars', Colors.red),
  jupiter('♃', 'Jüpiter', Colors.brown),
  saturn('♄', 'Satürn', Colors.black87),
  uranus('⛢', 'Uranüs', Colors.lightBlue),
  neptune('♆', 'Neptün', Colors.blue),
  pluto('♇', 'Plüto', Colors.purple);

  const PlanetType(this.symbol, this.nameTr, this.color);
  final String symbol;
  final String nameTr;
  final Color color;
}

/// Aspect (açı) türleri
enum AspectType {
  conjunction('Conjunction', 0, Colors.red, 'Kavuşum'),
  opposition('Opposition', 180, Colors.blue, 'Karşıt'),
  trine('Trine', 120, Colors.green, 'Üçgen'),
  square('Square', 90, Colors.red, 'Kare'),
  sextile('Sextile', 60, Colors.blue, 'Altmışlık'),
  quincunx('Quincunx', 150, Colors.orange, 'Beşgen');

  const AspectType(this.nameEn, this.degrees, this.color, this.nameTr);
  final String nameEn;
  final String nameTr;
  final int degrees;
  final Color color;
}

/// Ev (House) sınıfı
class ChartHouse {
  final int number;
  final double startDegree;
  final double endDegree;
  final ZodiacSign sign;
  final Color? color;
  final String? label;

  const ChartHouse({
    required this.number,
    required this.startDegree,
    required this.endDegree,
    required this.sign,
    this.color,
    this.label,
  });

  double get middleDegree => (startDegree + endDegree) / 2;
}

/// Gezegen sınıfı
class ChartPlanet {
  final PlanetType type;
  final double degree;
  final ZodiacSign sign;
  final int house;
  final bool retrograde;
  final Color? color;
  final double? size;

  const ChartPlanet({
    required this.type,
    required this.degree,
    required this.sign,
    required this.house,
    this.retrograde = false,
    this.color,
    this.size,
  });
}

/// Aspect (açı) sınıfı
class ChartAspect {
  final ChartPlanet planet1;
  final ChartPlanet planet2;
  final AspectType type;
  final double orb;
  final Color? color;
  final bool showLine;

  const ChartAspect({
    required this.planet1,
    required this.planet2,
    required this.type,
    this.orb = 0.0,
    this.color,
    this.showLine = true,
  });
}

/// Doğum haritası konfigürasyonu
class AstroChartConfig {
  final double size;
  final double? innerRadius;
  final double? outerRadius;
  final double innerRadiusFactor;
  final double outerRadiusFactor;
  final double margin;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final bool showHouseNumbers;
  final bool showAspectLines;
  final bool showRetrogradeSymbols;
  final bool showZodiacRing;
  final bool showZodiacSymbols;
  final bool showPlanetPointers;
  final bool showAxis;
  final double planetOrbitFactor;
  final double aspectOrbitFactor;
  final double houseLabelOffset;
  final double zodiacSegmentOpacity;
  final double houseBandOpacity;
  final double planetPointerWidth;
  final double houseDividerWidth;
  final double aspectLineWidth;
  final double zodiacStartOffset;
  final double zodiacSymbolRadiusFactor;
  final TextStyle? houseNumberStyle;
  final TextStyle? planetSymbolStyle;
  final TextStyle? zodiacSymbolStyle;
  final TextStyle? axisLabelStyle;
  final Map<PlanetType, Color>? planetColors;
  final Map<AspectType, Color>? aspectColors;
  final List<Color>? zodiacSegmentColors;
  final Map<int, String>? axisLabels;
  final Color houseDividerColor;
  final Color axisColor;

  const AstroChartConfig({
    this.size = 320,
    this.innerRadius,
    this.outerRadius,
    this.innerRadiusFactor = 0.32,
    this.outerRadiusFactor = 0.78,
    this.margin = 8,
    this.backgroundColor = const Color(0xFF0E0E10),
    this.borderColor = const Color(0xFF38364A),
    this.borderWidth = 2,
    this.showHouseNumbers = true,
    this.showAspectLines = true,
    this.showRetrogradeSymbols = true,
    this.showZodiacRing = true,
    this.showZodiacSymbols = true,
    this.showPlanetPointers = true,
    this.showAxis = true,
    this.planetOrbitFactor = 0.55,
    this.aspectOrbitFactor = 0.4,
    this.houseLabelOffset = 18,
    this.zodiacSegmentOpacity = 0.15,
    this.houseBandOpacity = 0.08,
    this.planetPointerWidth = 1,
    this.houseDividerWidth = 1,
    this.aspectLineWidth = 1.5,
    this.zodiacStartOffset = 0,
    this.zodiacSymbolRadiusFactor = 0.85,
    this.houseNumberStyle,
    this.planetSymbolStyle,
    this.zodiacSymbolStyle,
    this.axisLabelStyle,
    this.planetColors,
    this.aspectColors,
    this.zodiacSegmentColors,
    this.axisLabels,
    this.houseDividerColor = const Color(0xFF4F4A6B),
    this.axisColor = const Color(0xFF8F8AAE),
  });
}
