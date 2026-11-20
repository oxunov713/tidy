import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/widgets/error_state.dart';

/// Renders an [AsyncValue] with the same loading and error handling
/// everywhere: a skeleton (or spinner) while loading, [ErrorState] with a
/// retry button on failure.
///
/// While a refresh is running the previous data stays on screen.
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    required this.value,
    required this.data,
    this.loading,
    this.onRetry,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;

  /// Skeleton shown on the first load. Defaults to a centred spinner.
  final WidgetBuilder? loading;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return value.when(
      skipLoadingOnReload: true,
      data: data,
      loading: () =>
          loading?.call(context) ??
          const Center(child: CircularProgressIndicator()),
      error: (error, _) => ErrorState(error: error, onRetry: onRetry),
    );
  }
}
