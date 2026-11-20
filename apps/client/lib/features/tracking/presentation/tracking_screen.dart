import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/format/formatters.dart';
import 'package:tidy_client/core/providers/map_factory.dart';
import 'package:tidy_client/core/router/routes.dart';
import 'package:tidy_client/core/widgets/cleaner_avatar.dart';
import 'package:tidy_client/core/widgets/error_state.dart';
import 'package:tidy_client/core/widgets/round_icon_button.dart';
import 'package:tidy_client/core/widgets/shimmer.dart';
import 'package:tidy_client/features/bookings/presentation/status_labels.dart';
import 'package:tidy_client/features/tracking/presentation/tracking_controller.dart';
import 'package:tidy_client/features/tracking/presentation/tracking_geometry.dart';
import 'package:tidy_client/features/tracking/presentation/widgets/animated_map.dart';
import 'package:tidy_client/features/tracking/presentation/widgets/progress_steps.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Full-screen map with the cleaner's live position and a bottom sheet with
/// the ETA, progress and a way to contact the cleaner.
class TrackingScreen extends ConsumerWidget {
  const TrackingScreen({required this.bookingId, super.key});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tracking = ref.watch(trackingProvider(bookingId));

    return Scaffold(
      backgroundColor: TidyColors.surface,
      body: tracking.when(
        skipLoadingOnReload: true,
        loading: () => _Frame(
          title: null,
          onBack: () => _back(context),
          map: const ColoredBox(color: TidyColors.surface),
          sheet: const _SheetSkeleton(),
        ),
        error: (error, _) => Stack(
          children: [
            ErrorState(
              error: error,
              onRetry: () => ref.invalidate(trackingProvider(bookingId)),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: RoundIconButton(
                  icon: Icons.chevron_left,
                  tooltip: l10n.back,
                  onPressed: () => _back(context),
                ),
              ),
            ),
          ],
        ),
        data: (state) => _Frame(
          title: l10n.bookingNumber(state.details.booking.code),
          onBack: () => _back(context),
          map: _TrackingMap(state: state),
          sheet: _Sheet(state: state),
        ),
      ),
    );
  }

  void _back(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.home);
    }
  }
}

class _Frame extends StatelessWidget {
  const _Frame({
    required this.title,
    required this.onBack,
    required this.map,
    required this.sheet,
  });

  final String? title;
  final VoidCallback onBack;
  final Widget map;
  final Widget sheet;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Stack(
      children: [
        Positioned.fill(child: map),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RoundIconButton(
                  icon: Icons.chevron_left,
                  tooltip: l10n.back,
                  filled: true,
                  onPressed: onBack,
                ),
                if (title != null)
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: TidyColors.white,
                      borderRadius: TidyRadii.controlBorder,
                      boxShadow: [
                        BoxShadow(
                          color: TidyColors.ink.withValues(alpha: 0.08),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 13,
                      ),
                      child: Text(
                        title!,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Positioned(left: 0, right: 0, bottom: 0, child: sheet),
      ],
    );
  }
}

class _TrackingMap extends ConsumerWidget {
  const _TrackingMap({required this.state});

  final TrackingState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = state.home;
    final cleaner = state.cleanerPosition;
    final showCleaner =
        cleaner != null &&
        (state.status == BookingStatus.onTheWay ||
            state.status == BookingStatus.assigned);

    // Fixed while the marker glides, so the camera does not chase it.
    final center = showCleaner ? midpoint(home, cleaner) : home;
    final zoom = showCleaner
        ? zoomForDistance(distanceKm(home, cleaner))
        : 15.5;
    final map = ref.watch(mapFactoryProvider)(zoom: zoom);

    // The sheet covers the lower part of the screen, so the map is shifted up
    // by padding it with the same space.
    final sheetSpace = MediaQuery.sizeOf(context).height * 0.42;
    return Padding(
      padding: EdgeInsets.only(bottom: sheetSpace - 40),
      child: showCleaner
          ? AnimatedCleanerPosition(
              target: cleaner,
              builder: (context, position) => map.buildMap(
                center: center,
                markers: [
                  MapMarker(id: 'home', position: home),
                  MapMarker(
                    id: 'cleaner',
                    position: position,
                    kind: MapMarkerKind.cleaner,
                  ),
                ],
                route: [position, home],
              ),
            )
          : map.buildMap(
              center: center,
              markers: [MapMarker(id: 'home', position: home)],
            ),
    );
  }
}

class _Sheet extends ConsumerWidget {
  const _Sheet({required this.state});

