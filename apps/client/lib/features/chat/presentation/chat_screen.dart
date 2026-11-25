import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/error/error_text.dart';
import 'package:tidy_client/core/widgets/api_error_view.dart';
import 'package:tidy_client/core/widgets/cleaner_avatar.dart';
import 'package:tidy_client/core/widgets/round_icon_button.dart';
import 'package:tidy_client/features/auth/presentation/auth_providers.dart';
import 'package:tidy_client/features/bookings/presentation/bookings_providers.dart';
import 'package:tidy_client/features/chat/presentation/chat_providers.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Conversation with the cleaner of one booking.
class ChatScreen extends ConsumerWidget {
  const ChatScreen({required this.bookingId, super.key});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final messages = ref.watch(chatProvider(bookingId));
    final me = ref.watch(currentUserProvider)?.id;
    final details = ref.watch(bookingDetailsProvider(bookingId)).value;
    final cleaner = details?.cleaner;
    final revoked = ref.watch(
      roomAccessRevokedProvider(Rooms.booking(bookingId)),
    );
    final closed =
        revoked || details?.booking.status == BookingStatus.cancelled;
    final locale = Localizations.localeOf(context).toString();

    return Scaffold(
      backgroundColor: TidyColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                children: [
                  RoundIconButton(
                    icon: Icons.chevron_left,
                    tooltip: l10n.back,
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: 12),
                  if (cleaner != null) ...[
                    CleanerAvatar(name: cleaner.fullName, size: 40),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Text(
                      cleaner?.fullName ?? l10n.navChat,
                      style: Theme.of(context).textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
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
                    onRetry: () => ref.invalidate(chatProvider(bookingId)),
                  ),
                  AsyncData() => null,
                  _ => Padding(
                    padding: const EdgeInsets.all(TidySpacing.lg),
                    child: SkeletonList(semanticLabel: l10n.loading),
                  ),
                },
                onSend: (body) =>
                    ref.read(chatProvider(bookingId).notifier).send(body),
                onSendError: (e) =>
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      SnackBar(content: Text(errorMessage(context, e))),
                    ),
                hintText: l10n.messageHint,
                sendLabel: l10n.send,
                emptyTitle: l10n.noMessagesTitle,
                emptyMessage: l10n.noMessagesBody,
                closedNotice: closed ? l10n.chatClosed : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
