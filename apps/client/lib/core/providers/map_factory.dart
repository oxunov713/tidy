import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_core/tidy_core.dart';

part 'map_factory.g.dart';

/// Creates a [MapProvider] for a given zoom. `YandexMapProvider` takes the
/// zoom in its constructor, and the tracking screen wants to pick it from the
/// distance between the cleaner and the home, so the app depends on this
/// factory instead of the shared `mapProviderProvider`.
typedef MapFactory = MapProvider Function({double zoom});

@Riverpod(keepAlive: true)
MapFactory mapFactory(Ref ref) =>
    ({zoom = 15}) => YandexMapProvider(zoom: zoom);
