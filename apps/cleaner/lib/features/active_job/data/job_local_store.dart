import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tidy_core/tidy_core.dart';

part 'job_local_store.g.dart';

/// What the phone remembers about a job: ticked checklist items and the time
/// of each status change (the API only returns the latest one).
class JobLocalStore {
  const JobLocalStore(this._prefs);

  final SharedPreferences _prefs;

  static String _checklistKey(String jobId) => 'job.$jobId.checklist';
  static String _timesKey(String jobId) => 'job.$jobId.times';

  Set<String> checked(String jobId) =>
      (_prefs.getStringList(_checklistKey(jobId)) ?? const []).toSet();

  Future<void> saveChecked(String jobId, Set<String> ids) =>
      _prefs.setStringList(_checklistKey(jobId), ids.toList());

  Map<BookingStatus, DateTime> times(String jobId) {
    final raw = _prefs.getString(_timesKey(jobId));
    if (raw == null) return const {};
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return {
      for (final status in BookingStatus.values)
        if (json[status.wireName] case final String at)
          status: DateTime.parse(at),
    };
  }

  Future<void> saveTime(String jobId, BookingStatus status, DateTime at) {
    final all = {...times(jobId), status: at};
    return _prefs.setString(
      _timesKey(jobId),
      jsonEncode({
        for (final e in all.entries) e.key.wireName: e.value.toIso8601String(),
      }),
    );
  }
}

@Riverpod(keepAlive: true)
JobLocalStore jobLocalStore(Ref ref) =>
    JobLocalStore(ref.watch(sharedPreferencesProvider));
