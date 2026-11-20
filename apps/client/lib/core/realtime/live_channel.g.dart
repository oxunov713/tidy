// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_channel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(liveChannel)
final liveChannelProvider = LiveChannelProvider._();

final class LiveChannelProvider
    extends $FunctionalProvider<LiveChannel, LiveChannel, LiveChannel>
    with $Provider<LiveChannel> {
  LiveChannelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'liveChannelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$liveChannelHash();

  @$internal
  @override
  $ProviderElement<LiveChannel> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LiveChannel create(Ref ref) {
    return liveChannel(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LiveChannel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LiveChannel>(value),
    );
  }
}

String _$liveChannelHash() => r'a2d4156d2673d3da35ef7486a82c624437a90eff';
