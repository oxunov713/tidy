import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Six digit boxes backed by one hidden text field, so paste, autofill from
/// SMS and the keyboard all behave like a normal input.
class OtpInput extends StatefulWidget {
  const OtpInput({
    required this.onCompleted,
    this.length = 6,
    this.hasError = false,
    this.enabled = true,
    super.key,
  });

  final int length;
  final bool hasError;
  final bool enabled;
  final ValueChanged<String> onCompleted;

  @override
  State<OtpInput> createState() => OtpInputState();
}

class OtpInputState extends State<OtpInput> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onChanged)
      ..dispose();
    _focus.dispose();
    super.dispose();
  }

  void clear() {
    _controller.clear();
    _focus.requestFocus();
  }

  void _onChanged() {
    setState(() {});
    if (_controller.text.length == widget.length) {
      widget.onCompleted(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final code = _controller.text;
    final text = Theme.of(context).textTheme;
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var i = 0; i < widget.length; i++)
              _Box(
                char: i < code.length ? code[i] : '',
                active:
                    _focus.hasFocus &&
                    i == code.length.clamp(0, widget.length - 1),
                hasError: widget.hasError,
                style: text.headlineSmall,
              ),
          ],
        ),
        // Invisible but focusable: it receives the keystrokes.
        Positioned.fill(
          child: Opacity(
            opacity: 0,
            child: TextField(
              controller: _controller,
              focusNode: _focus,
              autofocus: true,
              enabled: widget.enabled,
              keyboardType: TextInputType.number,
              autofillHints: const [AutofillHints.oneTimeCode],
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(widget.length),
              ],
              showCursor: false,
              enableInteractiveSelection: false,
              onTap: () => _controller.selection = TextSelection.collapsed(
                offset: _controller.text.length,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Box extends StatelessWidget {
  const _Box({
    required this.char,
    required this.active,
    required this.hasError,
    required this.style,
  });

  final String char;
  final bool active;
  final bool hasError;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final border = hasError
        ? TidyColors.danger
        : active
        ? TidyColors.primary
        : TidyColors.line;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: 48,
      height: 58,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: TidyColors.white,
        borderRadius: TidyRadii.controlBorder,
        border: Border.all(color: border, width: active || hasError ? 1.5 : 1),
      ),
      child: Text(char, style: style),
    );
  }
}
