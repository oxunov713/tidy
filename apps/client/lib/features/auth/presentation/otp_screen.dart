import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/error/error_text.dart';
import 'package:tidy_client/core/widgets/round_icon_button.dart';
import 'package:tidy_client/features/auth/presentation/auth_providers.dart';
import 'package:tidy_client/features/auth/presentation/widgets/otp_input.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Second sign in step. On success the auth state changes and the router
/// redirects to Home, so there is no explicit navigation here.
class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({
    required this.phone,
    this.resendAfter = const Duration(seconds: 30),
    super.key,
  });

  final String phone;
  final Duration resendAfter;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _input = GlobalKey<OtpInputState>();
  Timer? _timer;
  late int _secondsLeft = widget.resendAfter.inSeconds;
  bool _verifying = false;
  bool _resending = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = widget.resendAfter.inSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
      }
      setState(() => _secondsLeft = (_secondsLeft - 1).clamp(0, 999));
    });
  }

  Future<void> _verify(String code) async {
    setState(() {
      _verifying = true;
      _error = null;
    });
    try {
      await ref
          .read(authControllerProvider.notifier)
          .verify(phone: widget.phone, code: code);
    } on Object catch (e) {
      if (!mounted) return;
      setState(() => _error = errorMessage(context, e));
      _input.currentState?.clear();
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  Future<void> _resend() async {
    setState(() {
      _resending = true;
      _error = null;
    });
    try {
      await ref.read(authControllerProvider.notifier).requestOtp(widget.phone);
      if (!mounted) return;
      _startTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).codeSent)),
      );
    } on Object catch (e) {
      if (mounted) setState(() => _error = errorMessage(context, e));
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: TidyColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RoundIconButton(
                icon: Icons.chevron_left,
                tooltip: l10n.back,
                onPressed: () => context.pop(),
              ),
              const SizedBox(height: 32),
              Text(l10n.otpTitle, style: text.displaySmall),
              const SizedBox(height: 8),
              Text(
                l10n.otpSubtitle(widget.phone),
                style: text.bodyLarge?.copyWith(
                  color: TidyColors.muted,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              OtpInput(
                key: _input,
                hasError: _error != null,
                enabled: !_verifying,
                onCompleted: _verify,
              ),
              const SizedBox(height: 12),
              if (_error != null)
                Text(
                  _error!,
                  style: text.bodyMedium?.copyWith(color: TidyColors.danger),
                ),
              if (_verifying)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: LinearProgressIndicator(minHeight: 3),
                ),
              const SizedBox(height: 24),
              Center(
                child: _secondsLeft > 0
                    ? Text(
                        l10n.resendIn(_secondsLeft),
                        style: text.bodyMedium?.copyWith(
                          color: TidyColors.muted,
                        ),
                      )
                    : TextButton(
                        onPressed: _resending ? null : _resend,
                        child: Text(l10n.resendCode),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
