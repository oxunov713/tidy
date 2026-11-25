import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_cleaner/features/auth/presentation/session_controller.dart';

part 'sign_in_controller.g.dart';

enum SignInStep { phone, code }

class SignInState {
  const SignInState({
    this.step = SignInStep.phone,
    this.phone = '',
    this.busy = false,
    this.error,
  });

  final SignInStep step;

  /// E.164, e.g. `+447700900123`.
  final String phone;
  final bool busy;
  final Object? error;

  SignInState copyWith({
    SignInStep? step,
    String? phone,
    bool? busy,
    Object? error,
    bool clearError = false,
  }) => SignInState(
    step: step ?? this.step,
    phone: phone ?? this.phone,
    busy: busy ?? this.busy,
    error: clearError ? null : error ?? this.error,
  );
}

/// The UK dialling code the design shows next to the field.
const defaultDialCode = '+44';

/// "07700 900123", "7700 900 123" or "+447700900123" -> "+447700900123".
/// Returns null when there are too few or too many digits.
String? normalizePhone(String input, {String dialCode = defaultDialCode}) {
  final trimmed = input.trim();
  var digits = trimmed.replaceAll(RegExp(r'\D'), '');
  if (trimmed.startsWith('+')) {
    return digits.length >= 10 && digits.length <= 15 ? '+$digits' : null;
  }
  if (digits.startsWith('0')) digits = digits.substring(1);
  return digits.length >= 9 && digits.length <= 11 ? '$dialCode$digits' : null;
}

@riverpod
class SignInController extends _$SignInController {
  @override
  SignInState build() => const SignInState();

  Future<bool> sendCode(String input) async {
    final phone = normalizePhone(input);
    if (phone == null) {
      state = state.copyWith(error: const FormatException('phone'));
      return false;
    }
    state = state.copyWith(busy: true, clearError: true);
    try {
      await ref.read(sessionRepositoryProvider).requestOtp(phone);
      state = SignInState(step: SignInStep.code, phone: phone);
      return true;
    } on Object catch (e) {
      state = state.copyWith(busy: false, error: e);
      return false;
    }
  }

  Future<void> verify(String code) async {
    state = state.copyWith(busy: true, clearError: true);
    try {
      await ref
          .read(sessionControllerProvider.notifier)
          .signIn(phone: state.phone, code: code.trim());
      state = state.copyWith(busy: false);
    } on Object catch (e) {
      state = state.copyWith(busy: false, error: e);
    }
  }

  void changeNumber() => state = const SignInState();
}
