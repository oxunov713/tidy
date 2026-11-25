import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/features/booking_wizard/presentation/widgets/day_strip.dart';

void main() {
  setUpAll(initializeDateFormatting);

  testWidgets('seven consecutive calendar days, also over a clock change', (
    tester,
  ) async {
    DateTime? picked;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DayStrip(
            // The UK clocks went back on 25 October 2026.
            today: DateTime(2026, 10, 25),
            selected: DateTime(2026, 10, 27),
            locale: 'en',
            onSelected: (d) => picked = d,
          ),
        ),
      ),
    );

    for (final day in ['25', '26', '27', '28', '29', '30', '31']) {
      expect(find.text(day), findsOneWidget, reason: day);
    }
    await tester.tap(find.text('29'));
    expect(picked, DateTime(2026, 10, 29));
  });
}
