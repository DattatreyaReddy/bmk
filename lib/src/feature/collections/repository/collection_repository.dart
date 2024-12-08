import '../../../core/repository/app_database.dart';

extension CollectionRepository on AppDatabase {
  Stream<Collection> watchCollection(int id) =>
      (select(collections)..where((t) => t.id.equals(id))).watchSingle();

  Stream<List<Collection>> get watchCollections => select(collections).watch();

  Future<bool> deleteCollection(int id) async =>
      (await (delete(collections)..where((t) => t.id.equals(id))).go()) > 0;
}
