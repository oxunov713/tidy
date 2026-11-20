import 'package:fake_async/fake_async.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tidy_cleaner/features/active_job/presentation/location_reporter.dart';
import 'package:tidy_cleaner/features/jobs/presentation/jobs_controller.dart';
import 'package:tidy_core/tidy_core.dart';

import 'support/fakes.dart';
import 'support/fixtures.dart' as fx;
import 'support/harness.dart';

void main() {
  group('LocationReporter', () {
    late FakeGateway gateway;
    late FakeLocation location;
    late LocationReporter reporter;

    void withReporter(void Function(FakeAsync async) body) {
      fakeAsync((async) {
        gateway = FakeGateway();
        location = FakeLocation();
        reporter = LocationReporter(location: location, gateway: gateway);
        body(async);
        reporter.stop();
      });
    }

    test('sends the first fix at once, then every 5 seconds', () {
      withReporter((async) {
        reporter.start('b1');
        location.move(51.5, -0.1);
        async.flushMicrotasks();
        expect(gateway.sent, hasLength(1));
        expect(gateway.sent.single.bookingId, 'b1');
        expect(gateway.sent.single.lat, 51.5);

        async.elapse(const Duration(seconds: 5));
        expect(gateway.sent, hasLength(2));
        async.elapse(const Duration(seconds: 10));
        expect(gateway.sent, hasLength(4));
      });
    });

    test('always sends the latest position', () {
      withReporter((async) {
        reporter.start('b1');
        location
          ..move(51.5, -0.1)
          ..move(51.6, -0.2);
        async
          ..flushMicrotasks()
          ..elapse(const Duration(seconds: 5));
        expect(gateway.sent.last.lat, 51.6);
        expect(gateway.sent.last.lng, -0.2);
      });
    });

    test('sends nothing before the first fix', () {
      withReporter((async) {
        reporter.start('b1');
        async.elapse(const Duration(seconds: 20));
        expect(gateway.sent, isEmpty);
      });
    });

    test('stops sending after stop()', () {
      withReporter((async) {
        reporter.start('b1');
        location.move(51.5, -0.1);
        async.elapse(const Duration(seconds: 6));
        final before = gateway.sent.length;

        reporter.stop();
        location.move(51.7, -0.3);
        async.elapse(const Duration(seconds: 30));

        expect(gateway.sent, hasLength(before));
        expect(reporter.isRunning, isFalse);
      });
    });

    test('stops when the server rejects the location', () {
      withReporter((async) {
        reporter.start('b1');
        location.move(51.5, -0.1);
        async.flushMicrotasks();

        gateway.emit(
          const RealtimeError(
            code: 'invalid_transition',
            message: 'not on the way',
          ),
        );
        async.flushMicrotasks();
        expect(reporter.isRunning, isFalse);

        final before = gateway.sent.length;
        async.elapse(const Duration(seconds: 20));
        expect(gateway.sent, hasLength(before));
      });
    });

    test('other socket errors do not stop it', () {
      withReporter((async) {
        reporter.start('b1');
        gateway.emit(const RealtimeError(code: 'forbidden', message: 'no'));
        async.flushMicrotasks();
        expect(reporter.isRunning, isTrue);
      });
    });

    test('starting the same booking twice keeps one stream', () {
      withReporter((async) {
        reporter
          ..start('b1')
          ..start('b1');
        location.move(51.5, -0.1);
        async.flushMicrotasks();
        expect(gateway.sent, hasLength(1));
      });
    });

    test('switching to another booking restarts and forgets the old fix', () {
      withReporter((async) {
        reporter.start('b1');
        location.move(51.5, -0.1);
        async.flushMicrotasks();

        reporter.start('b2');
        async.elapse(const Duration(seconds: 5));
        // No fix yet for b2, so nothing was sent for it.
        expect(gateway.sent.where((s) => s.bookingId == 'b2'), isEmpty);

        location.move(52, 0);
        async.flushMicrotasks();
        expect(gateway.sent.last.bookingId, 'b2');
      });
    });
  });

  group('locationReporting provider', () {
    late Harness h;
    late ProviderContainer c;

    Future<void> open(List<Job> jobs) async {
      h = Harness();
      h.jobsRepo.jobs_ = jobs;
      c = await h.container();
      await c.read(jobsControllerProvider.future);
      c.listen(locationReportingProvider, (_, _) {});
    }

    tearDown(() => c.dispose());

    test('reports only for the job that is on the way', () async {
      await open([
        fx.job(),
        fx.job(id: 'b2', status: BookingStatus.onTheWay),
      ]);
      expect(c.read(locationReporterProvider).bookingId, 'b2');
    });

    test('is idle when no job is on the way', () async {
      await open([
        fx.job(),
        fx.job(id: 'b2', status: BookingStatus.inProgress),
      ]);
      expect(c.read(locationReporterProvider).isRunning, isFalse);
    });

    test('stops when the job moves on to in_progress', () async {
      await open([fx.job(status: BookingStatus.onTheWay)]);
      expect(c.read(locationReporterProvider).isRunning, isTrue);

      c
          .read(jobsControllerProvider.notifier)
          .applyBooking(fx.booking(status: BookingStatus.inProgress));
      await Future<void>.delayed(Duration.zero);

      expect(c.read(locationReporterProvider).isRunning, isFalse);
    });

    test('pauses in the background and resumes in the foreground', () async {
      await open([fx.job(status: BookingStatus.onTheWay)]);
      final reporter = c.read(locationReporterProvider);
      expect(reporter.isRunning, isTrue);

      TestWidgetsFlutterBinding.ensureInitialized();
      WidgetsBinding.instance.handleAppLifecycleStateChanged(
        AppLifecycleState.paused,
      );
      await Future<void>.delayed(Duration.zero);
      expect(reporter.isRunning, isFalse);

      WidgetsBinding.instance.handleAppLifecycleStateChanged(
        AppLifecycleState.resumed,
      );
      await Future<void>.delayed(Duration.zero);
      expect(reporter.isRunning, isTrue);
    });
  });
}
