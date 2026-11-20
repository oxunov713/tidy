import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_cleaner/core/errors/error_text.dart';
import 'package:tidy_cleaner/core/widgets/pro_logo.dart';
import 'package:tidy_cleaner/features/auth/presentation/sign_in_controller.dart';
import 'package:tidy_cleaner/l10n/app_localizations.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Phone number first, then the code. Same look as the client welcome screen,
/// with "tidy pro" branding.
class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _phone = TextEditingController();
  final _code = TextEditingController();

  @override
  void dispose() {
    _phone.dispose();
    _code.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final controller = ref.read(signInControllerProvider.notifier);
    final step = ref.read(signInControllerProvider).step;
    if (step == SignInStep.phone) {
      if (await controller.sendCode(_phone.text)) _code.clear();
    } else {
      await controller.verify(_code.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final state = ref.watch(signInControllerProvider);
    final isPhoneStep = state.step == SignInStep.phone;

    return Scaffold(
      backgroundColor: TidyColors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              TidySpacing.xl,
              TidySpacing.xl,
              TidySpacing.xl,
              TidySpacing.xxl,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    constraints.maxHeight - TidySpacing.xl - TidySpacing.xxl,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: TidySpacing.xl),
                      const Center(child: _Illustration()),
                      const SizedBox(height: 28),
                      const ProLogo(),
                      const SizedBox(height: TidySpacing.md),
                      Text(
                        l10n.signInTitle,
                        style: text.headlineLarge?.copyWith(
                          fontSize: 34,
                          height: 1.12,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: TidySpacing.md),
                      Text(
                        l10n.signInSubtitle,
                        style: text.bodyLarge?.copyWith(
                          color: TidyColors.muted,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: TidySpacing.xl),
                    ],
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Column(
                      key: ValueKey(state.step),
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (isPhoneStep)
                          _PhoneField(controller: _phone, onSubmit: _submit)
                        else
                          _CodeField(
                            controller: _code,
                            phone: state.phone,
                            onSubmit: _submit,
                          ),
                        if (state.error != null) ...[
                          const SizedBox(height: TidySpacing.sm),
                          Semantics(
                            liveRegion: true,
                            child: Text(
                              errorText(l10n, state.error!),
                              style: text.bodySmall?.copyWith(
                                color: TidyColors.danger,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: TidySpacing.md),
                        TidyButton(
                          label: isPhoneStep ? l10n.sendCode : l10n.verifyCode,
                          isLoading: state.busy,
                          onPressed: _submit,
                        ),
                        if (!isPhoneStep) ...[
                          const SizedBox(height: TidySpacing.md),
                          TidyButton(
                            label: l10n.changeNumber,
                            variant: TidyButtonVariant.ghost,
                            onPressed: state.busy
                                ? null
                                : ref
                                      .read(signInControllerProvider.notifier)
                                      .changeNumber,
                          ),
                        ],
                        const SizedBox(height: TidySpacing.lg),
                        Text(
                          l10n.signInTerms,
                          textAlign: TextAlign.center,
                          style: text.bodySmall?.copyWith(
                            color: TidyColors.muted,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
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

class _PhoneField extends StatelessWidget {
  const _PhoneField({required this.controller, required this.onSubmit});

  final TextEditingController controller;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.phoneNumber,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: TidyColors.muted,
          ),
        ),
        const SizedBox(height: TidySpacing.sm),
        Row(
          children: [
            Container(
              height: 54,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: TidyColors.line),
                borderRadius: TidyRadii.controlBorder,
              ),
              child: const Text(
                defaultDialCode,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
            const SizedBox(width: TidySpacing.sm),
            Expanded(
              child: TextField(
                key: const Key('phoneField'),
                controller: controller,
                keyboardType: TextInputType.phone,
                autofillHints: const [AutofillHints.telephoneNumberNational],
                textInputAction: TextInputAction.go,
                onSubmitted: (_) => onSubmit(),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d\s+]')),
                ],
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(hintText: '7700 900123'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CodeField extends StatelessWidget {
  const _CodeField({
    required this.controller,
    required this.phone,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final String phone;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.codeSentTo(phone),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: TidyColors.muted,
          ),
        ),
        const SizedBox(height: TidySpacing.sm),
        TextField(
          key: const Key('codeField'),
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          autofillHints: const [AutofillHints.oneTimeCode],
          textInputAction: TextInputAction.go,
          onSubmitted: (_) => onSubmit(),
          maxLength: 6,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 8,
          ),
          decoration: InputDecoration(
            hintText: '······',
            counterText: '',
            labelText: l10n.verificationCode,
          ),
        ),
      ],
    );
  }
}

/// The mint tile with a sparkle badge from the welcome design, built from
/// plain boxes so there is no asset to ship.
class _Illustration extends StatelessWidget {
  const _Illustration();

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: 300,
        height: 250,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: TidyColors.primarySoft,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 40,
              top: 120,
              child: Container(
                width: 220,
                height: 90,
                decoration: BoxDecoration(
                  color: TidyColors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
            Positioned(
              left: 62,
              top: 60,
              child: Container(
                width: 76,
                height: 76,
                decoration: const BoxDecoration(
                  color: TidyColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome_outlined,
                  size: 38,
                  color: TidyColors.white,
                ),
              ),
            ),
            for (final (top, width) in [(140.0, 80.0), (162.0, 56.0)])
              Positioned(
                left: 160,
                top: top,
                child: Container(
                  width: width,
                  height: 12,
                  decoration: BoxDecoration(
                    color: TidyColors.line,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            Positioned(
              left: 62,
              top: 142,
              child: Container(
                width: 70,
                height: 50,
                decoration: BoxDecoration(
                  color: TidyColors.accent,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
