import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_cleaner/core/errors/error_text.dart';
import 'package:tidy_cleaner/core/format/formatters.dart';
import 'package:tidy_cleaner/core/maps/maps_launcher.dart';
import 'package:tidy_cleaner/core/theme/pro_colors.dart';
import 'package:tidy_cleaner/core/widgets/async_states.dart';
import 'package:tidy_cleaner/core/widgets/page_header.dart';
import 'package:tidy_cleaner/features/active_job/data/job_local_store.dart';
import 'package:tidy_cleaner/features/active_job/domain/job_transitions.dart';
import 'package:tidy_cleaner/features/active_job/presentation/job_status_controller.dart';
import 'package:tidy_cleaner/features/active_job/presentation/widgets/checklist_card.dart';
import 'package:tidy_cleaner/features/active_job/presentation/widgets/progress_card.dart';
import 'package:tidy_cleaner/features/jobs/presentation/jobs_controller.dart';
import 'package:tidy_cleaner/l10n/app_localizations.dart';
import 'package:tidy_cleaner/router.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// One job: client, address, progress, checklist and the button that moves
/// it to the next status.
class ActiveJobPage extends ConsumerWidget {
  const ActiveJobPage({required this.bookingId, super.key});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final jobs = ref.watch(jobsControllerProvider);

    // Moving a job along can be refused; explain why in a dialog.
    ref.listen(jobStatusControllerProvider(bookingId), (_, next) {
      final failure = next.failure;
      if (failure == null) return;
      ref
          .read(jobStatusControllerProvider(bookingId).notifier)
          .consumeFailure();
      unawaited(_showFailure(context, failure));
    });

    return Scaffold(
      body: switch (jobs) {
        AsyncData(:final value) => _body(context, ref, value),
        AsyncError(:final error) => Column(
          children: [
            PageHeader(title: l10n.navJobs),
            Expanded(
              child: ErrorState(
                error: error,
                onRetry: () => ref.invalidate(jobsControllerProvider),
              ),
            ),
          ],
        ),
        _ => Column(
          children: [
            PageHeader(title: l10n.navJobs),
            const Padding(
              padding: EdgeInsets.all(TidySpacing.xl),
              child: SkeletonList(),
            ),
          ],
        ),
      },
    );
  }

  Widget _body(BuildContext context, WidgetRef ref, List<Job> jobs) {
    final l10n = AppLocalizations.of(context);
    final job = jobs.where((j) => j.booking.id == bookingId).firstOrNull;
    if (job == null) {
      return Column(
        children: [
          PageHeader(title: l10n.navJobs),
          Expanded(
            child: EmptyState(
              icon: Icons.search_off,
              title: l10n.jobNotFound,
              message: l10n.jobNotFoundBody,
            ),
          ),
        ],
      );
    }
    return _JobView(job: job);
  }

  Future<void> _showFailure(BuildContext context, JobFailure failure) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final (title, body) = switch (failure) {
      TooEarly(:final availableFrom) => (
        l10n.tooEarlyTitle,
        l10n.tooEarlyBody(Fmt.time(availableFrom, locale)),
      ),
      OutOfSync() => (l10n.errorTitle, l10n.transitionOutOfSync),
      RequestFailed(:final error) => (l10n.errorTitle, errorText(l10n, error)),
    };
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }
}

class _JobView extends ConsumerWidget {
  const _JobView({required this.job});

  final Job job;

