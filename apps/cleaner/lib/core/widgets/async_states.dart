import 'package:material_ui/material_ui.dart';
import 'package:tidy_cleaner/core/errors/error_text.dart';
import 'package:tidy_cleaner/l10n/app_localizations.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Error with a retry button, for a screen or a card.
class ErrorState extends StatelessWidget {
  const ErrorState({required this.error, required this.onRetry, super.key});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return EmptyState(
      icon: Icons.cloud_off_outlined,
      title: l10n.errorTitle,
      message: errorText(l10n, error),
      actionLabel: l10n.retry,
      onAction: onRetry,
    );
  }
}

/// Grey rounded placeholder shown while a list loads.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    this.height = 72,
    this.radius = TidyRadii.card,
    super.key,
  });

  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
    height: height,
    decoration: BoxDecoration(
      color: TidyColors.line,
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}

class SkeletonList extends StatelessWidget {
  const SkeletonList({this.count = 3, this.height = 72, super.key});

  final int count;
  final double height;

  @override
  Widget build(BuildContext context) => Semantics(
    label: AppLocalizations.of(context).loading,
    child: Column(
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(height: TidySpacing.md),
          SkeletonBox(height: height),
        ],
      ],
    ),
  );
}
