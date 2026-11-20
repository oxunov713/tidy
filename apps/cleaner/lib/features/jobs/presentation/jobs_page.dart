import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_cleaner/core/errors/error_text.dart';
import 'package:tidy_cleaner/core/format/formatters.dart';
import 'package:tidy_cleaner/core/location/location_service.dart';
import 'package:tidy_cleaner/core/widgets/async_states.dart';
import 'package:tidy_cleaner/core/widgets/pro_logo.dart';
import 'package:tidy_cleaner/features/auth/presentation/session_controller.dart';
import 'package:tidy_cleaner/features/earnings/presentation/earnings_controller.dart';
import 'package:tidy_cleaner/features/jobs/presentation/day_stats.dart';
import 'package:tidy_cleaner/features/jobs/presentation/jobs_controller.dart';
import 'package:tidy_cleaner/features/jobs/presentation/offers_controller.dart';
import 'package:tidy_cleaner/features/jobs/presentation/online_controller.dart';
import 'package:tidy_cleaner/features/jobs/presentation/widgets/next_up_tile.dart';
import 'package:tidy_cleaner/features/jobs/presentation/widgets/offer_card.dart';
import 'package:tidy_cleaner/features/jobs/presentation/widgets/online_switch.dart';
import 'package:tidy_cleaner/features/jobs/presentation/widgets/stat_tile.dart';
import 'package:tidy_cleaner/l10n/app_localizations.dart';
import 'package:tidy_cleaner/router.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Home tab: online switch, today's numbers, the open offer and what is next.
class JobsPage extends ConsumerWidget {
  const JobsPage({super.key});

  Future<void> _toggle(BuildContext context, WidgetRef ref, bool want) async {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(onlineControllerProvider.notifier);
    var outcome = await controller.setOnline(online: want);

    if (outcome == OnlineOutcome.needsPermission && context.mounted) {
      final granted = await context.push<bool>(Routes.locationPermission);
      if (granted ?? false) {
        outcome = await controller.setOnline(online: true);
      } else {
        return;
      }
    }
    if (!context.mounted) return;

    final message = switch (outcome) {
      OnlineOutcome.permissionBlocked => l10n.permissionBlockedBody,
      OnlineOutcome.locationOff => l10n.noticeLocationOff,
      OnlineOutcome.failed =>
        ref.read(onlineControllerProvider).error is LocationUnavailableException
            ? l10n.noticeLocationUnavailable
            : errorText(l10n, ref.read(onlineControllerProvider).error!),
      _ => null,
    };
    if (message == null) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          action: outcome == OnlineOutcome.permissionBlocked
              ? SnackBarAction(
                  label: l10n.openSettings,
                  onPressed: () =>
                      ref.read(locationServiceProvider).openSettings(),
                )
              : null,
        ),
      );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final online = ref.watch(onlineControllerProvider);
    final offers = ref.watch(offersControllerProvider);
    final jobs = ref.watch(jobsControllerProvider);
    final now = ref.watch(clockProvider)();

    Future<void> refresh() async {
      ref.invalidate(earningsProvider);
      await Future.wait([
        ref
            .read(jobsControllerProvider.notifier)
            .refresh()
            .onError<Object>(
              (_, _) {},
            ),
        ref.read(offersControllerProvider.notifier).load(),
      ]);
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Column(
        children: [
          _Header(
            online: online.online,
            busy: online.busy,
            onChanged: (want) => _toggle(context, ref, want),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(TidySpacing.xl),
                children: [
                  if (!online.online)
                    _InfoCard(
                      title: l10n.offlineTitle,
                      body: l10n.offlineBody,
                    )
                  else if (offers.offers.isNotEmpty)
                    for (final offer in offers.offers) ...[
                      OfferCard(
                        offer: offer,
                        busy: offers.busyId == offer.id,
                        onAccept: () => ref
                            .read(offersControllerProvider.notifier)
                            .accept(offer.id),
                        onDecline: () => ref
                            .read(offersControllerProvider.notifier)
                            .decline(offer.id),
                      ),
                      const SizedBox(height: 14),
                    ]
                  else
                    _InfoCard(
                      title: l10n.waitingTitle,
                      body: l10n.waitingBody,
                    ),
                  const SizedBox(height: TidySpacing.xs),
                  Text(
                    l10n.nextUp,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...switch (jobs) {
                    AsyncData(:final value) => _nextUp(
                      context,
                      ref,
                      nextUp(value, now),
                      now,
                    ),
                    AsyncError(:final error) => [
                      ErrorState(
                        error: error,
                        onRetry: () => ref.invalidate(jobsControllerProvider),
                      ),
                    ],
                    _ => const [SkeletonList(count: 2)],
                  },
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _nextUp(
    BuildContext context,
    WidgetRef ref,
    List<Job> jobs,
    DateTime now,
  ) {
    final l10n = AppLocalizations.of(context);
    if (jobs.isEmpty) {
      return [
        _InfoCard(title: l10n.noUpcomingTitle, body: l10n.noUpcomingBody),
      ];
    }
    return [
      for (final job in jobs) ...[
        NextUpTile(
          job: job,
          now: now,
          onTap: () => context.push(Routes.job(job.booking.id)),
        ),
        const SizedBox(height: 10),
      ],
    ];
  }
}

class _Header extends ConsumerWidget {
  const _Header({
    required this.online,
    required this.busy,
    required this.onChanged,
  });

  final bool online;
  final bool busy;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final stats = ref.watch(dayStatsProvider);
    final rating = ref.watch(
      sessionControllerProvider.select((s) => s.value?.cleaner?.rating),
    );
    const dash = '–';

    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.paddingOf(context).top + 20,
        20,
        24,
      ),
      decoration: const BoxDecoration(
        color: TidyColors.ink,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ProLogo(onDark: true),
              OnlineSwitch(online: online, busy: busy, onChanged: onChanged),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: StatTile(
                  label: l10n.statToday,
                  value: stats.earned == null
                      ? dash
                      : Fmt.poundsShort(stats.earned!),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatTile(
                  label: l10n.statJobs,
                  value: stats.total == null
                      ? dash
                      : l10n.jobsDoneOfTotal(stats.done ?? 0, stats.total!),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatTile(
                  label: l10n.statRating,
                  value: rating == null || rating == 0
                      ? dash
                      : rating.toStringAsFixed(1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(TidySpacing.xl),
      decoration: BoxDecoration(
        color: TidyColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(title, style: text.titleLarge?.copyWith(fontSize: 18)),
          const SizedBox(height: TidySpacing.sm),
          Text(
            body,
            textAlign: TextAlign.center,
            style: text.bodyMedium?.copyWith(color: TidyColors.muted),
          ),
        ],
      ),
    );
  }
}
