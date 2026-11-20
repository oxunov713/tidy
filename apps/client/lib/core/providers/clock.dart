import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'clock.g.dart';

/// "Now", as a function so tests can freeze it.
typedef Clock = DateTime Function();

@Riverpod(keepAlive: true)
Clock clock(Ref ref) => DateTime.now;
