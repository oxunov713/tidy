// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(addressRepository)
final addressRepositoryProvider = AddressRepositoryProvider._();

final class AddressRepositoryProvider
    extends
        $FunctionalProvider<
          AddressRepository,
          AddressRepository,
          AddressRepository
        >
    with $Provider<AddressRepository> {
  AddressRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addressRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addressRepositoryHash();

  @$internal
  @override
  $ProviderElement<AddressRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AddressRepository create(Ref ref) {
    return addressRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddressRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddressRepository>(value),
    );
  }
}

String _$addressRepositoryHash() => r'91ab332a1df980d88938a8d3eebde7c0cfbb1bcf';

/// The user's saved addresses.

@ProviderFor(Addresses)
final addressesProvider = AddressesProvider._();

/// The user's saved addresses.
final class AddressesProvider
    extends $AsyncNotifierProvider<Addresses, List<Address>> {
  /// The user's saved addresses.
  AddressesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addressesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addressesHash();

  @$internal
  @override
  Addresses create() => Addresses();
}

String _$addressesHash() => r'715c14c5631228822194f634af2afc95b6c0cccc';

/// The user's saved addresses.

abstract class _$Addresses extends $AsyncNotifier<List<Address>> {
  FutureOr<List<Address>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Address>>, List<Address>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Address>>, List<Address>>,
              AsyncValue<List<Address>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Which address the user picked for new bookings. Null means "the first
/// one", see [currentAddress].

@ProviderFor(SelectedAddressId)
final selectedAddressIdProvider = SelectedAddressIdProvider._();

/// Which address the user picked for new bookings. Null means "the first
/// one", see [currentAddress].
final class SelectedAddressIdProvider
    extends $NotifierProvider<SelectedAddressId, String?> {
  /// Which address the user picked for new bookings. Null means "the first
  /// one", see [currentAddress].
  SelectedAddressIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedAddressIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedAddressIdHash();

  @$internal
  @override
  SelectedAddressId create() => SelectedAddressId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedAddressIdHash() => r'a48729f1033fa733fd5d46bc0b32a430a9b20e0b';

/// Which address the user picked for new bookings. Null means "the first
/// one", see [currentAddress].

abstract class _$SelectedAddressId extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The address used for the home header and as the default for bookings.

@ProviderFor(currentAddress)
final currentAddressProvider = CurrentAddressProvider._();

/// The address used for the home header and as the default for bookings.

final class CurrentAddressProvider
    extends $FunctionalProvider<Address?, Address?, Address?>
    with $Provider<Address?> {
  /// The address used for the home header and as the default for bookings.
  CurrentAddressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentAddressProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentAddressHash();

  @$internal
  @override
  $ProviderElement<Address?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Address? create(Ref ref) {
    return currentAddress(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Address? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Address?>(value),
    );
  }
}

String _$currentAddressHash() => r'1915745f7d9ea7d002177f4e40b42afd77b94c2a';
