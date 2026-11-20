import 'package:tidy_core/tidy_core.dart';

abstract interface class AddressRepository {
  Future<List<Address>> list();
  Future<Address> add(AddressInput input);
  Future<void> delete(String id);
}
