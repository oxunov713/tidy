import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_cleaner/core/errors/error_text.dart';
import 'package:tidy_cleaner/features/jobs/presentation/offers_controller.dart';
import 'package:tidy_cleaner/features/jobs/presentation/widgets/offer_card.dart';
import 'package:tidy_cleaner/l10n/app_localizations.dart';
import 'package:tidy_cleaner/router.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Wraps the signed-in screens. A new offer opens a full-screen card on top of
/// whatever the cleaner is doing, and the result of accept or decline (taken,
/// expired, slot taken) is shown as a message.
class OfferAlertHost extends ConsumerStatefulWidget {
  const OfferAlertHost({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<OfferAlertHost> createState() => _OfferAlertHostState();
}

class _OfferAlertHostState extends ConsumerState<OfferAlertHost> {
  Route<void>? _route;
  String? _shownId;

  void _open(String offerId) {
    final navigator = Navigator.of(context, rootNavigator: true);
    final route = PageRouteBuilder<void>(
      opaque: false,
      barrierColor: TidyColors.ink.withValues(alpha: 0.88),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (_, _, _) => _OfferAlertPage(offerId: offerId),
      transitionsBuilder: (_, animation, _, child) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(0, 0.06),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        ),
      ),
    );
    _route = route;
    _shownId = offerId;
    unawaited(
      navigator.push(route).whenComplete(() {
        _route = null;
        _shownId = null;
        if (mounted) ref.read(offersControllerProvider.notifier).dismissAlert();
      }),
    );
  }

  void _close() {
    final route = _route;
    if (route != null && route.isActive) {
      Navigator.of(context, rootNavigator: true).removeRoute(route);
    }
  }

  void _onNotice(OfferNotice notice) {
    final l10n = AppLocalizations.of(context);
    ref.read(offersControllerProvider.notifier).consumeNotice();
    if (notice is OfferAccepted) {
      _close();
      unawaited(context.push(Routes.job(notice.booking.id)));
      return;
    }
    final message = switch (notice) {
      OfferTaken() => l10n.noticeOfferTaken,
      OfferExpired() => l10n.noticeOfferExpired,
      OfferSlotTaken() => l10n.noticeSlotTaken,
      OfferFailed(:final error) => errorText(l10n, error),
      OfferAccepted() => null,
    };
    if (message == null) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(offersControllerProvider, (previous, next) {
      final alertId = next.alertId;
      if (alertId != null && _route == null) _open(alertId);
      if (_route != null && next.byId(_shownId) == null) _close();
      final notice = next.notice;
      if (notice != null) _onNotice(notice);
    });
    return widget.child;
  }
}

class _OfferAlertPage extends ConsumerWidget {
  const _OfferAlertPage({required this.offerId});

  final String offerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(offersControllerProvider);
    final offer = state.byId(offerId);
    if (offer == null) return const SizedBox.shrink();
    final controller = ref.read(offersControllerProvider.notifier);

    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(TidySpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Semantics(
                  header: true,
                  liveRegion: true,
                  child: Text(
                    l10n.newRequestTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium
                        ?.copyWith(color: TidyColors.white),
                  ),
                ),
                const SizedBox(height: TidySpacing.xl),
                OfferCard(
                  offer: offer,
                  busy: state.busyId == offer.id,
                  onAccept: () => controller.accept(offer.id),
                  onDecline: () => controller.decline(offer.id),
                ),
                const SizedBox(height: TidySpacing.md),
                TextButton(
                  onPressed: () => Navigator.of(
                    context,
                    rootNavigator: true,
                  ).maybePop(),
                  style: TextButton.styleFrom(
                    foregroundColor: TidyColors.white,
                  ),
                  child: Text(l10n.later),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
