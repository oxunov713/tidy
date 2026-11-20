import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_client/features/catalog/data/catalog_repository_impl.dart';
import 'package:tidy_client/features/catalog/domain/catalog_repository.dart';
import 'package:tidy_core/tidy_core.dart';

part 'catalog_providers.g.dart';

@Riverpod(keepAlive: true)
CatalogRepository catalogRepository(Ref ref) =>
    CatalogRepositoryImpl(api: ref.watch(catalogApiProvider));

@riverpod
Future<List<Service>> services(Ref ref) =>
    ref.watch(catalogRepositoryProvider).services();

@riverpod
Future<List<Extra>> extras(Ref ref) =>
    ref.watch(catalogRepositoryProvider).extras();
