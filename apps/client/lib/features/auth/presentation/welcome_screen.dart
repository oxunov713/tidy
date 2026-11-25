import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/error/error_text.dart';
import 'package:tidy_client/core/router/routes.dart';
import 'package:tidy_client/features/auth/presentation/auth_providers.dart';
import 'package:tidy_client/features/auth/presentation/country.dart';
import 'package:tidy_client/features/auth/presentation/widgets/country_picker_sheet.dart';
import 'package:tidy_client/features/auth/presentation/widgets/welcome_art.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_ui/tidy_ui.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  final _phone = TextEditingController();
  Country _country = Country.unitedKingdom;
  bool _sending = false;
  String? _error;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  Future<void> _pickCountry() async {
    final picked = await showCountryPicker(context, selected: _country);
    if (picked != null) setState(() => _country = picked);
  }

  Future<void> _send() async {
    final l10n = AppLocalizations.of(context);
    final phone = toE164(_country, _phone.text);
    if (!isPlausiblePhone(phone)) {
      setState(() => _error = l10n.phoneInvalid);
      return;
    }
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      await ref.read(authControllerProvider.notifier).requestOtp(phone);
      if (mounted) unawaited(context.push(Routes.otpFor(phone)));
    } on Object catch (e) {
      if (mounted) setState(() => _error = errorMessage(context, e));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: TidyColors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 56,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(child: WelcomeArt()),
                        const SizedBox(height: 28),
                        Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: TidyColors.accent,
                                borderRadius: BorderRadius.circular(9),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('tidy', style: text.titleLarge),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.welcomeTitle,
                          style: text.displaySmall?.copyWith(
                            fontSize: 34,
                            height: 1.12,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.welcomeSubtitle,
                          style: text.bodyLarge?.copyWith(
                            color: TidyColors.muted,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.phoneNumber,
                        style: text.labelLarge?.copyWith(
                          color: TidyColors.muted,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _CountryButton(
                            country: _country,
                            onTap: _pickCountry,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _phone,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.done,
                              autofillHints: const [
                                AutofillHints.telephoneNumberNational,
                              ],
                              onSubmitted: (_) => _send(),
                              onChanged: (_) {
                                if (_error != null) {
                                  setState(() => _error = null);
                                }
                              },
                              style: text.bodyLarge,
                              decoration: InputDecoration(
                                hintText: '7700 900123',
                                errorText: _error,
                                errorMaxLines: 2,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 17,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 56,
                        child: TidyButton(
                          label: l10n.sendCode,
                          isLoading: _sending,
                          onPressed: _send,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 56,
                        child: TidyButton(
                          label: l10n.continueWithGoogle,
                          variant: TidyButtonVariant.ghost,
                          icon: Icons.add_circle_outline,
                          onPressed: () =>
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.googleSoon)),
                              ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          l10n.termsNotice,
                          textAlign: TextAlign.center,
                          style: text.bodySmall?.copyWith(
                            color: TidyColors.muted,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CountryButton extends StatelessWidget {
  const _CountryButton({required this.country, required this.onTap});

  final Country country;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: TidyColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: TidyRadii.controlBorder,
        side: BorderSide(color: TidyColors.line),
      ),
      child: InkWell(
        customBorder: const RoundedRectangleBorder(
          borderRadius: TidyRadii.controlBorder,
        ),
        onTap: onTap,
        child: SizedBox(
          height: 54,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  country.dialCode,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.expand_more,
                  size: 18,
                  color: TidyColors.muted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
