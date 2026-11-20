// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(paymentSheet)
final paymentSheetProvider = PaymentSheetProvider._();

final class PaymentSheetProvider
    extends $FunctionalProvider<PaymentSheet, PaymentSheet, PaymentSheet>
    with $Provider<PaymentSheet> {
  PaymentSheetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paymentSheetProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paymentSheetHash();

  @$internal
  @override
  $ProviderElement<PaymentSheet> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PaymentSheet create(Ref ref) {
    return paymentSheet(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PaymentSheet value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PaymentSheet>(value),
    );
  }
}

String _$paymentSheetHash() => r'f1e9fd2199dfa1f1985ef5c33f6510fdbde585f2';
