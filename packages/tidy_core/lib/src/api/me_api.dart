import 'package:tidy_core/src/api/api_transport.dart';
import 'package:tidy_core/src/models/models.dart';

/// The signed-in user: profile, push token and saved addresses.
class MeApi {
  MeApi(this._http);

  final ApiTransport _http;

  Future<User> get() async => User.fromJson(await _http.getObject('/me'));

  Future<User> update({String? fullName, String? email}) async {
    final json = await _http.patchObject(
      '/me',
      body: {
        'full_name': ?fullName,
        'email': ?email,
      },
    );
    return User.fromJson(json);
  }

  /// `POST /me/devices`: registers an FCM token.
  Future<void> registerDevice({
    required String token,
    required DevicePlatform platform,
  }) => _http.postVoid(
    '/me/devices',
    body: {'token': token, 'platform': platform.name},
  );

  Future<List<Address>> addresses() async {
    final list = await _http.getList('/me/addresses');
    return list.map(Address.fromJson).toList();
  }

  Future<Address> addAddress(AddressInput input) async {
    final json = await _http.postObject('/me/addresses', body: input.toJson());
    return Address.fromJson(json);
  }

  Future<void> deleteAddress(String id) =>
      _http.deleteVoid('/me/addresses/$id');
}
