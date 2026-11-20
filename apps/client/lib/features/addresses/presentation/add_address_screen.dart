import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/error/error_text.dart';
import 'package:tidy_client/core/providers/map_factory.dart';
import 'package:tidy_client/core/widgets/round_icon_button.dart';
import 'package:tidy_client/features/addresses/presentation/address_providers.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Central London, where the demo cleaners work.
const defaultMapCenter = GeoPoint(lat: 51.5238, lng: -0.1586);

class AddAddressScreen extends ConsumerStatefulWidget {
  const AddAddressScreen({super.key});

  @override
  ConsumerState<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends ConsumerState<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _line1 = TextEditingController();
  final _line2 = TextEditingController();
  final _city = TextEditingController(text: 'London');
  final _postcode = TextEditingController();
  final _notes = TextEditingController();
  GeoPoint _pin = defaultMapCenter;
  bool _pinDropped = false;
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_line1, _line2, _city, _postcode, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;
    if (!_pinDropped) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.dropPinFirst)));
      return;
    }
    setState(() => _saving = true);
    try {
      await ref
          .read(addressesProvider.notifier)
          .add(
            AddressInput(
              line1: _line1.text.trim(),
              line2: _line2.text.trim(),
              city: _city.text.trim(),
              postcode: _postcode.text.trim().toUpperCase(),
              lat: _pin.lat,
              lng: _pin.lng,
              accessNotes: _notes.text.trim(),
            ),
          );
      if (mounted) context.pop();
    } on Object catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage(context, e))));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context).fieldRequired;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final map = ref.watch(mapFactoryProvider)(zoom: 16);
    return Scaffold(
      backgroundColor: TidyColors.white,
      body: Column(
        children: [
          SizedBox(
            height: 300,
            child: Stack(
              children: [
                Positioned.fill(
                  child: map.buildMap(
                    center: _pin,
                    markers: _pinDropped
                        ? [MapMarker(id: 'pin', position: _pin)]
                        : const [],
                    onTap: (point) => setState(() {
                      _pin = point;
                      _pinDropped = true;
                    }),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: RoundIconButton(
                        icon: Icons.chevron_left,
                        tooltip: l10n.back,
                        filled: true,
                        onPressed: () => context.pop(),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 12,
                  child: Center(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: TidyColors.white,
                        borderRadius: TidyRadii.pillBorder,
                        boxShadow: [
                          BoxShadow(
                            color: TidyColors.ink.withValues(alpha: 0.12),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _pinDropped
                                  ? Icons.check_circle
                                  : Icons.touch_app_outlined,
                              size: 16,
                              color: TidyColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _pinDropped ? l10n.pinDropped : l10n.tapToDropPin,
                              style: text.labelLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                children: [
                  Text(l10n.addAddressTitle, style: text.titleLarge),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _line1,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    autofillHints: const [AutofillHints.streetAddressLine1],
                    decoration: InputDecoration(labelText: l10n.addressLine1),
                    validator: _required,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _line2,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    autofillHints: const [AutofillHints.streetAddressLine2],
                    decoration: InputDecoration(labelText: l10n.addressLine2),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _city,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(labelText: l10n.city),
                          validator: _required,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _postcode,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.characters,
                          autofillHints: const [AutofillHints.postalCode],
                          decoration: InputDecoration(
                            labelText: l10n.postcode,
                          ),
                          validator: _required,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _notes,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: l10n.accessNotes,
                      hintText: l10n.accessNotesHint,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: TidyButton(
                label: l10n.saveAddress,
                isLoading: _saving,
                onPressed: _save,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
