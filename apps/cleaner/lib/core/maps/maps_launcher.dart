import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

part 'maps_launcher.g.dart';

/// Builds the links tried, in order, to show a place on a map: Yandex Maps
/// first, then the platform's `geo:` handler, then the Yandex Maps website,
/// which always opens.
List<Uri> mapLinks({
  required double lat,
  required double lng,
  required String label,
}) => [
  Uri.parse('yandexmaps://maps.yandex.com/?pt=$lng,$lat&z=16'),
  Uri(
    scheme: 'geo',
    path: '$lat,$lng',
    queryParameters: {'q': '$lat,$lng($label)'},
  ),
  Uri.https('yandex.com', '/maps/', {'pt': '$lng,$lat', 'z': '16', 'l': 'map'}),
];

abstract interface class MapsLauncher {
  /// Returns false when nothing could open the place.
  Future<bool> open({
    required double lat,
    required double lng,
    required String label,
  });
}

class UrlMapsLauncher implements MapsLauncher {
  const UrlMapsLauncher();

  @override
  Future<bool> open({
    required double lat,
    required double lng,
    required String label,
  }) async {
    final links = mapLinks(lat: lat, lng: lng, label: label);
    for (final link in links) {
      // The web link is the last resort and canLaunchUrl is unreliable for
      // http(s) on some Android versions, so it is launched without the check.
      final isLast = link == links.last;
      if (isLast || await canLaunchUrl(link)) {
        if (await launchUrl(link, mode: LaunchMode.externalApplication)) {
          return true;
        }
      }
    }
    return false;
  }
}

@Riverpod(keepAlive: true)
MapsLauncher mapsLauncher(Ref ref) => const UrlMapsLauncher();
