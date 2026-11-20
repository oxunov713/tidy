import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_admin/core/api_errors.dart';
import 'package:tidy_admin/core/widgets/error_view.dart';
import 'package:tidy_admin/features/auth/presentation/login_controller.dart';
import 'package:tidy_admin/l10n/app_localizations.dart';
import 'package:tidy_ui/tidy_ui.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _phone = TextEditingController();
  final _code = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phone.dispose();
    _code.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final controller = ref.read(loginControllerProvider.notifier);
    final state = ref.read(loginControllerProvider);
    if (state.step == LoginStep.phone) {
      await controller.requestCode(_phone.text);
    } else {
      await controller.verify(_code.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final state = ref.watch(loginControllerProvider);
    final inCodeStep = state.step == LoginStep.code;
    final error = state.error;

    return Scaffold(
      backgroundColor: TidyColors.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(TidySpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: TidyCard(
                padding: const EdgeInsets.all(TidySpacing.xl),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _Brand(),
                      const SizedBox(height: TidySpacing.xl),
                      Text(l10n.loginTitle, style: text.headlineSmall),
                      const SizedBox(height: TidySpacing.xs),
                      Text(
                        inCodeStep
                            ? l10n.loginCodeSubtitle(state.phone)
                            : l10n.loginPhoneSubtitle,
                        style: text.bodyMedium?.copyWith(
                          color: TidyColors.muted,
                        ),
                      ),
                      const SizedBox(height: TidySpacing.xl),
                      if (inCodeStep)
                        TextFormField(
                          key: const Key('code-field'),
                          controller: _code,
                          autofocus: true,
                          enabled: !state.busy,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          decoration: InputDecoration(
                            labelText: l10n.loginCodeLabel,
                            hintText: '123456',
                          ),
                          validator: (v) => (v ?? '').trim().length == 6
                              ? null
                              : l10n.loginCodeInvalid,
                          onFieldSubmitted: (_) => _submit(),
                        )
                      else
                        TextFormField(
                          key: const Key('phone-field'),
                          controller: _phone,
                          autofocus: true,
                          enabled: !state.busy,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: l10n.loginPhoneLabel,
                            hintText: '+447700900001',
                          ),
                          validator: (v) => normalisePhone(v ?? '') == null
                              ? l10n.loginPhoneInvalid
                              : null,
                          onFieldSubmitted: (_) => _submit(),
                        ),
                      if (error != null) ...[
                        const SizedBox(height: TidySpacing.lg),
                        ErrorBanner(
                          message: errorText(l10n, error),
                        ),
                      ],
                      const SizedBox(height: TidySpacing.xl),
                      TidyButton(
                        label: inCodeStep
                            ? l10n.loginSignIn
                            : l10n.loginSendCode,
                        isLoading: state.busy,
                        onPressed: _submit,
                      ),
                      if (inCodeStep) ...[
                        const SizedBox(height: TidySpacing.sm),
                        TidyButton(
                          label: l10n.loginChangeNumber,
                          variant: TidyButtonVariant.ghost,
                          onPressed: state.busy
                              ? null
                              : () {
                                  _code.clear();
                                  ref
                                      .read(loginControllerProvider.notifier)
                                      .changePhone();
                                },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: TidyColors.primary,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: TidySpacing.sm),
        Text(
          'tidy',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(width: 4),
        Text(
          'admin',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: TidyColors.primary),
        ),
      ],
    );
  }
}