  Future<void> _advance(BuildContext context, WidgetRef ref) async {
    final booking = job.booking;
    if (nextStatus(booking.status) == BookingStatus.completed) {
      final l10n = AppLocalizations.of(context);
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.finishConfirmTitle),
          content: Text(l10n.finishConfirmBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              key: const Key('confirmFinish'),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.finishConfirmAction),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }
    await ref.read(jobStatusControllerProvider(booking.id).notifier).advance();
  }

  Future<void> _openMaps(BuildContext context, WidgetRef ref) async {
    final opened = await ref
        .read(mapsLauncherProvider)
        .open(
          lat: job.address.lat,
          lng: job.address.lng,
          label: job.address.line1,
        );
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).mapsFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final now = ref.watch(clockProvider)();
    final booking = job.booking;
    final action = ref.watch(jobStatusControllerProvider(booking.id));
    final times = {
      ...ref.watch(jobLocalStoreProvider).times(booking.id),
      // Right after accepting, the update time is when the job was accepted.
      if (booking.status == BookingStatus.assigned)
        BookingStatus.assigned: booking.updatedAt,
    };

    final start = booking.start.toLocal();
    final when = Fmt.sameDay(start, now)
        ? '${l10n.todayLower} ${Fmt.time(booking.start, locale)}'
        : '${Fmt.shortDate(booking.start, locale)} ${Fmt.time(booking.start, locale)}';

    final cta = switch (booking.status) {
      BookingStatus.assigned => l10n.ctaOnMyWay,
      BookingStatus.onTheWay => l10n.ctaStart,
      BookingStatus.inProgress => l10n.ctaFinish,
      _ => l10n.ctaDone,
    };
    final finished = nextStatus(booking.status) == null;

    return Column(
      children: [
        PageHeader(
          title: booking.serviceTitle,
          subtitle: l10n.jobTitleMeta(
            booking.code,
            when,
            Fmt.payout(booking.cleanerPayout),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            children: [
              _ClientCard(
                job: job,
                onMaps: () => _openMaps(context, ref),
                onChat: () => context.push(Routes.chat(booking.id)),
              ),
              const SizedBox(height: 14),
              ProgressCard(status: booking.status, times: times),
              const SizedBox(height: 14),
              ChecklistCard(booking: booking),
              const SizedBox(height: 14),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
            20,
            14,
            20,
            14 + MediaQuery.paddingOf(context).bottom,
          ),
          decoration: const BoxDecoration(
            color: TidyColors.white,
            border: Border(top: BorderSide(color: TidyColors.line)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (booking.status == BookingStatus.onTheWay)
                Padding(
                  padding: const EdgeInsets.only(bottom: TidySpacing.sm),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.podcasts,
                        size: 16,
                        color: TidyColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          l10n.sharingLocation(job.clientName),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: TidyColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              if (booking.status == BookingStatus.assigned)
                Padding(
                  padding: const EdgeInsets.only(bottom: TidySpacing.sm),
                  child: Text(
                    l10n.hintThreeHours,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: TidyColors.muted,
                    ),
                  ),
                ),
              SizedBox(
                height: 56,
                child: TidyButton(
                  key: const Key('jobCta'),
                  label: cta,
                  isLoading: action.busy,
                  onPressed: finished ? null : () => _advance(context, ref),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ClientCard extends StatelessWidget {
  const _ClientCard({
    required this.job,
    required this.onMaps,
    required this.onChat,
  });

  final Job job;
  final VoidCallback onMaps;
  final VoidCallback onChat;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final address = job.address;
    final line = [
      address.line1,
      if (address.line2.isNotEmpty) address.line2,
      address.postcode,
    ].join(', ');

    return TidyCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Avatar(name: job.clientName),
              const SizedBox(width: TidySpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.clientName,
                      style: text.titleSmall?.copyWith(fontSize: 15),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      line,
                      style: text.bodySmall?.copyWith(
                        fontSize: 13,
                        color: TidyColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              Semantics(
                button: true,
                label: l10n.messageClient(job.clientName),
                child: Material(
                  color: TidyColors.primarySoft,
                  shape: const RoundedRectangleBorder(
                    borderRadius: TidyRadii.controlBorder,
                  ),
                  child: InkWell(
                    key: const Key('openChat'),
                    customBorder: const RoundedRectangleBorder(
                      borderRadius: TidyRadii.controlBorder,
                    ),
                    onTap: onChat,
                    child: const SizedBox.square(
                      dimension: 44,
                      child: Icon(
                        Icons.chat_bubble_outline,
                        size: 20,
                        color: TidyColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (address.accessNotes.isNotEmpty) ...[
            const SizedBox(height: TidySpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: TidyColors.accentSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                address.accessNotes,
                style: const TextStyle(
                  fontSize: 13,
                  color: ProColors.onAccentSoftDeep,
                ),
              ),
            ),
          ],
          const SizedBox(height: TidySpacing.md),
          TidyButton(
            key: const Key('openMaps'),
            label: l10n.openInMaps,
            icon: Icons.near_me_outlined,
            variant: TidyButtonVariant.ghost,
            onPressed: onMaps,
          ),
        ],
      ),
    );
  }
}
