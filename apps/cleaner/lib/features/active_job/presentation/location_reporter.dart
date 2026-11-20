import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_cleaner/core/location/location_service.dart';
import 'package:tidy_cleaner/core/realtime/realtime_gateway.dart';
import 'package:tidy_cleaner/features/jobs/presentation/jobs_controller.dart';
import 'package:tidy_core/tidy_core.dart';

part 'location_reporter.g.dart';

/// Sends the cleaner's position for one booking over the WebSocket every few
/// seconds. The server only accepts it while the booking is on the way, so
/// the caller stops it as soon as that is over, and it also stops itself when
/// the server says `invalid_transition`.
class LocationReporter {
  LocationReporter({
    required this._location,
    required this._gateway,
    this.interval = const Duration(seconds: 5),
  });

  final LocationService _location;
  final RealtimeGateway _gateway;
  final Duration interval;

  String? _bookingId;
  GeoPoint? _last;
  StreamSubscription<GeoPoint>? _positions;
  StreamSubscription<RealtimeEvent>? _events;
  Timer? _timer;

  String? get bookingId => _bookingId;
  bool get isRunning => _bookingId != null;

  /// Starts reporting for [bookingId]; a second call for the same booking
  /// does nothing, a different booking restarts.
  void start(String bookingId) {
    if (_bookingId == bookingId) return;
    stop();
    _bookingId = bookingId;
    _positions = _location.positions().listen(_onPosition, onError: (_) {});
    _events = _gateway.events.listen((event) {
      if (event is RealtimeError && event.code == 'invalid_transition') stop();
    });
    _timer = Timer.periodic(interval, (_) => _send());
  }

  void stop() {
    _timer?.cancel();
    unawaited(_positions?.cancel());
    unawaited(_events?.cancel());
    _timer = null;
    _positions = null;
    _events = null;
    _bookingId = null;
    _last = null;
  }

  void _onPosition(GeoPoint position) {
    final first = _last == null;
    _last = position;
    // Do not make the client wait a full interval for the first point.
    if (first) _send();
  }

  void _send() {
    final id = _bookingId;
    final position = _last;
    if (id == null || position == null) return;
    _gateway.sendLocation(
      bookingId: id,
      lat: position.lat,
      lng: position.lng,
    );
  }
}

@Riverpod(keepAlive: true)
LocationReporter locationReporter(Ref ref) {
  final reporter = LocationReporter(
    location: ref.watch(locationServiceProvider),
    gateway: ref.watch(realtimeGatewayProvider),
  );
  ref.onDispose(reporter.stop);
  return reporter;
}

/// Whether the app is on screen. Position sharing is foreground only, so it
/// pauses when the cleaner leaves the app.
@Riverpod(keepAlive: true)
class AppLifecycle extends _$AppLifecycle {
  late final _observer = _Observer((s) => state = s);

  @override
  AppLifecycleState build() {
    WidgetsBinding.instance.addObserver(_observer);
    ref.onDispose(() => WidgetsBinding.instance.removeObserver(_observer));
    return WidgetsBinding.instance.lifecycleState ?? AppLifecycleState.resumed;
  }
}

class _Observer with WidgetsBindingObserver {
  _Observer(this._onChange);

  final void Function(AppLifecycleState) _onChange;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) => _onChange(state);
}

/// Starts the reporter for the job that is `on_the_way` and stops it when
/// there is none or the app is in the background. Watch it from the shell.
@riverpod
void locationReporting(Ref ref) {
  final reporter = ref.watch(locationReporterProvider);
  final activeId = ref.watch(
    jobsControllerProvider.select(
      (jobs) => jobs.value
          ?.where((j) => j.booking.status == BookingStatus.onTheWay)
          .firstOrNull
          ?.booking
          .id,
    ),
  );
  final foreground =
      ref.watch(appLifecycleProvider) == AppLifecycleState.resumed;

  if (activeId != null && foreground) {
    reporter.start(activeId);
  } else {
    reporter.stop();
  }
}
