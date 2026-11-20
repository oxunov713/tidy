import 'dart:async';

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/features/payment/domain/payment_sheet.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// A card form that looks like a payment sheet but charges nothing. Used while
/// the backend runs with `PAYMENT_PROVIDER=mock`, so the whole flow can be
/// demoed without a Stripe account.
class MockPaymentSheet implements PaymentSheet {
  const MockPaymentSheet({
    this.processingTime = const Duration(milliseconds: 1100),
  });

  final Duration processingTime;

  @override
  bool get isMock => true;

  @override
  Future<PaymentOutcome> present(
    BuildContext context,
    PaymentRequest request,
  ) async {
    final outcome = await showModalBottomSheet<PaymentOutcome>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: TidyColors.white,
      builder: (context) =>
          _MockPaymentForm(request: request, processingTime: processingTime),
    );
    return outcome ?? PaymentOutcome.cancelled;
  }
}

class _MockPaymentForm extends StatefulWidget {
  const _MockPaymentForm({
    required this.request,
    required this.processingTime,
  });

  final PaymentRequest request;
  final Duration processingTime;

  @override
  State<_MockPaymentForm> createState() => _MockPaymentFormState();
}

class _MockPaymentFormState extends State<_MockPaymentForm> {
  final _formKey = GlobalKey<FormState>();
  final _number = TextEditingController(text: '4242 4242 4242 4242');
  final _expiry = TextEditingController(text: '12/28');
  final _cvc = TextEditingController(text: '123');
  bool _processing = false;

  @override
  void dispose() {
    _number.dispose();
    _expiry.dispose();
    _cvc.dispose();
    super.dispose();
  }

  Future<void> _pay() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _processing = true);
    await Future<void>.delayed(widget.processingTime);
    if (mounted) Navigator.of(context).pop(PaymentOutcome.paid);
  }

  bool _hasDigits(String? value, int length) =>
      (value ?? '').replaceAll(RegExp(r'\D'), '').length == length;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final amount = PriceText.format(widget.request.amountPence);
    final invalid = l10n.cardDetailInvalid;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(l10n.payAmount(amount), style: text.titleLarge),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    color: TidyColors.accentSoft,
                    borderRadius: TidyRadii.pillBorder,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    child: _TestModeLabel(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              l10n.testModeNotice,
              style: text.bodySmall?.copyWith(color: TidyColors.muted),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _number,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _CardNumberFormatter(),
              ],
              decoration: InputDecoration(
                labelText: l10n.cardNumber,
                prefixIcon: const Icon(Icons.credit_card_outlined),
              ),
              validator: (v) => _hasDigits(v, 16) ? null : invalid,
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _expiry,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9/]')),
                      LengthLimitingTextInputFormatter(5),
                    ],
                    decoration: InputDecoration(labelText: l10n.cardExpiry),
                    validator: (v) => RegExp(r'^\d{2}/\d{2}$').hasMatch(v ?? '')
                        ? null
                        : invalid,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _cvc,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    decoration: InputDecoration(labelText: l10n.cardCvc),
                    validator: (v) => (v ?? '').length >= 3 ? null : invalid,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TidyButton(
              label: l10n.payAmount(amount),
              isLoading: _processing,
              onPressed: _pay,
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: _processing
                    ? null
                    : () => Navigator.of(context).pop(PaymentOutcome.cancelled),
                child: Text(l10n.cancel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TestModeLabel extends StatelessWidget {
  const _TestModeLabel();

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context).testMode,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: TidyColors.ink,
      ),
    );
  }
}

/// Groups the digits as `1234 5678 9012 3456`.
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final limited = digits.length > 16 ? digits.substring(0, 16) : digits;
    final grouped = [
      for (var i = 0; i < limited.length; i += 4)
        limited.substring(i, i + 4 > limited.length ? limited.length : i + 4),
    ].join(' ');
    return TextEditingValue(
      text: grouped,
      selection: TextSelection.collapsed(offset: grouped.length),
    );
  }
}
