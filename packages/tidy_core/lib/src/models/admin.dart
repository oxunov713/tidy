import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin.freezed.dart';
part 'admin.g.dart';

/// Response of `GET /admin/stats/today`.
@freezed
abstract class AdminStats with _$AdminStats {
  const factory AdminStats({
    required int bookings,

    /// Pence.
    required int revenue,
    required int cleanersOnline,
    required int pendingApprovals,
  }) = _AdminStats;

  factory AdminStats.fromJson(Map<String, dynamic> json) =>
      _$AdminStatsFromJson(json);
}
