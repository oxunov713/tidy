import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_admin/core/formatting.dart';
import 'package:tidy_core/tidy_core.dart';

Future<String> _render(
  WidgetTester tester,
  String Function(BuildContext) text,
) async {
  late String out;
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) {
          out = text(context);
          return const SizedBox();
        },
      ),
    ),
  );
  return out;
}

void main() {
  setUpAll(initializeDateFormatting);
  tearDown(BusinessTime.reset);

  testWidgets('times show on the business clock, not the computer clock', (
    tester,
  ) async {
    final start = DateTime.utc(2026, 7, 1, 9);
    expect(await _render(tester, (c) => formatTime(c, start)), '10:00');

    BusinessTime.useZone('Asia/Tashkent');
    expect(await _render(tester, (c) => formatTime(c, start)), '14:00');
  });

  testWidgets('a late evening instant lands on the next business day', (
    tester,
  ) async {
    BusinessTime.useZone('Asia/Tashkent');
    final late = DateTime.utc(2026, 12, 3, 20);
    expect(
      await _render(tester, (c) => formatLongDate(c, late)),
      contains('4'),
    );
  });
}
