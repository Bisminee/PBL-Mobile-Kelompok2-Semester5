import 'garment.dart';

/// A recommended pairing of a top and a bottom item.
class Outfit {
  const Outfit({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.top,
    required this.bottom,
    required this.score,
    required this.reasons,
  });

  final String id;
  final String title;
  final String subtitle;
  final Garment top;
  final Garment bottom;
  final double score;
  final List<String> reasons;

  int get scorePercent => (score * 100).round();
}
