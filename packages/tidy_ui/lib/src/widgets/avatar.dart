import 'package:material_ui/material_ui.dart';
import 'package:tidy_ui/src/tokens/colors.dart';

/// Circular avatar showing a photo or, without one, the person's initials.
class Avatar extends StatelessWidget {
  const Avatar({required this.name, this.imageUrl, this.size = 44, super.key});

  final String name;
  final String? imageUrl;
  final double size;

  /// "Sarah Jones" -> "SJ", "sarah" -> "S", "" -> "?".
  static String initialsOf(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    final first = String.fromCharCode(parts.first.runes.first);
    if (parts.length == 1) return first.toUpperCase();
    final last = String.fromCharCode(parts.last.runes.first);
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    return Semantics(
      label: name,
      image: true,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: TidyColors.primarySoft,
          shape: BoxShape.circle,
        ),
        clipBehavior: Clip.antiAlias,
        child: url != null && url.isNotEmpty
            ? Image.network(
                url,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _initials(),
              )
            : _initials(),
      ),
    );
  }

  Widget _initials() => ExcludeSemantics(
    child: Text(
      initialsOf(name),
      style: TextStyle(
        color: TidyColors.primary,
        fontWeight: FontWeight.w700,
        fontSize: size * 0.36,
      ),
    ),
  );
}
