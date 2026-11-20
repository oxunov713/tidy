import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'offer_alerts.g.dart';

/// Called when a new offer arrives while the app is open. Swap the
/// implementation to play a custom sound or a longer vibration pattern.
abstract interface class OfferAlerts {
  Future<void> newOffer();
}

class SystemOfferAlerts implements OfferAlerts {
  const SystemOfferAlerts();

  @override
  Future<void> newOffer() async {
    await SystemSound.play(SystemSoundType.alert);
    await HapticFeedback.heavyImpact();
  }
}

@Riverpod(keepAlive: true)
OfferAlerts offerAlerts(Ref ref) => const SystemOfferAlerts();
