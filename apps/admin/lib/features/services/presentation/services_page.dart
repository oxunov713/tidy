import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_admin/core/api_errors.dart';
import 'package:tidy_admin/core/responsive.dart';
import 'package:tidy_admin/core/widgets/error_view.dart';
import 'package:tidy_admin/core/widgets/skeleton.dart';
import 'package:tidy_admin/features/services/presentation/service_form.dart';
import 'package:tidy_admin/features/services/presentation/services_providers.dart';
import 'package:tidy_admin/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

const double _tableMinWidth = 760;

class ServicesPage extends ConsumerWidget {
  const ServicesPage({super.key});

  Future<void> _toggle(
    BuildContext context,
    WidgetRef ref,
    AdminService service,
    bool active,
  ) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(servicesControllerProvider.notifier)
          .setActive(service, active: active);
    } on ApiException catch (e) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              '${l10n.serviceUpdateFailed} ${describeError(e, l10n)}',
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(servicesControllerProvider);
    final services = async.value;

    final Widget body;
    if (async.hasError && !async.isLoading) {
      body = ErrorView(
        error: async.error!,
        onRetry: () => ref.invalidate(servicesControllerProvider),
      );
    } else if (services == null) {
      body = const _LoadingRows();
    } else if (services.isEmpty) {
      body = EmptyState(
        icon: Icons.sell_outlined,
        title: l10n.noServices,
      );
    } else {
      body = LayoutBuilder(
        builder: (context, constraints) {
          final table = constraints.maxWidth >= _tableMinWidth;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (table) const _HeaderRow(),
              for (final s in services)
                _ServiceRow(
                  key: ValueKey(s.id),
                  service: s,
                  table: table,
                  onEdit: () => showEditServiceDialog(context, s),
                  onToggle: (v) => _toggle(context, ref, s, v),
                ),
            ],
          );
        },
      );
    }

    return ListView(
      padding: pagePadding(context),
      children: [
        Text(
          l10n.servicesIntro,
          style: const TextStyle(color: TidyColors.muted),
        ),
        const SizedBox(height: TidySpacing.lg),
        TidyCard(
          padding: const EdgeInsets.symmetric(
            horizontal: TidySpacing.md,
            vertical: TidySpacing.sm,
          ),
          child: body,
        ),
      ],
    );
  }
}

Future<void> showEditServiceDialog(BuildContext context, AdminService service) {
  return showDialog<void>(
    context: context,
    builder: (_) => EditServiceDialog(service: service),
  );
}

class EditServiceDialog extends ConsumerStatefulWidget {
  const EditServiceDialog({required this.service, super.key});

  final AdminService service;

  @override
  ConsumerState<EditServiceDialog> createState() => _EditServiceDialogState();
}

class _EditServiceDialogState extends ConsumerState<EditServiceDialog> {
  bool _busy = false;
  Object? _error;

  Future<void> _save(ServiceUpdate update) async {
    final messenger = ScaffoldMessenger.of(context);
    final saved = AppLocalizations.of(context).serviceSaved;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(servicesControllerProvider.notifier)
          .save(widget.service.id, update);
      if (!mounted) return;
      Navigator.of(context).pop();
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(saved)));
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
    final error = _error;
    return AlertDialog(
      backgroundColor: TidyColors.white,
      title: Text(l10n.editService),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (error != null) ...[
                ErrorBanner(message: describeError(error, l10n)),
                const SizedBox(height: TidySpacing.lg),
              ],
              ServiceForm(
                service: widget.service,
                busy: _busy,
                fieldErrors: error is InvalidRequestException
                    ? (error.details ?? const {})
                    : const {},
                onSubmit: _save,
                onCancel: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const _idle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w600,
  color: TidyColors.muted,
);

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    Widget cell(String label, {double? width, int flex = 0}) => width != null
        ? SizedBox(
            width: width,
            child: Text(label, style: _idle),
          )
        : Expanded(
            flex: flex,
            child: Text(label, style: _idle),
          );
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: TidySpacing.md,
        horizontal: TidySpacing.sm,
      ),
      child: Row(
        children: [
          cell(l10n.columnService, flex: 3),
          cell(l10n.fieldBasePrice, width: 100),
          cell(l10n.columnPerBedroom, width: 100),
          cell(l10n.columnPerBathroom, width: 100),
          cell(l10n.columnDuration, width: 210),
          cell(l10n.columnActive, width: 72),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _ServiceRow extends StatelessWidget {
  const _ServiceRow({
    required this.service,
    required this.table,
    required this.onEdit,
    required this.onToggle,
    super.key,
  });

  final AdminService service;
  final bool table;
  final VoidCallback onEdit;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final s = service;
    final dim = s.isActive ? TidyColors.ink : TidyColors.muted;
    final activeSwitch = Switch(
      value: s.isActive,
      onChanged: onToggle,
    );
    final edit = IconButton(
      tooltip: l10n.editService,
      onPressed: onEdit,
      icon: const Icon(Icons.edit_outlined),
    );
    final name = Text(
      s.title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontWeight: FontWeight.w600, color: dim),
    );

    final content = table
        ? Row(
            children: [
              Expanded(flex: 3, child: name),
              SizedBox(width: 100, child: Text(PriceText.format(s.basePrice))),
              SizedBox(width: 100, child: Text(PriceText.format(s.perBedroom))),
              SizedBox(
                width: 100,
                child: Text(PriceText.format(s.perBathroom)),
              ),
              SizedBox(
                width: 210,
                child: Text(
                  l10n.durationSummary(s.baseMinutes, s.minutesPerRoom),
                ),
              ),
              SizedBox(width: 72, child: activeSwitch),
              edit,
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: name),
                  activeSwitch,
                  edit,
                ],
              ),
              Text(
                '${l10n.fieldBasePrice} ${PriceText.format(s.basePrice)} · '
                '${PriceText.format(s.perBedroom)} / ${l10n.columnPerBedroom.toLowerCase()} · '
                '${PriceText.format(s.perBathroom)} / ${l10n.columnPerBathroom.toLowerCase()}',
                style: const TextStyle(color: TidyColors.muted),
              ),
              const SizedBox(height: TidySpacing.xs),
              Text(
                l10n.durationSummary(s.baseMinutes, s.minutesPerRoom),
                style: const TextStyle(color: TidyColors.muted),
              ),
            ],
          );

    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: TidyColors.line)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: TidySpacing.sm,
          horizontal: TidySpacing.sm,
        ),
        child: content,
      ),
    );
  }
}

class _LoadingRows extends StatelessWidget {
  const _LoadingRows();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AppLocalizations.of(context).loading,
      child: Column(
        children: [
          for (var i = 0; i < 4; i++)
            const Padding(
              padding: EdgeInsets.all(TidySpacing.md),
              child: Row(
                children: [
                  Expanded(child: Skeleton()),
                  SizedBox(width: 24),
                  Skeleton(width: 80),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
