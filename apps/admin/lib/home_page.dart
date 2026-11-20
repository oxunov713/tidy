import 'package:material_ui/material_ui.dart';
import 'package:tidy_admin/l10n/app_localizations.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Placeholder until the real screens land.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: EmptyState(
        icon: Icons.cleaning_services_outlined,
        title: l10n.homePlaceholderTitle,
        message: l10n.homePlaceholderBody,
      ),
    );
  }
}
