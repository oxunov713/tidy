import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'clock.g.dart';

/// "Now" as a provider so expiry and countdown logic can be tested with a
/// fake clock.
@Riverpod(keepAlive: true)
DateTime Function() clock(Ref ref) => DateTime.now;
