# tidy_ui

Design tokens, the Material 3 theme and the shared widgets used by the Tidy
client, cleaner and admin apps. It has no dependency on `tidy_core`.

## Use

```dart
import 'package:tidy_ui/tidy_ui.dart';

MaterialApp(theme: TidyTheme.light(), home: ...);
```

`TidyTheme.light()` loads Space Grotesk (headings) and Inter (body) through
`google_fonts`, so the first launch needs network access unless you bundle the
fonts as assets.

## What's in it

- Tokens: `TidyColors`, `TidyRadii` (20 / 14 / pill), `TidySpacing`.
- `TidyButton` (primary, secondary, ghost, loading), `TidyChip`, `TidyCard`,
  `TidyStepper`, `StatusBadge` (+ `TidyStatus`), `Avatar`, `PriceText`
  (pence to `£68.00`), `SectionHeader`, `BottomNavBar`, `EmptyState`.

Money is formatted with integer maths only. `StatusBadge` takes the API's wire
names (`on_the_way`, `in_progress`, ...) through `StatusBadge.fromWire`.

## Gallery and tests

```bash
cd example && flutter run -d chrome   # widget gallery
flutter test                          # from this directory
```
