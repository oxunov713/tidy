import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_admin/core/api_errors.dart';
import 'package:tidy_admin/core/formatting.dart';
import 'package:tidy_admin/core/widgets/error_view.dart';
import 'package:tidy_admin/core/widgets/online_dot.dart';
import 'package:tidy_admin/features/bookings/presentation/bookings_providers.dart';
import 'package:tidy_admin/features/cleaners/presentation/cleaners_providers.dart';
import 'package:tidy_admin/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

Future<void> showReassignDialog(
  BuildContext context, {
  required String bookingId,
  required String? currentCleanerId,
}) async {
  final done = await showDialog<bool>(
    context: context,
    builder: (_) => ReassignDialog(
      bookingId: bookingId,
      currentCleanerId: currentCleanerId,
    ),
  );
  if (done ?? false) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).cleanerReassigned)),
    );
  }
}

Future<void> showCancelBookingDialog(
  BuildContext context, {
  required String bookingId,
  required String code,
}) async {
  final done = await showDialog<bool>(
    context: context,
    builder: (_) => CancelBookingDialog(bookingId: bookingId, code: code),
  );
  if (done ?? false) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).bookingCancelled)),
    );
  }
}

/// Pick an approved cleaner and confirm. API errors such as `slot_taken` are
/// shown inside the dialog so the admin can pick someone else.
class ReassignDialog extends ConsumerStatefulWidget {
  const ReassignDialog({
    required this.bookingId,
    required this.currentCleanerId,
    super.key,
  });

  final String bookingId;
  final String? currentCleanerId;

  @override
  ConsumerState<ReassignDialog> createState() => _ReassignDialogState();
}

class _ReassignDialogState extends ConsumerState<ReassignDialog> {
  User? _picked;
  bool _busy = false;
  Object? _error;

  Future<void> _submit() async {
    final picked = _picked;
    if (picked == null) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(bookingDetailControllerProvider(widget.bookingId).notifier)
          .reassign(
            cleanerId: picked.id,
            cleanerName: nameOrPhone(picked.fullName, picked.phone),
          );
      if (mounted) Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = e;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cleaners = ref.watch(cleanersControllerProvider);
    final approved = [
      for (final c
          in cleaners.value?.withStatus(CleanerStatus.approved) ?? <User>[])
        if (c.id != widget.currentCleanerId) c,
    ];

    final Widget list;
    if (cleaners.hasError && !cleaners.isLoading) {
      list = ErrorView(
        error: cleaners.error!,
        onRetry: () => ref.invalidate(cleanersControllerProvider),
      );
    } else if (cleaners.value == null) {
      list = const Padding(
        padding: EdgeInsets.all(TidySpacing.xl),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (approved.isEmpty) {
      list = Padding(
        padding: const EdgeInsets.all(TidySpacing.lg),
        child: Text(l10n.noApprovedCleaners),
      );
    } else {
      list = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final c in approved)
            Padding(
              padding: const EdgeInsets.only(bottom: TidySpacing.sm),
              child: TidyCard(
                highlighted: _picked?.id == c.id,
                padding: const EdgeInsets.all(TidySpacing.md),
                onTap: _busy ? null : () => setState(() => _picked = c),
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Avatar(
                          name: c.fullName,
                          imageUrl: c.avatarUrl,
                          size: 40,
                        ),
                        Positioned(
                          right: -2,
                          bottom: -2,
                          child: OnlineDot(
                            online: c.cleaner?.isOnline ?? false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: TidySpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nameOrPhone(c.fullName, c.phone),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            l10n.ratingSummary(
                              (c.cleaner?.rating ?? 0).toStringAsFixed(1),
                              c.cleaner?.ratingCount ?? 0,
                            ),
                            style: const TextStyle(
                              fontSize: 13,
                              color: TidyColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_picked?.id == c.id)
                      const Icon(Icons.check_circle, color: TidyColors.primary),
                  ],
                ),
              ),
            ),
        ],
      );
    }

    return AlertDialog(
      title: Text(l10n.reassignTitle),
      backgroundColor: TidyColors.white,
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.reassignHint,
                style: const TextStyle(color: TidyColors.muted),
              ),
              const SizedBox(height: TidySpacing.lg),
              list,
              if (_error != null) ...[
                const SizedBox(height: TidySpacing.sm),
                ErrorBanner(message: describeError(_error!, l10n)),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TidyButton(
          label: l10n.cancel,
          variant: TidyButtonVariant.ghost,
          expand: false,
          onPressed: _busy ? null : () => Navigator.of(context).pop(false),
        ),
        TidyButton(
          label: l10n.reassignConfirm,
          expand: false,
          isLoading: _busy,
          onPressed: _picked == null ? null : _submit,
        ),
      ],
    );
  }
}

class CancelBookingDialog extends ConsumerStatefulWidget {
  const CancelBookingDialog({
    required this.bookingId,
    required this.code,
    super.key,
  });

  final String bookingId;
  final String code;

  @override
  ConsumerState<CancelBookingDialog> createState() =>
      _CancelBookingDialogState();
}

class _CancelBookingDialogState extends ConsumerState<CancelBookingDialog> {
  bool _busy = false;
  Object? _error;

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(bookingDetailControllerProvider(widget.bookingId).notifier)
          .cancel();
      if (mounted) Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = e;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      backgroundColor: TidyColors.white,
      title: Text(l10n.cancelBookingTitle(widget.code)),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.cancelBookingBody),
            if (_error != null) ...[
              const SizedBox(height: TidySpacing.lg),
              ErrorBanner(message: describeError(_error!, l10n)),
            ],
          ],
        ),
      ),
      actions: [
        TidyButton(
          label: l10n.keepBooking,
          variant: TidyButtonVariant.ghost,
          expand: false,
          onPressed: _busy ? null : () => Navigator.of(context).pop(false),
        ),
        _DangerButton(
          label: l10n.cancelBooking,
          isLoading: _busy,
          onPressed: _submit,
        ),
      ],
    );
  }
}

/// Destructive confirm button; tidy_ui has no danger variant yet.
class _DangerButton extends StatelessWidget {
  const _DangerButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: TidyColors.danger,
        disabledBackgroundColor: TidyColors.danger,
        foregroundColor: TidyColors.white,
        disabledForegroundColor: TidyColors.white,
        minimumSize: const Size(64, 52),
        shape: const RoundedRectangleBorder(
          borderRadius: TidyRadii.controlBorder,
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      child: isLoading
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: TidyColors.white,
              ),
            )
          : Text(label),
    );
  }
}
