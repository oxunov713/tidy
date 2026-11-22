import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_cleaner/core/errors/error_text.dart';
import 'package:tidy_cleaner/core/format/formatters.dart';
import 'package:tidy_cleaner/core/widgets/api_error_view.dart';
import 'package:tidy_cleaner/core/widgets/page_header.dart';
import 'package:tidy_cleaner/features/auth/presentation/session_controller.dart';
import 'package:tidy_cleaner/features/chat/presentation/chat_controller.dart';
import 'package:tidy_cleaner/features/jobs/presentation/jobs_controller.dart';
import 'package:tidy_cleaner/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Messages with the client of one job.
class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({required this.bookingId, super.key});

  final String bookingId;

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _input = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      await ref
          .read(chatControllerProvider(widget.bookingId).notifier)
          .send(text);
      _input.clear();
    } on Object catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e is ApiException ? errorText(l10n, e) : l10n.chatSendFailed,
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final messages = ref.watch(chatControllerProvider(widget.bookingId));
    final me = ref.watch(currentUserIdProvider);
    final clientName = ref
        .watch(jobsControllerProvider)
        .value
        ?.where((j) => j.booking.id == widget.bookingId)
        .firstOrNull
        ?.clientName;
    final name = clientName ?? l10n.navJobs;

    return Scaffold(
      body: Column(
        children: [
          PageHeader(title: l10n.chatTitle(name)),
          Expanded(
            child: switch (messages) {
              AsyncData(:final value) when value.isEmpty => EmptyState(
                icon: Icons.chat_bubble_outline,
                title: l10n.chatEmptyTitle,
                message: l10n.chatEmptyBody(name),
              ),
              AsyncData(:final value) => ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(TidySpacing.lg),
                itemCount: value.length,
                itemBuilder: (context, i) {
                  final message = value[value.length - 1 - i];
                  return _Bubble(
                    message: message,
                    mine: message.senderId == me,
                  );
                },
              ),
              AsyncError(:final error) => ApiErrorView(
                error: error,
                onRetry: () =>
                    ref.invalidate(chatControllerProvider(widget.bookingId)),
              ),
              _ => Padding(
                padding: const EdgeInsets.all(TidySpacing.lg),
                child: SkeletonList(
                  semanticLabel: AppLocalizations.of(context).loading,
                ),
              ),
            },
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
              TidySpacing.lg,
              TidySpacing.md,
              TidySpacing.md,
              TidySpacing.md + MediaQuery.paddingOf(context).bottom,
            ),
            decoration: const BoxDecoration(
              color: TidyColors.white,
              border: Border(top: BorderSide(color: TidyColors.line)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('chatInput'),
                    controller: _input,
                    minLines: 1,
                    maxLines: 4,
                    maxLength: 1000,
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (_) => _send(),
                    decoration: InputDecoration(
                      hintText: l10n.chatHint,
                      counterText: '',
                    ),
                  ),
                ),
                const SizedBox(width: TidySpacing.sm),
                IconButton.filled(
                  key: const Key('chatSend'),
                  tooltip: l10n.chatSend,
                  onPressed: _sending ? null : _send,
                  style: IconButton.styleFrom(
                    backgroundColor: TidyColors.primary,
                    foregroundColor: TidyColors.white,
                    fixedSize: const Size(52, 52),
                  ),
                  icon: const Icon(Icons.send_rounded, size: 20),
                ),
              ],
            ),
          ),
        ],
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
    final locale = Localizations.localeOf(context).toString();
    final text = Theme.of(context).textTheme;
    final width = MediaQuery.sizeOf(context).width;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: width * 0.78),
        margin: const EdgeInsets.only(bottom: TidySpacing.sm),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: mine ? TidyColors.primary : TidyColors.white,
          border: mine ? null : Border.all(color: TidyColors.line),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(mine ? 18 : 4),
            bottomRight: Radius.circular(mine ? 4 : 18),
          ),
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
              Fmt.time(message.createdAt, locale),
              style: text.labelSmall?.copyWith(
                color: mine
                    ? TidyColors.white.withValues(alpha: 0.75)
                    : TidyColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
