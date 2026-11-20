import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/error/error_text.dart';
import 'package:tidy_client/core/format/formatters.dart';
import 'package:tidy_client/core/widgets/async_value_view.dart';
import 'package:tidy_client/core/widgets/cleaner_avatar.dart';
import 'package:tidy_client/core/widgets/round_icon_button.dart';
import 'package:tidy_client/features/auth/presentation/auth_providers.dart';
import 'package:tidy_client/features/bookings/presentation/bookings_providers.dart';
import 'package:tidy_client/features/chat/presentation/chat_providers.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Conversation with the cleaner of one booking.
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({required this.bookingId, super.key});

  final String bookingId;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  bool _sending = false;

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final body = _input.text.trim();
    if (body.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      await ref.read(chatProvider(widget.bookingId).notifier).send(body);
      _input.clear();
    } on Object catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage(context, e))));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final messages = ref.watch(chatProvider(widget.bookingId));
    final me = ref.watch(currentUserProvider)?.id;
    final cleaner = ref
        .watch(bookingDetailsProvider(widget.bookingId))
        .value
        ?.cleaner;

    ref.listen(chatProvider(widget.bookingId), (_, next) {
      if (next.hasValue) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scroll.hasClients) {
            _scroll.animateTo(
              _scroll.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });

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
              child: AsyncValueView<List<Message>>(
                value: messages,
                onRetry: () => ref.invalidate(chatProvider(widget.bookingId)),
                data: (list) => list.isEmpty
                    ? EmptyState(
                        icon: Icons.chat_bubble_outline,
                        title: l10n.noMessagesTitle,
                        message: l10n.noMessagesBody,
                      )
                    : ListView.builder(
                        controller: _scroll,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        itemCount: list.length,
                        itemBuilder: (context, i) => _Bubble(
                          message: list[i],
                          mine: list[i].senderId == me,
                        ),
                      ),
              ),
            ),
            DecoratedBox(
              decoration: const BoxDecoration(
                color: TidyColors.white,
                border: Border(top: BorderSide(color: TidyColors.line)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _input,
                        minLines: 1,
                        maxLines: 4,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: l10n.messageHint,
                          isDense: true,
                        ),
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      tooltip: l10n.send,
                      onPressed: _sending ? null : _send,
                      style: IconButton.styleFrom(
                        backgroundColor: TidyColors.primary,
                        foregroundColor: TidyColors.white,
                        fixedSize: const Size(48, 48),
                      ),
                      icon: const Icon(Icons.arrow_upward),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message, required this.mine});

  final Message message;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.75,
        ),
        decoration: BoxDecoration(
          color: mine ? TidyColors.primary : TidyColors.white,
          borderRadius: BorderRadius.circular(18),
          border: mine ? null : Border.all(color: TidyColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.body,
              style: text.bodyMedium?.copyWith(
                color: mine ? TidyColors.white : TidyColors.ink,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              formatClock(message.createdAt),
              style: text.labelSmall?.copyWith(
                color: mine
                    ? TidyColors.white.withValues(alpha: 0.8)
                    : TidyColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
