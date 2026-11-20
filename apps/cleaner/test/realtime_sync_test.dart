import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tidy_cleaner/features/chat/presentation/chat_controller.dart';
import 'package:tidy_cleaner/features/jobs/presentation/jobs_controller.dart';
import 'package:tidy_cleaner/features/jobs/presentation/offers_controller.dart';
import 'package:tidy_core/tidy_core.dart';

import 'support/fixtures.dart' as fx;
import 'support/harness.dart';

Future<void> _settle() =>
    Future<void>.delayed(const Duration(milliseconds: 10));

void main() {
  late Harness h;
  late ProviderContainer c;

  Future<void> start({List<Job>? jobs}) async {
    h = Harness();
    h.jobsRepo.jobs_ = jobs ?? [fx.job()];
    c = await h.container()
      ..listen(jobsControllerProvider, (_, _) {});
    await c.read(jobsControllerProvider.future);
  }

  tearDown(() => c.dispose());

  group('jobs', () {
    test('a reconnect refetches the schedule', () async {
      await start();
      final before = h.jobsRepo.loads;
      h.jobsRepo.jobs_ = [
        fx.job(status: BookingStatus.cancelled),
        fx.job(id: 'b2'),
      ];

      h.gateway.emit(const Reconnected());
      await _settle();

      expect(h.jobsRepo.loads, before + 1);
      final jobs = c.read(jobsControllerProvider).value!;
      expect(jobs.map((j) => j.booking.id), containsAll(['b1', 'b2']));
      expect(
        jobs.firstWhere((j) => j.booking.id == 'b1').booking.status,
        BookingStatus.cancelled,
      );
    });

    test(
      'lost access to a job refetches and does not rejoin its room',
      () async {
        await start();
        final before = h.jobsRepo.loads;
        h.jobsRepo.jobs_ = [];

        h.gateway.emit(
          RoomUnsubscribed(Rooms.booking('b1'), reason: 'access_revoked'),
        );
        await _settle();

        expect(h.jobsRepo.loads, before + 1);
        expect(c.read(jobsControllerProvider).value, isEmpty);
        expect(h.gateway.rooms, isEmpty);
        // The job controller must not send an unsubscribe for a room the
        // server already took away.
        expect(h.gateway.unsubscribeCalls, isEmpty);
      },
    );

    test('a failed refetch keeps the schedule we have', () async {
      await start();
      h.jobsRepo.jobs_ = [];
      h.jobsRepo.failNext = true;

      h.gateway.emit(const Reconnected());
      await _settle();

      expect(c.read(jobsControllerProvider).value, hasLength(1));
    });
  });

  group('offers', () {
    test('a reconnect drops offers the server no longer has', () async {
      h = Harness()..offersRepo.open_ = [fx.offer(), fx.offer(id: 'o2')];
      c = await h.container()
        ..listen(offersControllerProvider, (_, _) {});
      await _settle();
      expect(c.read(offersControllerProvider).offers, hasLength(2));

      h.offersRepo.open_ = [fx.offer(id: 'o2'), fx.offer(id: 'o3')];
      h.gateway.emit(const Reconnected());
      await _settle();

      expect(
        c.read(offersControllerProvider).offers.map((o) => o.id),
        unorderedEquals(['o2', 'o3']),
      );
    });
  });

  group('chat', () {
    Message message(int id, String body) => Message(
      id: id,
      bookingId: 'b1',
      senderId: 'client-1',
      body: body,
      createdAt: fx.now,
    );

    test('a reconnect pulls messages missed while offline', () async {
      h = Harness();
      h.chatRepo.messages = [message(1, 'Hi')];
      c = await h.container()
        ..listen(chatControllerProvider('b1'), (_, _) {});
      await c.read(chatControllerProvider('b1').future);

      h.chatRepo.messages = [message(1, 'Hi'), message(2, 'Gate code 1234')];
      h.gateway.emit(const Reconnected());
      await _settle();

      expect(
        c.read(chatControllerProvider('b1')).value!.map((m) => m.body),
        ['Hi', 'Gate code 1234'],
      );
    });

    test('the room is shared: closing the chat keeps the job room', () async {
      await start();
      final chat = c.listen(chatControllerProvider('b1'), (_, _) {});
      await c.read(chatControllerProvider('b1').future);
      expect(h.gateway.countOf(Rooms.booking('b1')), 2);

      chat.close();
      await _settle();

      expect(h.gateway.countOf(Rooms.booking('b1')), 1);
    });
  });
}
