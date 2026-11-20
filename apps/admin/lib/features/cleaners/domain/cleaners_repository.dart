import 'package:tidy_core/tidy_core.dart';

abstract interface class CleanersRepository {
  /// Every cleaner, whatever their status; each has `cleaner` filled in.
  Future<List<User>> list();

  Future<void> approve(String id);

  Future<void> suspend(String id);
}
