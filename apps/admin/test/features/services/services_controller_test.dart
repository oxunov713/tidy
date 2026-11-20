import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tidy_admin/features/services/presentation/services_providers.dart';
import 'package:tidy_core/tidy_core.dart';

import '../../helpers/fakes.dart';
import '../../helpers/pump_app.dart';

void main() {
  late FakeServicesRepository repo;
  late ProviderContainer container;

  setUp(() {
    repo = FakeServicesRepository([
      service('s1', 'Standard clean'),
      service('s2', 'Office', isActive: false),
    ]);
    container = makeContainer(fakeRepositories(services: repo));
  });

  Future<List<AdminService>> load() =>
      container.read(servicesControllerProvider.future);
  List<AdminService> current() =>
      container.read(servicesControllerProvider).requireValue;

  test('toggling sends the whole service with is_active', () async {
    await load();
    await container
        .read(servicesControllerProvider.notifier)
        .setActive(current().first, active: false);

    final (id, update) = repo.updates.single;
    expect(id, 's1');
    expect(update.isActive, isFalse);
    // The PUT replaces the service, so nothing else may be dropped.
    expect(update.title, 'Standard clean');
    expect(update.basePrice, 4500);
    expect(update.toJson()['is_active'], isFalse);
    expect(current().first.isActive, isFalse);
  });

  test('an inactive service stays inactive when its price is saved', () async {
    await load();
    final office = current().last;
    await container
        .read(servicesControllerProvider.notifier)
        .save(office.id, updateFrom(office).copyWith(basePrice: 6500));

    expect(repo.updates.single.$2.isActive, isFalse);
    expect(repo.updates.single.$2.toJson()['is_active'], isFalse);
    expect(current().last.basePrice, 6500);
  });

  test('a failed toggle puts the switch back and rethrows', () async {
    await load();
    repo.failWith = const ServerException(message: 'boom');

    await expectLater(
      container
          .read(servicesControllerProvider.notifier)
          .setActive(current().first, active: false),
      throwsA(isA<ServerException>()),
    );
    expect(current().first.isActive, isTrue);
  });

  test('a failed save leaves the list untouched', () async {
    await load();
    repo.failWith = const InvalidRequestException(
      message: 'bad',
      details: {'title': 'required'},
    );

    final s = current().first;
    await expectLater(
      container
          .read(servicesControllerProvider.notifier)
          .save(s.id, updateFrom(s).copyWith(title: '')),
      throwsA(isA<InvalidRequestException>()),
    );
    expect(current().first.title, 'Standard clean');
  });
}
