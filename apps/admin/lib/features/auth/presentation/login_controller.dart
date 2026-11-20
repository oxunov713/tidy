import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_admin/features/auth/domain/auth_repository.dart';
import 'package:tidy_admin/features/auth/presentation/auth_providers.dart';

part 'login_controller.g.dart';

enum LoginStep { phone, code }

class LoginState {
  const LoginState({
    this.step = LoginStep.phone,
    this.phone = '',
    this.busy = false,
    this.error,
  });

  final LoginStep step;
  final String phone;
  final bool busy;

  /// An `ApiException` or [NoAdminAccessException]; the page words it.
  final Object? error;

  LoginState copyWith({
    LoginStep? step,
    String? phone,
    bool? busy,
    Object? error,
    bool clearError = false,
  }) => LoginState(
    step: step ?? this.step,
    phone: phone ?? this.phone,
    busy: busy ?? this.busy,
    error: clearError ? null : (error ?? this.error),
  );
}

/// Accepts "+447700900001" with optional spaces, dashes or brackets.
String? normalisePhone(String input) {
  final cleaned = input.replaceAll(RegExp(r'[\s\-()]'), '');
  return RegExp(r'^\+[1-9]\d{7,14}$').hasMatch(cleaned) ? cleaned : null;
}

@riverpod
class LoginController extends _$LoginController {
  @override
  LoginState build() => const LoginState();

  /// Returns false when the phone number is malformed (the page shows the
  /// field error) or the request failed (see [LoginState.error]).
  Future<bool> requestCode(String input) async {
    final phone = normalisePhone(input);
    if (phone == null) return false;
    state = state.copyWith(busy: true, clearError: true);
    try {
      await ref.read(authRepositoryProvider).requestOtp(phone);
      state = LoginState(step: LoginStep.code, phone: phone);
      return true;
    } on Exception catch (e) {
      state = state.copyWith(busy: false, error: e);
      return false;
    }
  }

  Future<void> verify(String code) async {
    state = state.copyWith(busy: true, clearError: true);
    try {
      final user = await ref
          .read(authRepositoryProvider)
          .verify(phone: state.phone, code: code.trim());
      ref.read(authControllerProvider.notifier).signedIn(user);
    } on Exception catch (e) {
      state = state.copyWith(busy: false, error: e);
    }
  }

  void changePhone() => state = const LoginState();
}
