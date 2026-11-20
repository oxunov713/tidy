import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_cleaner/core/location/location_service.dart';
import 'package:tidy_cleaner/l10n/app_localizations.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Explains why Tidy Pro wants the location before the system dialog shows.
/// Pops with `true` once access is granted, `false` otherwise.
class LocationPermissionPage extends ConsumerStatefulWidget {
  const LocationPermissionPage({super.key});

  @override
  ConsumerState<LocationPermissionPage> createState() =>
      _LocationPermissionPageState();
}

class _LocationPermissionPageState
    extends ConsumerState<LocationPermissionPage> {
  LocationAccess? _result;
  bool _busy = false;

  Future<void> _allow() async {
    final service = ref.read(locationServiceProvider);
    if (_result == LocationAccess.deniedForever) {
      await service.openSettings();
      return;
    }
    setState(() => _busy = true);
    final access = await service.requestAccess();
    if (!mounted) return;
    if (access == LocationAccess.granted) {
      context.pop(true);
      return;
    }
    setState(() {
      _busy = false;
      _result = access;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final blocked = _result == LocationAccess.deniedForever;
    final serviceOff = _result == LocationAccess.serviceDisabled;

    return Scaffold(
      backgroundColor: TidyColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TidySpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: TidySpacing.xxl),
                      Container(
                        width: 88,
                        height: 88,
                        decoration: const BoxDecoration(
                          color: TidyColors.primarySoft,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.my_location,
                          size: 40,
                          color: TidyColors.primary,
                        ),
                      ),
                      const SizedBox(height: TidySpacing.xl),
                      Text(
                        l10n.permissionTitle,
                        style: text.headlineMedium?.copyWith(height: 1.15),
                      ),
                      const SizedBox(height: TidySpacing.xl),
                      for (final line in [
                        l10n.permissionBullet1,
                        l10n.permissionBullet2,
                        l10n.permissionBullet3,
                      ])
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                size: 22,
                                color: TidyColors.primary,
                              ),
                              const SizedBox(width: TidySpacing.md),
                              Expanded(
                                child: Text(
                                  line,
                                  style: text.bodyLarge?.copyWith(height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (blocked || serviceOff) ...[
                        const SizedBox(height: TidySpacing.sm),
                        Container(
                          padding: const EdgeInsets.all(TidySpacing.md),
                          decoration: const BoxDecoration(
                            color: TidyColors.dangerSoft,
                            borderRadius: TidyRadii.controlBorder,
                          ),
                          child: Text(
                            blocked
                                ? l10n.permissionBlockedBody
                                : l10n.permissionLocationOff,
                            style: text.bodyMedium?.copyWith(
                              color: TidyColors.danger,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              TidyButton(
                key: const Key('allowLocation'),
                label: blocked ? l10n.openSettings : l10n.permissionAllow,
                icon: Icons.my_location,
                isLoading: _busy,
                onPressed: _allow,
              ),
              const SizedBox(height: TidySpacing.sm),
              TidyButton(
                label: l10n.permissionNotNow,
                variant: TidyButtonVariant.ghost,
                onPressed: () => context.pop(false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
