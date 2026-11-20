import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_admin/features/services/domain/money.dart';
import 'package:tidy_admin/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Edit form for one service. Prices are typed in pounds and leave as pence
/// in [onSubmit]; `isActive` is always part of the result because the API
/// refuses an update without it.
class ServiceForm extends StatefulWidget {
  const ServiceForm({
    required this.service,
    required this.onSubmit,
    this.busy = false,
    this.fieldErrors = const {},
    this.onCancel,
    super.key,
  });

  final AdminService service;
  final ValueChanged<ServiceUpdate> onSubmit;
  final bool busy;

  /// Messages from the server's `details`, keyed by wire field name.
  final Map<String, String> fieldErrors;
  final VoidCallback? onCancel;

  @override
  State<ServiceForm> createState() => _ServiceFormState();
}

const _maxPence = 1000000; // £10,000

class _ServiceFormState extends State<ServiceForm> {
  final _formKey = GlobalKey<FormState>();
  late final _title = TextEditingController(text: widget.service.title);
  late final _base = TextEditingController(
    text: penceToPounds(widget.service.basePrice),
  );
  late final _bedroom = TextEditingController(
    text: penceToPounds(widget.service.perBedroom),
  );
  late final _bathroom = TextEditingController(
    text: penceToPounds(widget.service.perBathroom),
  );
  late final _baseMinutes = TextEditingController(
    text: '${widget.service.baseMinutes}',
  );
  late final _roomMinutes = TextEditingController(
    text: '${widget.service.minutesPerRoom}',
  );
  late bool _active = widget.service.isActive;

  @override
  void dispose() {
    for (final c in [
      _title,
      _base,
      _bedroom,
      _bathroom,
      _baseMinutes,
      _roomMinutes,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit(
      ServiceUpdate(
        title: _title.text.trim(),
        basePrice: poundsToPence(_base.text)!,
        perBedroom: poundsToPence(_bedroom.text)!,
        perBathroom: poundsToPence(_bathroom.text)!,
        baseMinutes: int.parse(_baseMinutes.text.trim()),
        minutesPerRoom: int.parse(_roomMinutes.text.trim()),
        isActive: _active,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    String? price(String? v, {required bool mustBePositive}) {
      final pence = poundsToPence(v ?? '');
      if (pence == null) return l10n.validationPrice;
      if (mustBePositive && pence == 0) return l10n.validationPricePositive;
      if (pence > _maxPence) return l10n.validationPriceTooHigh;
      return null;
    }

    String? minutes(String? v, {required int min, required int max}) {
      final n = int.tryParse((v ?? '').trim());
      if (n == null || n < min || n > max) {
        return l10n.validationMinutes(min, max);
      }
      return null;
    }

    Widget priceField(
      Key key,
      TextEditingController c,
      String label,
      String wire, {
      bool positive = false,
    }) => TextFormField(
      key: key,
      controller: c,
      enabled: !widget.busy,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,£]'))],
      decoration: InputDecoration(
        labelText: label,
        prefixText: '£ ',
        errorText: widget.fieldErrors[wire],
      ),
      validator: (v) => price(v, mustBePositive: positive),
    );

    Widget minutesField(
      Key key,
      TextEditingController c,
      String label,
      String wire, {
      required int min,
      required int max,
    }) => TextFormField(
      key: key,
      controller: c,
      enabled: !widget.busy,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        suffixText: l10n.minutesSuffix,
        errorText: widget.fieldErrors[wire],
      ),
      validator: (v) => minutes(v, min: min, max: max),
    );

    Widget pair(Widget a, Widget b) => LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 420) {
          return Column(
            children: [
              a,
              const SizedBox(height: TidySpacing.md),
              b,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: a),
            const SizedBox(width: TidySpacing.md),
            Expanded(child: b),
          ],
        );
      },
    );

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            key: const Key('service-title'),
            controller: _title,
            enabled: !widget.busy,
            decoration: InputDecoration(
              labelText: l10n.fieldServiceName,
              errorText: widget.fieldErrors['title'],
            ),
            validator: (v) {
              final t = (v ?? '').trim();
              return t.isEmpty || t.length > 80 ? l10n.validationTitle : null;
            },
          ),
          const SizedBox(height: TidySpacing.md),
          pair(
            priceField(
              const Key('service-base-price'),
              _base,
              l10n.fieldBasePrice,
              'base_price',
              positive: true,
            ),
            minutesField(
              const Key('service-base-minutes'),
              _baseMinutes,
              l10n.fieldBaseMinutes,
              'base_minutes',
              min: 1,
              max: 1440,
            ),
          ),
          const SizedBox(height: TidySpacing.md),
          pair(
            priceField(
              const Key('service-per-bedroom'),
              _bedroom,
              l10n.fieldPerBedroom,
              'per_bedroom',
            ),
            priceField(
              const Key('service-per-bathroom'),
              _bathroom,
              l10n.fieldPerBathroom,
              'per_bathroom',
            ),
          ),
          const SizedBox(height: TidySpacing.md),
          minutesField(
            const Key('service-room-minutes'),
            _roomMinutes,
            l10n.fieldMinutesPerRoom,
            'minutes_per_room',
            min: 0,
            max: 480,
          ),
          const SizedBox(height: TidySpacing.sm),
          SwitchListTile(
            key: const Key('service-active'),
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.fieldActive),
            subtitle: Text(l10n.fieldActiveHint),
            value: _active,
            onChanged: widget.busy ? null : (v) => setState(() => _active = v),
          ),
          const SizedBox(height: TidySpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.onCancel != null) ...[
                TidyButton(
                  label: l10n.cancel,
                  variant: TidyButtonVariant.ghost,
                  expand: false,
                  onPressed: widget.busy ? null : widget.onCancel,
                ),
                const SizedBox(width: TidySpacing.sm),
              ],
              TidyButton(
                key: const Key('service-save'),
                label: l10n.save,
                expand: false,
                isLoading: widget.busy,
                onPressed: _submit,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
