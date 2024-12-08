import 'package:drift/drift.dart';

import '../../bookmarks/domain/bookmarks.dart';
import 'collections.dart';

@TableIndex(name: 'bookmark_index', columns: {#bookmarkId})
@TableIndex(name: 'collection_index', columns: {#collectionId})
class CollectionBookmarkMappings extends Table {
  late final id = integer().autoIncrement()();
  late final bookmarkId =
      integer().references(Bookmarks, #id, onDelete: KeyAction.cascade)();
  late final collectionId =
      integer().references(Collections, #id, onDelete: KeyAction.cascade)();
  late final createdAt = dateTime()();
  @override
  List<Set<Column>> get uniqueKeys => [
        {bookmarkId, collectionId}
      ];
}
