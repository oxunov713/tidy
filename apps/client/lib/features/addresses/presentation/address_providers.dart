import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_client/features/addresses/data/address_repository_impl.dart';
import 'package:tidy_client/features/addresses/domain/address_repository.dart';
import 'package:tidy_client/features/auth/presentation/auth_providers.dart';
import 'package:tidy_core/tidy_core.dart';

part 'address_providers.g.dart';

@Riverpod(keepAlive: true)
AddressRepository addressRepository(Ref ref) =>
    AddressRepositoryImpl(api: ref.watch(meApiProvider));

/// The user's saved addresses.
@Riverpod(keepAlive: true)
class Addresses extends _$Addresses {
  @override
  Future<List<Address>> build() {
    ref.watch(currentUserIdProvider);
    return ref.watch(addressRepositoryProvider).list();
  }

  Future<Address> add(AddressInput input) async {
    final created = await ref.read(addressRepositoryProvider).add(input);
    state = AsyncData([...?state.value, created]);
    ref.read(selectedAddressIdProvider.notifier).select(created.id);
    return created;
  }

  Future<void> remove(String id) async {
    await ref.read(addressRepositoryProvider).delete(id);
    state = AsyncData([
      for (final a in state.value ?? const <Address>[])
        if (a.id != id) a,
    ]);
  }
}

/// Which address the user picked for new bookings. Null means "the first
/// one", see [currentAddress].
@Riverpod(keepAlive: true)
class SelectedAddressId extends _$SelectedAddressId {
  @override
  String? build() {
    ref.watch(currentUserIdProvider);
    return null;
  }

  // A method reads better at call sites than a setter on a notifier.
  // ignore: use_setters_to_change_properties
  void select(String id) => state = id;
}

/// The address used for the home header and as the default for bookings.
@riverpod
Address? currentAddress(Ref ref) {
  final addresses = ref.watch(addressesProvider).value;
  if (addresses == null || addresses.isEmpty) return null;
  final selected = ref.watch(selectedAddressIdProvider);
  return addresses.firstWhere(
    (a) => a.id == selected,
    orElse: () => addresses.first,
  );
}
