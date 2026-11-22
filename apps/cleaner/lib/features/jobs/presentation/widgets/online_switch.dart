import 'package:material_ui/material_ui.dart';
import 'package:tidy_cleaner/l10n/app_localizations.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// The pill switch in the dark header.
class OnlineSwitch extends StatelessWidget {
  const OnlineSwitch({
    required this.online,
    required this.busy,
    required this.onChanged,
    super.key,
  });

  final bool online;
  final bool busy;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
      toggled: online,
      label: l10n.goOnline,
      button: true,
      child: Material(
        color: online ? TidyColors.primary : TidyColors.switchOff,
        shape: const StadiumBorder(),
        child: InkWell(
          key: const Key('onlineSwitch'),
          customBorder: const StadiumBorder(),
          onTap: busy ? null : () => onChanged(!online),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 6, 14, 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: online ? TidyColors.mint : TidyColors.onInkMuted,
                    shape: BoxShape.circle,
                  ),
                  child: busy
                      ? const Padding(
                          padding: EdgeInsets.all(8),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: TidyColors.ink,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: TidySpacing.sm),
                ExcludeSemantics(
                  child: Text(
                    online ? l10n.online : l10n.offline,
                    style: const TextStyle(
                      color: TidyColors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
