import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_cleaner/core/errors/error_text.dart';
import 'package:tidy_cleaner/core/widgets/api_error_view.dart';
import 'package:tidy_cleaner/core/widgets/page_header.dart';
import 'package:tidy_cleaner/features/auth/presentation/session_controller.dart';
import 'package:tidy_cleaner/features/chat/presentation/chat_controller.dart';
import 'package:tidy_cleaner/features/jobs/presentation/jobs_controller.dart';
import 'package:tidy_cleaner/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Messages with the client of one job.
class ChatPage extends ConsumerWidget {
  const ChatPage({required this.bookingId, super.key});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final messages = ref.watch(chatControllerProvider(bookingId));
    final me = ref.watch(currentUserIdProvider);
    final revoked = ref.watch(
      roomAccessRevokedProvider(Rooms.booking(bookingId)),
    );
    final clientName = ref
        .watch(jobsControllerProvider)
        .value
        ?.where((j) => j.booking.id == bookingId)
        .firstOrNull
        ?.clientName;
    final name = clientName ?? l10n.navJobs;

    return Scaffold(
      body: Column(
        children: [
          PageHeader(title: l10n.chatTitle(name)),
          Expanded(
            child: ChatView(
              entries: [
                for (final m in messages.value ?? const <Message>[])
                  ChatEntry(
                    id: '${m.id}',
                    body: m.body,
                    timeLabel: TidyDates.clock(m.createdAt, locale),
                    mine: m.senderId == me,
                  ),
              ],
              messagesOverride: switch (messages) {
                AsyncError(:final error) => ApiErrorView(
                  error: error,
                  onRetry: () =>
                      ref.invalidate(chatControllerProvider(bookingId)),
                ),
                AsyncData() => null,
                _ => Padding(
                  padding: const EdgeInsets.all(TidySpacing.lg),
                  child: SkeletonList(semanticLabel: l10n.loading),
                ),
              },
              onSend: (text) => ref
                  .read(chatControllerProvider(bookingId).notifier)
                  .send(text),
              onSendError: (e) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    e is ApiException
                        ? errorText(l10n, e)
                        : l10n.chatSendFailed,
                  ),
                ),
              ),
              hintText: l10n.chatHint,
              sendLabel: l10n.chatSend,
              emptyTitle: l10n.chatEmptyTitle,
              emptyMessage: l10n.chatEmptyBody(name),
              closedNotice: revoked ? l10n.chatClosed : null,
            ),
          ),
        ],
      ),
    );
  }
}
