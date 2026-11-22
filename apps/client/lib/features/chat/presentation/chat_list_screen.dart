import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/format/formatters.dart';
import 'package:tidy_client/core/router/routes.dart';
import 'package:tidy_client/core/widgets/async_value_view.dart';
import 'package:tidy_client/core/widgets/cleaner_avatar.dart';
import 'package:tidy_client/features/bookings/presentation/bookings_providers.dart';
import 'package:tidy_client/features/chat/presentation/chat_providers.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// The Chat tab: one row per booking that has a cleaner.
class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final threads = ref.watch(chatThreadsProvider);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.navChat,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontSize: 28),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: AsyncValueView<List<ChatThread>>(
                value: threads,
                onRetry: () {
                  ref
                    ..invalidate(chatThreadsProvider)
                    ..invalidate(bookingsListProvider);
                },
                loading: (_) => const Shimmer(
                  child: Column(
                    children: [
                      SkeletonBox(height: 72, radius: 20),
                      SizedBox(height: 12),
                      SkeletonBox(height: 72, radius: 20),
                    ],
                  ),
                ),
                data: (list) => RefreshIndicator(
                  onRefresh: () => ref.refresh(chatThreadsProvider.future),
                  child: list.isEmpty
                      ? LayoutBuilder(
                          builder: (context, c) => SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                              height: c.maxHeight,
                              child: EmptyState(
                                icon: Icons.chat_bubble_outline,
                                title: l10n.noChatsTitle,
                                message: l10n.noChatsBody,
                              ),
                            ),
                          ),
                        )
                      : ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: list.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, i) {
                            final t = list[i];
                            return TidyCard(
                              onTap: () => context.push(
                                Routes.bookingChat(t.booking.id),
                              ),
                              child: Row(
                                children: [
                                  CleanerAvatar(
                                    name: t.cleaner.fullName,
                                    imageUrl: t.cleaner.avatarUrl,
                                    size: 48,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          t.cleaner.fullName,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleSmall,
                                        ),
                                        Text(
                                          '${t.booking.serviceTitle} · ${formatDayShort(t.booking.start, locale)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: TidyColors.muted,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: TidyColors.muted,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
