import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_cleaner/core/location/location_service.dart';
import 'package:tidy_cleaner/features/auth/presentation/session_controller.dart';
import 'package:tidy_cleaner/features/jobs/data/cleaner_repositories.dart';
import 'package:tidy_core/tidy_core.dart';

part 'online_controller.g.dart';

/// What happened when the cleaner flipped the switch.
enum OnlineOutcome {
  wentOnline,
  wentOffline,

  /// Location has not been allowed yet: show the rationale screen, then try
  /// again.
  needsPermission,

  /// Location was denied for good: only the system settings help.
  permissionBlocked,

  /// The device's location switch is off.
  locationOff,

  /// No fix or the request failed; see [OnlineState.error].
  failed,
  busy,
}

class OnlineState {
  const OnlineState({this.online = false, this.busy = false, this.error});

  final bool online;
  final bool busy;
  final Object? error;

  OnlineState copyWith({bool? online, bool? busy, Object? error}) =>
      OnlineState(
        online: online ?? this.online,
        busy: busy ?? this.busy,
        error: error,
      );
}

/// The online switch. Going online sends the current position so the server
/// can pick the nearest cleaners for an offer.
@Riverpod(keepAlive: true)
class OnlineController extends _$OnlineController {
  @override
  OnlineState build() {
    ref.watch(currentUserIdProvider);
    final cleaner = ref.read(sessionControllerProvider).value?.cleaner;
    return OnlineState(online: cleaner?.isOnline ?? false);
  }

  Future<OnlineOutcome> setOnline({required bool online}) async {
    if (state.busy) return OnlineOutcome.busy;
    state = state.copyWith(busy: true);
    try {
      GeoPoint? position;
      if (online) {
        final location = ref.read(locationServiceProvider);
        switch (await location.access()) {
          case LocationAccess.granted:
            break;
          case LocationAccess.denied:
            state = state.copyWith(busy: false);
            return OnlineOutcome.needsPermission;
          case LocationAccess.deniedForever:
            state = state.copyWith(busy: false);
            return OnlineOutcome.permissionBlocked;
          case LocationAccess.serviceDisabled:
            state = state.copyWith(busy: false);
            return OnlineOutcome.locationOff;
        }
        position = await location.current();
      }
      await ref
          .read(presenceRepositoryProvider)
          .setOnline(online: online, at: position);
      state = OnlineState(online: online);
      return online ? OnlineOutcome.wentOnline : OnlineOutcome.wentOffline;
    } on Object catch (e) {
      state = OnlineState(online: state.online, error: e);
      return OnlineOutcome.failed;
    }
  }
}
