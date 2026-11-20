import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tidy_admin/features/cleaners/presentation/cleaners_providers.dart';
import 'package:tidy_core/tidy_core.dart';

import '../../helpers/fakes.dart';
import '../../helpers/pump_app.dart';

void main() {
  late FakeCleanersRepository repo;
  late ProviderContainer container;

  setUp(() {
    repo = FakeCleanersRepository([
      cleanerUser('1', 'Sarah Jones'),
      cleanerUser('2', 'Tom Clarke', status: CleanerStatus.pending),
      cleanerUser('3', 'Priya Shah', status: CleanerStatus.suspended),
    ]);
    container = makeContainer(fakeRepositories(cleaners: repo));
  });

  Future<CleanersState> load() =>
      container.read(cleanersControllerProvider.future);
  CleanersState current() =>
      container.read(cleanersControllerProvider).requireValue;

  test('groups the cleaners by status for the tabs', () async {
    final state = await load();
    expect(state.count(CleanerStatus.approved), 1);
    expect(state.count(CleanerStatus.pending), 1);
    expect(
      state.withStatus(CleanerStatus.suspended).single.fullName,
      'Priya Shah',
    );
  });

  test(
    'approve moves the cleaner at once, before the server answers',
    () async {
      await load();
      repo.gate = Completer<void>();

      final pending = container
          .read(cleanersControllerProvider.notifier)
          .approve('2');
      await Future<void>.delayed(Duration.zero);

      expect(current().count(CleanerStatus.pending), 0);
      expect(current().count(CleanerStatus.approved), 2);
      expect(current().busy, {'2'});

      repo.gate!.complete();
      await pending;
      expect(repo.approved, ['2']);
      expect(current().busy, isEmpty);
      expect(current().count(CleanerStatus.approved), 2);
    },
  );

  test('a failed approve rolls back and rethrows', () async {
    await load();
    repo.failWith = const ForbiddenException(message: 'nope');

    await expectLater(
      container.read(cleanersControllerProvider.notifier).approve('2'),
      throwsA(isA<ForbiddenException>()),
    );

    expect(current().count(CleanerStatus.pending), 1);
    expect(current().count(CleanerStatus.approved), 1);
    expect(current().busy, isEmpty);
  });

  test('suspend moves an approved cleaner to the suspended tab', () async {
    await load();
    await container.read(cleanersControllerProvider.notifier).suspend('1');

    expect(repo.suspended, ['1']);
    expect(current().count(CleanerStatus.approved), 0);
    expect(current().count(CleanerStatus.suspended), 2);
  });

  test('a second tap while a request is in flight is ignored', () async {
    await load();
    repo.gate = Completer<void>();
    final notifier = container.read(cleanersControllerProvider.notifier);

    final first = notifier.approve('2');
    await Future<void>.delayed(Duration.zero);
    await notifier.approve('2');
    repo.gate!.complete();
    await first;

    expect(repo.approved, ['2']);
  });
}
