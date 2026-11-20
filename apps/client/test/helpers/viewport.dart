import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// A phone-sized screen (390x844 logical pixels).
void usePhoneScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(390 * 3, 844 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}
