import 'package:material_ui/material_ui.dart';

enum ServiceBadge { mostBooked, premium }

/// How a service looks on its card. The API only knows the slug, title,
/// price and duration, so the artwork, badge and rating are decided here.
///
/// The tints are specific to these cards and not part of the Tidy palette;
/// they live in this one file so they can move to `tidy_ui` later.
class ServiceStyle {
  const ServiceStyle({
    required this.tint,
    required this.deep,
    required this.ink,
    required this.icon,
    required this.rating,
    this.badge,
    this.featured = false,
  });

  /// Background of the art area.
  final Color tint;

  /// Darker shade for the two blobs.
  final Color deep;

  /// Icon colour.
  final Color ink;
  final IconData icon;
  final String rating;
  final ServiceBadge? badge;

  /// Drawn with a green outline.
  final bool featured;

  static const _standard = ServiceStyle(
    tint: Color(0xFFDFF1E8),
    deep: Color(0xFFB8E2CC),
    ink: Color(0xFF0A7A55),
    icon: Icons.home_outlined,
    rating: '4.9',
    badge: ServiceBadge.mostBooked,
    featured: true,
  );

  static const _deep = ServiceStyle(
    tint: Color(0xFFF8EBD2),
    deep: Color(0xFFF1D49C),
    ink: Color(0xFF8A5300),
    icon: Icons.auto_awesome_outlined,
    rating: '4.8',
    badge: ServiceBadge.premium,
  );

  static const _endOfTenancy = ServiceStyle(
    tint: Color(0xFFE1EAF7),
    deep: Color(0xFFBCD0EE),
    ink: Color(0xFF1D4AA8),
    icon: Icons.apartment_outlined,
    rating: '4.9',
  );

  static const _office = ServiceStyle(
    tint: Color(0xFFECE5F6),
    deep: Color(0xFFD2C2EC),
    ink: Color(0xFF5B34A8),
    icon: Icons.business_center_outlined,
    rating: '4.7',
  );

  /// Used for services added to the catalogue later.
  static const _fallback = ServiceStyle(
    tint: Color(0xFFDFF1E8),
    deep: Color(0xFFB8E2CC),
    ink: Color(0xFF0A7A55),
    icon: Icons.cleaning_services_outlined,
    rating: '4.8',
  );

  static ServiceStyle forSlug(String slug) => switch (slug) {
    'standard' => _standard,
    'deep' => _deep,
    'end-of-tenancy' => _endOfTenancy,
    'office' => _office,
    _ => _fallback,
  };
}
