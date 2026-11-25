import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_admin/core/api_errors.dart';
import 'package:tidy_admin/core/formatting.dart';
import 'package:tidy_admin/core/responsive.dart';
import 'package:tidy_admin/core/widgets/api_error_view.dart';
import 'package:tidy_admin/core/widgets/online_dot.dart';
import 'package:tidy_admin/features/cleaners/presentation/cleaners_providers.dart';
import 'package:tidy_admin/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

class CleanersPage extends ConsumerStatefulWidget {
  const CleanersPage({super.key});

  @override
  ConsumerState<CleanersPage> createState() => _CleanersPageState();
}

class _CleanersPageState extends ConsumerState<CleanersPage> {
  CleanerStatus _tab = CleanerStatus.pending;

  String _tabLabel(AppLocalizations l10n, CleanerStatus s) => switch (s) {
    CleanerStatus.pending => l10n.tabPending,
    CleanerStatus.approved => l10n.tabApproved,
    CleanerStatus.suspended => l10n.tabSuspended,
  };

  Future<void> _act(
    Future<void> Function() action,
    String successMessage,
  ) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await action();
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(successMessage)));
    } on ApiException catch (e) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              '${l10n.cleanerUpdateFailed} ${errorText(l10n, e)}',
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(cleanersControllerProvider);
    final controller = ref.read(cleanersControllerProvider.notifier);
    final data = async.value;

    return ListView(
      padding: pagePadding(context),
      children: [
        Wrap(
          spacing: TidySpacing.sm,
          runSpacing: TidySpacing.sm,
          children: [
            for (final s in CleanerStatus.values)
              TidyChip(
                label: data == null
                    ? _tabLabel(l10n, s)
                    : '${_tabLabel(l10n, s)} (${data.count(s)})',
                selected: _tab == s,
                onSelected: (_) => setState(() => _tab = s),
              ),
          ],
        ),
        const SizedBox(height: TidySpacing.lg),
        if (async.hasError && !async.isLoading)
          ApiErrorView(
            error: async.error!,
            onRetry: () => ref.invalidate(cleanersControllerProvider),
          )
        else if (data == null)
          const _LoadingGrid()
        else
          _CleanerGrid(
            cleaners: data.withStatus(_tab),
            busy: data.busy,
            tab: _tab,
            onApprove: (c) => _act(
              () => controller.approve(c.id),
              l10n.cleanerApproved(nameOrPhone(c.fullName, c.phone)),
            ),
            onSuspend: (c) => _act(
              () => controller.suspend(c.id),
              l10n.cleanerSuspended(nameOrPhone(c.fullName, c.phone)),
            ),
          ),
      ],
    );
  }
}

class _CleanerGrid extends StatelessWidget {
  const _CleanerGrid({
    required this.cleaners,
    required this.busy,
    required this.tab,
    required this.onApprove,
    required this.onSuspend,
  });

  final List<User> cleaners;
  final Set<String> busy;
  final CleanerStatus tab;
  final ValueChanged<User> onApprove;
  final ValueChanged<User> onSuspend;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (cleaners.isEmpty) {
      return EmptyState(
        icon: Icons.groups_outlined,
        title: switch (tab) {
          CleanerStatus.pending => l10n.noPendingCleaners,
          CleanerStatus.approved => l10n.noApprovedCleanersTab,
          CleanerStatus.suspended => l10n.noSuspendedCleaners,
        },
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = TidySpacing.lg;
        final columns = (constraints.maxWidth / 340).floor().clamp(1, 4);
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final c in cleaners)
              SizedBox(
                width: width,
                child: _CleanerCard(
                  key: ValueKey(c.id),
                  cleaner: c,
                  busy: busy.contains(c.id),
                  onApprove: () => onApprove(c),
                  onSuspend: () => onSuspend(c),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _CleanerCard extends StatelessWidget {
  const _CleanerCard({
    required this.cleaner,
    required this.busy,
    required this.onApprove,
    required this.onSuspend,
    super.key,
  });

  final User cleaner;
  final bool busy;
  final VoidCallback onApprove;
  final VoidCallback onSuspend;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profile = cleaner.cleaner;
    final status = profile?.status ?? CleanerStatus.pending;
    final online = profile?.isOnline ?? false;
    final text = Theme.of(context).textTheme;

    return TidyCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Avatar(name: cleaner.fullName, imageUrl: cleaner.avatarUrl),
                  Positioned(
                    right: -1,
                    bottom: -1,
                    child: Semantics(
                      label: online ? l10n.online : l10n.offline,
                      child: OnlineDot(online: online, size: 14),
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
                      nameOrPhone(cleaner.fullName, cleaner.phone),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.titleMedium,
                    ),
                    Text(
                      cleaner.phone,
                      style: const TextStyle(
                        fontSize: 13,
                        color: TidyColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: TidySpacing.md),
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                size: 18,
                color: TidyColors.accent,
              ),
              const SizedBox(width: 4),
              Text(
                profile == null || profile.ratingCount == 0
                    ? l10n.noRatingsYet
                    : l10n.ratingSummary(
                        profile.rating.toStringAsFixed(1),
                        profile.ratingCount,
                      ),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text(
                online ? l10n.online : l10n.offline,
                style: TextStyle(
                  fontSize: 13,
                  color: online ? TidyColors.primary : TidyColors.muted,
                ),
              ),
            ],
          ),
          if (profile != null && profile.bio.isNotEmpty) ...[
            const SizedBox(height: TidySpacing.sm),
            Text(
              profile.bio,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: TidyColors.muted),
            ),
          ],
          const SizedBox(height: TidySpacing.lg),
          if (status == CleanerStatus.approved)
            TidyButton(
              label: l10n.suspend,
              icon: Icons.block,
              variant: TidyButtonVariant.ghost,
              isLoading: busy,
              onPressed: onSuspend,
            )
          else
            Row(
              children: [
                Expanded(
                  child: TidyButton(
                    label: status == CleanerStatus.suspended
                        ? l10n.reinstate
                        : l10n.approve,
                    icon: Icons.check,
                    isLoading: busy,
                    onPressed: onApprove,
                  ),
                ),
                if (status == CleanerStatus.pending) ...[
                  const SizedBox(width: TidySpacing.sm),
                  TidyButton(
                    label: l10n.reject,
                    variant: TidyButtonVariant.ghost,
                    expand: false,
                    onPressed: busy ? null : onSuspend,
                  ),
                ],
              ],
            ),
        ],
      ),
    );
  }
}

class _LoadingGrid extends StatelessWidget {
  const _LoadingGrid();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AppLocalizations.of(context).loading,
      child: Wrap(
        spacing: TidySpacing.lg,
        runSpacing: TidySpacing.lg,
        children: [
          for (var i = 0; i < 3; i++)
            const SizedBox(
              width: 320,
              child: TidyCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer(child: SkeletonBox(width: 160, height: 20)),
                    SizedBox(height: 12),
                    Shimmer(child: SkeletonBox(width: 100)),
                    SizedBox(height: 12),
                    Shimmer(child: SkeletonBox()),
                    SizedBox(height: 20),
                    Shimmer(child: SkeletonBox(height: 44, radius: 14)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
