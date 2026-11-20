import 'package:material_ui/material_ui.dart';
import 'package:tidy_admin/core/formatting.dart';
import 'package:tidy_admin/core/labels.dart';
import 'package:tidy_admin/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Below this width the rows turn into cards instead of table rows.
const double kBookingsTableMinWidth = 640;

/// Table of bookings on wide areas, stacked cards on narrow ones. Both draw
/// the same rows, so tapping one behaves the same everywhere.
class BookingsTable extends StatelessWidget {
  const BookingsTable({
    required this.items,
    required this.onSelect,
    this.selectedId,
    this.forceCards = false,
    super.key,
  });

  final List<AdminBooking> items;
  final String? selectedId;
  final ValueChanged<AdminBooking> onSelect;

  /// Use cards even when there is room for the table, for a list that shares
  /// the screen with the details panel.
  final bool forceCards;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final table =
            !forceCards && constraints.maxWidth >= kBookingsTableMinWidth;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (table) const _HeaderRow(),
            for (final row in items)
              _BookingRow(
                key: ValueKey(row.booking.id),
                row: row,
                table: table,
                selected: row.booking.id == selectedId,
                onTap: () => onSelect(row),
              ),
          ],
        );
      },
    );
  }
}

const _idWidth = 88.0;
const _timeWidth = 104.0;
const _statusWidth = 116.0;
const _amountWidth = 84.0;
const _rowPadding = EdgeInsets.symmetric(
  horizontal: TidySpacing.sm,
  vertical: TidySpacing.md,
);

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const style = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: TidyColors.muted,
    );
    Widget cell(String label, {double? width, int flex = 0, TextAlign? align}) {
      final text = Text(label, style: style, textAlign: align);
      return width != null
          ? SizedBox(width: width, child: text)
          : Expanded(flex: flex, child: text);
    }

    return Padding(
      padding: _rowPadding,
      child: Row(
        children: [
          cell(l10n.columnId, width: _idWidth),
          cell(l10n.columnCustomer, flex: 2),
          cell(l10n.columnService, flex: 2),
          cell(l10n.columnTime, width: _timeWidth),
          cell(l10n.columnCleaner, flex: 2),
          cell(l10n.columnStatus, width: _statusWidth),
          cell(l10n.columnAmount, width: _amountWidth, align: TextAlign.right),
        ],
      ),
    );
  }
}

class _BookingRow extends StatelessWidget {
  const _BookingRow({
    required this.row,
    required this.table,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final AdminBooking row;
  final bool table;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final booking = row.booking;
    final cleaner = row.cleanerName.isEmpty ? '—' : row.cleanerName;
    final client = nameOrPhone(row.clientName, row.clientPhone);
    final badge = StatusBadge.fromWire(
      booking.status.wireName,
      label: statusLabel(l10n, booking.status),
    );
    const bold = TextStyle(fontWeight: FontWeight.w600);
    const muted = TextStyle(color: TidyColors.muted);

    Widget text(String value, {TextStyle? style}) =>
        Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: style);

    final content = table
        ? Row(
            children: [
              SizedBox(
                width: _idWidth,
                child: text(booking.code, style: bold),
              ),
              Expanded(flex: 2, child: text(client)),
              Expanded(flex: 2, child: text(booking.serviceTitle)),
              SizedBox(
                width: _timeWidth,
                child: text(
                  formatDateTime(context, booking.start),
                  style: muted,
                ),
              ),
              Expanded(flex: 2, child: text(cleaner)),
              SizedBox(
                width: _statusWidth,
                child: Align(alignment: Alignment.centerLeft, child: badge),
              ),
              SizedBox(
                width: _amountWidth,
                child: Text(
                  PriceText.format(booking.total),
                  textAlign: TextAlign.right,
                  style: bold,
                ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: text(booking.code, style: bold)),
                  badge,
                ],
              ),
              const SizedBox(height: TidySpacing.xs),
              text('$client · ${booking.serviceTitle}'),
              const SizedBox(height: TidySpacing.xs),
              Row(
                children: [
                  Expanded(
                    child: text(
                      '${formatDateTime(context, booking.start)} · $cleaner',
                      style: muted,
                    ),
                  ),
                  Text(PriceText.format(booking.total), style: bold),
                ],
              ),
            ],
          );

    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? TidyColors.primarySoft : Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: TidyColors.line)),
            ),
            child: Padding(padding: _rowPadding, child: content),
          ),
        ),
      ),
    );
  }
}
