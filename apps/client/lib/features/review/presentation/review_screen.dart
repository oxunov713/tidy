import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/error/error_text.dart';
import 'package:tidy_client/core/format/formatters.dart';
import 'package:tidy_client/core/router/routes.dart';
import 'package:tidy_client/core/widgets/async_value_view.dart';
import 'package:tidy_client/core/widgets/cleaner_avatar.dart';
import 'package:tidy_client/core/widgets/round_icon_button.dart';
import 'package:tidy_client/features/bookings/presentation/bookings_providers.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Rating, tags, comment and tip for a finished booking.
class ReviewScreen extends ConsumerStatefulWidget {
  const ReviewScreen({required this.bookingId, super.key});

  final String bookingId;

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  static const _tipOptions = [0, 300, 500, 1000];
  static const _tagIds = ['spotless', 'punctual', 'friendly', 'detail', 'eco'];

  int _rating = 5;
  final _tags = <String>{'spotless', 'punctual'};
  int _tip = 500;
  final _comment = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  String _tagLabel(AppLocalizations l10n, String id) => switch (id) {
    'spotless' => l10n.tagSpotless,
    'punctual' => l10n.tagPunctual,
    'friendly' => l10n.tagFriendly,
    'detail' => l10n.tagDetail,
    _ => l10n.tagEco,
  };

  String _verdict(AppLocalizations l10n) => switch (_rating) {
    1 => l10n.ratingNotGreat,
    2 => l10n.ratingCouldBeBetter,
    3 => l10n.ratingOkay,
    4 => l10n.ratingGood,
    _ => l10n.ratingExcellent,
  };

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _submitting = true);
    try {
      await ref
          .read(bookingRepositoryProvider)
          .review(
            widget.bookingId,
            ReviewRequest(
              rating: _rating,
              tags: _tagIds.where(_tags.contains).toList(),
              comment: _comment.text.trim(),
              tip: _tip,
            ),
          );
      ref.invalidate(bookingDetailsProvider(widget.bookingId));
      messenger.showSnackBar(SnackBar(content: Text(l10n.reviewThanks)));
      if (mounted) _close();
    } on Object catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(errorMessage(context, e))),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _close() => context.canPop() ? context.pop() : context.go(Routes.home);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toString();
    final details = ref.watch(bookingDetailsProvider(widget.bookingId));

    return Scaffold(
      backgroundColor: TidyColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Align(
                alignment: Alignment.centerRight,
                child: RoundIconButton(
                  icon: Icons.close,
                  tooltip: l10n.close,
                  onPressed: _close,
                ),
              ),
            ),
            Expanded(
              child: AsyncValueView<BookingDetails>(
                value: details,
                onRetry: () =>
                    ref.invalidate(bookingDetailsProvider(widget.bookingId)),
                data: (d) {
                  if (d.review != null) {
                    return EmptyState(
                      icon: Icons.check_circle_outline,
                      title: l10n.alreadyReviewed,
                      actionLabel: l10n.close,
                      onAction: _close,
                    );
                  }
                  final name = d.cleaner?.fullName ?? '';
                  final minutes = d.booking.end
                      .difference(d.booking.start)
                      .inMinutes;
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                    children: [
                      Center(
                        child: CleanerAvatar(
                          name: name,
                          imageUrl: d.cleaner?.avatarUrl,
                          size: 88,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        l10n.howWasYourClean,
                        textAlign: TextAlign.center,
                        style: text.headlineMedium?.copyWith(fontSize: 26),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$name · ${formatDayShort(d.booking.start, locale)} · ${l10n.hoursUnit(hoursValue(minutes))}',
                        textAlign: TextAlign.center,
                        style: text.bodyMedium?.copyWith(
                          color: TidyColors.muted,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var n = 1; n <= 5; n++)
                            IconButton(
                              tooltip: l10n.starsLabel(n),
                              iconSize: 40,
                              onPressed: () => setState(() => _rating = n),
                              icon: Icon(
                                n <= _rating
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                color: TidyColors.accent,
                              ),
                            ),
                        ],
                      ),
                      Center(
                        child: Text(
                          _verdict(l10n),
                          style: text.titleSmall?.copyWith(fontSize: 15),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final id in _tagIds)
                            TidyChip(
                              label: _tagLabel(l10n, id),
                              selected: _tags.contains(id),
                              onSelected: (on) => setState(
                                () => on ? _tags.add(id) : _tags.remove(id),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(
                        l10n.anythingElse,
                        style: text.labelLarge?.copyWith(
                          color: TidyColors.muted,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _comment,
                        minLines: 3,
                        maxLines: 4,
                        maxLength: 500,
                        decoration: InputDecoration(
                          hintText: l10n.commentHint(name.split(' ').first),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        l10n.addTip,
                        style: text.labelLarge?.copyWith(
                          color: TidyColors.muted,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          for (final (i, tip) in _tipOptions.indexed) ...[
                            if (i > 0) const SizedBox(width: 8),
                            Expanded(
                              child: Center(
                                child: TidyChip(
                                  label: PriceText.format(tip)
                                      .replaceAll('.00', ''),
                                  selected: _tip == tip,
                                  onSelected: (_) => setState(() => _tip = tip),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            if (details.value?.review == null && details.hasValue)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: SizedBox(
                  height: 56,
                  child: TidyButton(
                    label: l10n.submitReview,
                    isLoading: _submitting,
                    onPressed: _submit,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
