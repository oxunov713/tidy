import 'package:material_ui/material_ui.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Amber circle with the cleaner's initials, as in the design. Shows the photo
/// when the cleaner has one.
class CleanerAvatar extends StatelessWidget {
  const CleanerAvatar({
    required this.name,
    this.imageUrl,
    this.size = 44,
    super.key,
  });

  final String name;
  final String? imageUrl;
  final double size;

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
          color: TidyColors.accent,
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
      Avatar.initialsOf(name),
      style: TextStyle(
        color: TidyColors.ink,
        fontWeight: FontWeight.w700,
        fontSize: size * 0.3,
      ),
    ),
  );
}
