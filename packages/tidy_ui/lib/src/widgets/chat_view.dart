import 'package:material_ui/material_ui.dart';
import 'package:tidy_ui/src/tokens/colors.dart';
import 'package:tidy_ui/src/tokens/spacing.dart';
import 'package:tidy_ui/src/widgets/empty_state.dart';

/// One message as [ChatView] shows it.
class ChatEntry {
  const ChatEntry({
    required this.id,
    required this.body,
    required this.timeLabel,
    required this.mine,
  });

  final String id;
  final String body;

  /// When it was sent, already formatted (the apps use `TidyDates.clock`, so
  /// it is business-zone time).
  final String timeLabel;

  /// Sent by the person looking at the screen.
  final bool mine;
}

/// The message list and the composer of a conversation, shared by the client
/// and the cleaner app. Entries are oldest first; the newest sits at the
/// bottom and the list stays pinned there.
///
/// Sending is the screen's business: [onSend] gets the trimmed text and the
/// composer is cleared when it completes. When it throws, the text stays and
/// [onSendError] is told, so the screen can show its own words.
///
/// When [closedNotice] is set the conversation is over (the booking was
/// cancelled, or the server revoked access): the composer is replaced by that
/// notice and nothing more can be sent.
class ChatView extends StatefulWidget {
  const ChatView({
    required this.entries,
    required this.onSend,
    required this.hintText,
    required this.sendLabel,
    required this.emptyTitle,
    required this.emptyMessage,
    this.onSendError,
    this.closedNotice,
    this.messagesOverride,
    this.maxLength = 1000,
    super.key,
  });

  final List<ChatEntry> entries;
  final Future<void> Function(String text) onSend;
  final void Function(Object error)? onSendError;
  final String hintText;
  final String sendLabel;
  final String emptyTitle;
  final String emptyMessage;
  final String? closedNotice;

  /// Shown in place of the list while it loads or when loading failed.
  final Widget? messagesOverride;
  final int maxLength;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final _input = TextEditingController();
  var _sending = false;

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty || _sending || widget.closedNotice != null) return;
    setState(() => _sending = true);
    try {
      await widget.onSend(text);
      _input.clear();
    } on Object catch (error) {
      widget.onSendError?.call(error);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: _messages()),
        _composer(context),
      ],
    );
  }

  Widget _messages() {
    final override = widget.messagesOverride;
    if (override != null) return override;
    if (widget.entries.isEmpty) {
      return EmptyState(
        icon: Icons.chat_bubble_outline,
        title: widget.emptyTitle,
        message: widget.emptyMessage,
      );
    }
    final entries = widget.entries;
    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.all(TidySpacing.lg),
      itemCount: entries.length,
      itemBuilder: (context, i) {
        final entry = entries[entries.length - 1 - i];
        return _Bubble(entry: entry);
      },
    );
  }

  Widget _composer(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    final notice = widget.closedNotice;
    return Container(
      padding: EdgeInsets.fromLTRB(
        TidySpacing.lg,
        TidySpacing.md,
        TidySpacing.md,
        TidySpacing.md + bottom,
      ),
      decoration: const BoxDecoration(
        color: TidyColors.white,
        border: Border(top: BorderSide(color: TidyColors.line)),
      ),
      child: notice != null
          ? Semantics(
              liveRegion: true,
              child: Row(
                children: [
                  const Icon(Icons.lock_outline, size: 18),
                  const SizedBox(width: TidySpacing.sm),
                  Expanded(
                    child: Text(
                      notice,
                      key: const Key('chatClosedNotice'),
                      style: const TextStyle(color: TidyColors.muted),
                    ),
                  ),
                ],
              ),
            )
          : Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('chatInput'),
                    controller: _input,
                    minLines: 1,
                    maxLines: 4,
                    maxLength: widget.maxLength,
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (_) => _send(),
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      counterText: '',
                    ),
                  ),
                ),
                const SizedBox(width: TidySpacing.sm),
                IconButton.filled(
                  key: const Key('chatSend'),
                  tooltip: widget.sendLabel,
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
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.entry});

  final ChatEntry entry;

  @override
  Widget build(BuildContext context) {
    final mine = entry.mine;
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
              entry.body,
              style: text.bodyMedium?.copyWith(
                color: mine ? TidyColors.white : TidyColors.ink,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              entry.timeLabel,
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
