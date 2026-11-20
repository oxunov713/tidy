import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/features/auth/presentation/country.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_ui/tidy_ui.dart';

Future<Country?> showCountryPicker(
  BuildContext context, {
  required Country selected,
}) {
  return showModalBottomSheet<Country>(
    context: context,
    backgroundColor: TidyColors.white,
    showDragHandle: true,
    builder: (context) {
      final l10n = AppLocalizations.of(context);
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(
                l10n.selectCountry,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            for (final country in Country.all)
              ListTile(
                leading: Text(
                  country.flag,
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(country.name),
                trailing: Text(
                  country.dialCode,
                  style: const TextStyle(color: TidyColors.muted),
                ),
                selected: country == selected,
                selectedColor: TidyColors.primary,
                onTap: () => Navigator.of(context).pop(country),
              ),
          ],
        ),
      );
    },
  );
}