  final TrackingState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final booking = state.details.booking;
    final cleaner = state.details.cleaner;
    final status = state.status;

    final (caption, headline) = switch (status) {
      BookingStatus.onTheWay => (
        l10n.arrivingIn,
        state.etaMinutes == null
            ? l10n.onTheWayHeadline
            : l10n.minutesShort(state.etaMinutes!),
      ),
      BookingStatus.assigned => (l10n.startsAt, formatClock(booking.start)),
      BookingStatus.inProgress => (l10n.rightNow, l10n.cleaningHeadline),
      BookingStatus.completed => (l10n.finished, l10n.allDone),
      BookingStatus.cancelled => (l10n.bookingLabel, l10n.statusCancelled),
      BookingStatus.pending || BookingStatus.confirmed => (
        l10n.bookingLabel,
        l10n.findingCleaner,
      ),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: TidyColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: TidyColors.ink.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: TidyColors.line,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          caption,
                          style: text.bodySmall?.copyWith(
                            color: TidyColors.muted,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: Text(
                            headline,
                            key: ValueKey(headline),
                            style: text.headlineMedium?.copyWith(fontSize: 30),
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(
                    status: status.tidyStatus,
                    label: status.label(l10n),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ProgressSteps(status: status),
              if (state.accessRevoked) ...[
                const SizedBox(height: 12),
                Text(
                  l10n.trackingEnded,
                  key: const ValueKey('tracking-ended'),
                  style: text.bodySmall?.copyWith(color: TidyColors.muted),
                ),
              ],
              const SizedBox(height: 16),
              if (cleaner != null)
                _CleanerRow(
                  cleaner: cleaner,
                  subtitle:
                      '${cleaner.rating.toStringAsFixed(1)} · ${booking.serviceTitle} · ${formatClock(booking.start)}',
                  canChat: status != BookingStatus.cancelled,
                  onChat: () => context.push(Routes.bookingChat(booking.id)),
                  onCall: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.callUnavailable)),
                  ),
                ),
              const SizedBox(height: 12),
              if (status == BookingStatus.completed)
                TidyButton(
                  label: l10n.rateYourClean,
                  icon: Icons.star_outline,
                  onPressed: () => context.push(Routes.review(booking.id)),
                )
              else
                Center(
                  child: TextButton(
                    onPressed: () => context.push(Routes.booking(booking.id)),
                    child: Text(l10n.needToChange),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CleanerRow extends StatelessWidget {
  const _CleanerRow({
    required this.cleaner,
    required this.subtitle,
    required this.canChat,
    required this.onChat,
    required this.onCall,
  });

  final CleanerCard cleaner;
  final String subtitle;
  final bool canChat;
  final VoidCallback onChat;
  final VoidCallback onCall;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: TidyColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CleanerAvatar(
              name: cleaner.fullName,
              imageUrl: cleaner.avatarUrl,
              size: 48,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cleaner.fullName,
                    style: text.titleSmall?.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodySmall?.copyWith(
                      color: TidyColors.muted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _SquareAction(
              icon: Icons.chat_bubble_outline,
              tooltip: l10n.messageCleaner(cleaner.fullName),
              background: TidyColors.primarySoft,
              foreground: TidyColors.primary,
              onPressed: canChat ? onChat : null,
            ),
            const SizedBox(width: 8),
            _SquareAction(
              icon: Icons.call_outlined,
              tooltip: l10n.callCleaner(cleaner.fullName),
              background: TidyColors.primary,
              foreground: TidyColors.white,
              onPressed: onCall,
            ),
          ],
        ),
      ),
    );
  }
}

class _SquareAction extends StatelessWidget {
  const _SquareAction({
    required this.icon,
    required this.tooltip,
    required this.background,
    required this.foreground,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final Color background;
  final Color foreground;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: TidyRadii.controlBorder,
      child: InkWell(
        borderRadius: TidyRadii.controlBorder,
        onTap: onPressed,
        child: Tooltip(
          message: tooltip,
          child: SizedBox.square(
            dimension: 44,
            child: Icon(icon, size: 20, color: foreground),
          ),
        ),
      ),
    );
  }
}

class _SheetSkeleton extends StatelessWidget {
  const _SheetSkeleton();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: TidyColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Shimmer(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 28, 20, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(width: 90, height: 14),
              SizedBox(height: 10),
              SkeletonBox(width: 140, height: 32),
              SizedBox(height: 20),
              SkeletonBox(height: 12),
              SizedBox(height: 20),
              SkeletonBox(height: 72, radius: 16),
            ],
          ),
        ),
      ),
    );
  }
}
