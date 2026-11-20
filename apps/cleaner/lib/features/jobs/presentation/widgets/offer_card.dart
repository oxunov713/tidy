import 'package:material_ui/material_ui.dart';
import 'package:tidy_cleaner/core/format/formatters.dart';
import 'package:tidy_cleaner/core/theme/pro_colors.dart';
import 'package:tidy_cleaner/core/widgets/countdown.dart';
import 'package:tidy_cleaner/features/jobs/domain/incoming_offer.dart';
import 'package:tidy_cleaner/features/jobs/presentation/widgets/booking_text.dart';
import 'package:tidy_cleaner/l10n/app_localizations.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// An offer with its countdown and the accept / decline buttons. Used inline
/// on the Jobs screen and inside the full-screen alert.
class OfferCard extends StatelessWidget {
  const OfferCard({
    required this.offer,
    required this.busy,
    required this.onAccept,
    required this.onDecline,
    super.key,
  });

  final IncomingOffer offer;
  final bool busy;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final text = Theme.of(context).textTheme;
    final booking = offer.booking;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: TidyColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: TidyColors.primary, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DecoratedBox(
                decoration: const BoxDecoration(
                  color: TidyColors.accentSoft,
                  borderRadius: TidyRadii.pillBorder,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  child: Text(
                    l10n.newRequest,
                    style: const TextStyle(
                      color: ProColors.onAccentSoft,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Countdown(
                until: offer.expiresAt,
                builder: (context, left) => Text(
                  l10n.expiresIn(Fmt.countdown(left)),
                  key: const Key('offerCountdown'),
                  style: text.labelLarge?.copyWith(color: TidyColors.muted),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.serviceTitle,
                      style: text.titleLarge?.copyWith(fontSize: 22),
                    ),
                    const SizedBox(height: TidySpacing.xs),
                    Text(
                      bookingSummary(l10n, booking),
                      style: text.bodyMedium?.copyWith(color: TidyColors.muted),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Fmt.payout(booking.cleanerPayout),
                    style: text.titleLarge?.copyWith(
                      fontSize: 24,
                      color: TidyColors.primary,
                    ),
                  ),
                  Text(
                    l10n.yourPayout,
                    style: text.bodySmall?.copyWith(color: TidyColors.muted),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(TidySpacing.md),
            decoration: const BoxDecoration(
              color: TidyColors.surface,
              borderRadius: TidyRadii.controlBorder,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(
                  icon: Icons.calendar_today_outlined,
                  text:
                      '${Fmt.shortDate(booking.start, locale)} · '
                      '${Fmt.timeRange(booking.start, booking.end, locale)}',
                ),
                const SizedBox(height: TidySpacing.sm),
                _InfoRow(
                  icon: Icons.place_outlined,
                  text: _place(l10n, offer),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: TidyButton(
                  key: const Key('declineOffer'),
                  label: l10n.decline,
                  variant: TidyButtonVariant.ghost,
                  onPressed: busy ? null : onDecline,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TidyButton(
                  key: const Key('acceptOffer'),
                  label: l10n.accept,
                  isLoading: busy,
                  onPressed: onAccept,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _place(AppLocalizations l10n, IncomingOffer offer) {
    final area = [
      offer.city,
      offer.postcode,
    ].whereType<String>().where((s) => s.isNotEmpty).join(', ');
    final km = offer.distanceKm;
    if (area.isEmpty || km == null) return l10n.offerPlaceLoading;
    return l10n.offerPlaceDistance(area, km.toStringAsFixed(1));
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 16, color: TidyColors.primary),
      const SizedBox(width: TidySpacing.sm),
      Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
    ],
  );
}
