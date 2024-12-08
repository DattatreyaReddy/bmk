import 'package:drift/drift.dart';

import '../../../core/repository/app_database.dart';

extension BookmarkRepository on AppDatabase {
  Stream<List<Bookmark>> get watchBookmarks => select(bookmarks).watch();

  Stream<Bookmark> watchBookmark(int id) =>
      (select(bookmarks)..where((t) => t.id.equals(id))).watchSingle();

  Future<void> createBookmark(Insertable<Bookmark> bookmark,
          [int? collectionId]) =>
      transaction(() async {
        final bookmarkId =
            await into(bookmarks).insertOnConflictUpdate(bookmark);
        if (collectionId != null) {
          await into(collectionBookmarkMappings).insert(
            CollectionBookmarkMappingsCompanion.insert(
              bookmarkId: bookmarkId,
              collectionId: collectionId,
              createdAt: DateTime.now(),
            ),
            mode: InsertMode.insertOrIgnore,
          );
        }
      });
  Future<void> updateBookmark(Bookmark bookmark, [int? collectionId]) =>
      transaction(() async {
        await update(bookmarks).replace(bookmark);
        if (collectionId != null) {
          await into(collectionBookmarkMappings).insert(
            CollectionBookmarkMappingsCompanion.insert(
              bookmarkId: bookmark.id,
              collectionId: collectionId,
              createdAt: DateTime.now(),
            ),
            mode: InsertMode.insertOrIgnore,
          );
        }
      });

  Future<bool> deleteBookmark(int id) async =>
      (await (delete(bookmarks)..where((t) => t.id.equals(id))).go()) > 0;
}
