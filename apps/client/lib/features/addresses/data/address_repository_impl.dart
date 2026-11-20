import 'package:tidy_client/features/addresses/domain/address_repository.dart';
import 'package:tidy_core/tidy_core.dart';

class AddressRepositoryImpl implements AddressRepository {
  AddressRepositoryImpl({required this._api});

  final MeApi _api;

  @override
  Future<List<Address>> list() => _api.addresses();

  @override
  Future<Address> add(AddressInput input) => _api.addAddress(input);

  @override
  Future<void> delete(String id) => _api.deleteAddress(id);
}
