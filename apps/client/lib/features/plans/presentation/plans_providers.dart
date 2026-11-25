import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_client/features/bookings/presentation/bookings_providers.dart';
import 'package:tidy_core/tidy_core.dart';

part 'plans_providers.g.dart';

/// The client's active recurring cleans.
@riverpod
Future<List<Plan>> plans(Ref ref) =>
    ref.watch(bookingRepositoryProvider).plans();
