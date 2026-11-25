import 'dart:async';

import 'package:material_ui/material_ui.dart';

/// Rebuilds [builder] every second with the time left until [until].
///
/// [now] is where "now" comes from, so tests (and apps with an injectable
/// clock) can freeze time. The remaining time never goes below zero.
class Countdown extends StatefulWidget {
  const Countdown({
    required this.until,
    required this.builder,
    this.now = DateTime.now,
    super.key,
  });

  final DateTime until;
  final Widget Function(BuildContext context, Duration remaining) builder;
  final DateTime Function() now;

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final left = widget.until.difference(widget.now());
    return widget.builder(context, left.isNegative ? Duration.zero : left);
  }
}
