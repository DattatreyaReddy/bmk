import 'package:drift/drift.dart';

import '../../../core/repository/app_database.dart';

extension CollectionBookmarkMappingRepository on AppDatabase {
  Stream<List<CollectionBookmarkMapping>> watchMappingWithCollectionId(
          int id) =>
      (select(collectionBookmarkMappings)
            ..where((t) => t.collectionId.equals(id)))
          .watch();

  Future<List<CollectionBookmarkMapping>> getMappingWithCollectionId(int id) =>
      (select(collectionBookmarkMappings)
            ..where((t) => t.collectionId.equals(id)))
          .get();

  Stream<List<CollectionBookmarkMapping>> watchMappingWithBookmarkId(int id) =>
      (select(collectionBookmarkMappings)
            ..where((t) => t.bookmarkId.equals(id)))
          .watch();

  Stream<List<CollectionBookmarkMapping>> get watchMappings =>
      select(collectionBookmarkMappings).watch();

  Future<void> saveMapping(Insertable<CollectionBookmarkMapping> mapping) =>
      into(collectionBookmarkMappings).insertOnConflictUpdate(mapping);

  Future<bool> deleteMapping(int id) async =>
      (await (delete(collectionBookmarkMappings)..where((t) => t.id.equals(id)))
          .go()) >
      0;
  Future<bool> deleteMappings(Set<int> ids) async =>
      (await (delete(collectionBookmarkMappings)..where((t) => t.id.isIn(ids)))
          .go()) >
      0;
  Future<bool> deleteMappingsByBookmarkIds(Set<int> bookmarkIds) async =>
      (await (delete(collectionBookmarkMappings)
            ..where((t) => t.bookmarkId.isIn(bookmarkIds)))
          .go()) >
      0;
  Stream<List<Bookmark>> watchBookmarksOrderByCollectionId(int collectionId) {
    final subQuery = Subquery(
        select(collectionBookmarkMappings)
          ..where((table) => table.collectionId.equals(collectionId)),
        'cm');
    final query = select(bookmarks).join([
      leftOuterJoin(
          subQuery,
          subQuery
              .ref(collectionBookmarkMappings.bookmarkId)
              .equalsExp(bookmarks.id),
          useColumns: false),
    ]);
    query.orderBy([
      OrderingTerm.asc(
        subQuery.ref(collectionBookmarkMappings.createdAt),
        nulls: NullsOrder.last,
      )
    ]);
    return query.map((row) => row.readTable(bookmarks)).watch();
  }

  Future<void> createCollectionAndMapping(
    Insertable<Collection> collection,
    Set<int> mappedBookmarkIds,
  ) =>
      transaction(() async {
        int collectionId = await into(collections).insert(collection);
        final now = DateTime.now();
        final newlyAddedMapping = mappedBookmarkIds
            .map((bookmarkId) => CollectionBookmarkMappingsCompanion.insert(
                bookmarkId: bookmarkId,
                collectionId: collectionId,
                createdAt: now))
            .toList();

        await batch((batch) {
          batch.insertAll(collectionBookmarkMappings, newlyAddedMapping);
        });
      });

  Future<void> updateCollectionAndMapping(
    Collection collection,
    Set<int> mappedBookmarkIds,
  ) =>
      transaction(() async {
        await update(collections).replace(collection);
        final existingBookmarkSet =
            (await getMappingWithCollectionId(collection.id))
                .map((m) => m.bookmarkId)
                .toSet();
        final removedBookmarkSet =
            existingBookmarkSet.difference(mappedBookmarkIds);

        final newlyAddedBookmarkSet =
            mappedBookmarkIds.difference(existingBookmarkSet);
        final now = DateTime.now();
        final newlyAddedMapping = newlyAddedBookmarkSet
            .map((bookmarkId) => CollectionBookmarkMappingsCompanion.insert(
                bookmarkId: bookmarkId,
                collectionId: collection.id,
                createdAt: now))
            .toList();

        await deleteMappingsByBookmarkIds(removedBookmarkSet);
        await batch((batch) {
          batch.insertAll(collectionBookmarkMappings, newlyAddedMapping);
        });
      });

  Stream<List<Bookmark>> watchFirstNMappedBookmarks(int collectionId,
      [int n = 3]) {
    final query = select(bookmarks).join([
      innerJoin(
        collectionBookmarkMappings,
        bookmarks.id.equalsExp(collectionBookmarkMappings.bookmarkId),
        useColumns: false,
      ),
    ]);
    query.where(collectionBookmarkMappings.collectionId.equals(collectionId) &
        bookmarks.preview.isNotNull());
    query.limit(n);
    return query.map((row) => row.readTable(bookmarks)).watch();
  }

  Stream<List<Bookmark>> watchMappedBookmarks(int collectionId) {
    final query = select(bookmarks).join([
      innerJoin(
        collectionBookmarkMappings,
        bookmarks.id.equalsExp(collectionBookmarkMappings.bookmarkId),
        useColumns: false,
      ),
    ]);
    query.where(collectionBookmarkMappings.collectionId.equals(collectionId));
    return query.map((row) => row.readTable(bookmarks)).watch();
  }
}
