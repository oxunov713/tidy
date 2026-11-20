import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/format/formatters.dart';
import 'package:tidy_client/features/catalog/presentation/catalog_providers.dart';
import 'package:tidy_client/features/catalog/presentation/service_style.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// "See all": every service as a compact list, for people who prefer that to
/// the carousel.
Future<void> showAllServicesSheet(
  BuildContext context, {
  required ValueChanged<Service> onSelected,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: TidyColors.white,
    builder: (sheetContext) => Consumer(
      builder: (context, ref, _) {
        final l10n = AppLocalizations.of(context);
        final services = ref.watch(servicesProvider).value ?? const <Service>[];
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Text(
                  l10n.servicesTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              for (final service in services)
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: ServiceStyle.forSlug(service.slug).tint,
                    child: Icon(
                      ServiceStyle.forSlug(service.slug).icon,
                      color: ServiceStyle.forSlug(service.slug).ink,
                    ),
                  ),
                  title: Text(service.title),
                  subtitle: Text(l10n.hoursUnit(hoursRange(service.minutes))),
                  trailing: Text(
                    PriceText.format(service.fromPrice),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    onSelected(service);
                  },
                ),
            ],
          ),
        );
      },
    ),
  );
}
