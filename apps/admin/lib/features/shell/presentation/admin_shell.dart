import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_admin/core/responsive.dart';
import 'package:tidy_admin/features/shell/presentation/destinations.dart';
import 'package:tidy_admin/features/shell/presentation/sidebar.dart';
import 'package:tidy_admin/features/shell/presentation/top_bar.dart';
import 'package:tidy_admin/l10n/app_localizations.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Navigation chrome around every signed-in page: sidebar on desktop, a
/// collapsible rail on tablets and a drawer on phones.
class AdminShell extends StatefulWidget {
  const AdminShell({required this.location, required this.child, super.key});

  final String location;
  final Widget child;

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _railExpanded = false;

  void _go(AdminDestination d) {
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }
    context.go(d.path);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final size = ScreenSize.of(context);
    final selected = AdminDestination.fromLocation(widget.location);

    final content = Column(
      children: [
        TopBar(
          title: selected.label(l10n),
          onMenu: size == ScreenSize.phone
              ? () => _scaffoldKey.currentState?.openDrawer()
              : null,
        ),
        Expanded(child: widget.child),
      ],
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: TidyColors.surface,
      drawer: size == ScreenSize.phone
          ? Drawer(
              backgroundColor: TidyColors.ink,
              child: Sidebar(selected: selected, onSelect: _go),
            )
          : null,
      body: switch (size) {
        ScreenSize.phone => content,
        ScreenSize.tablet => Row(
          children: [
            Sidebar(
              selected: selected,
              onSelect: _go,
              collapsed: !_railExpanded,
              onToggle: () => setState(() => _railExpanded = !_railExpanded),
            ),
            Expanded(child: content),
          ],
        ),
        ScreenSize.desktop => Row(
          children: [
            Sidebar(selected: selected, onSelect: _go),
            Expanded(child: content),
          ],
        ),
      },
    );
  }
}
