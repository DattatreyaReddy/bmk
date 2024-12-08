import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/controller/core_controller.dart';
import '../../../core/repository/app_database.dart';
import '../../bookmarks/repository/bookmark_repository.dart';
import '../repository/collection_bookmark_mapping_repository.dart';
import '../repository/collection_repository.dart';

part 'collection_controller.g.dart';

@riverpod
Stream<List<Collection>> collections(Ref ref) =>
    ref.watch(dbProvider).watchCollections;

@riverpod
Stream<Collection?> collection(Ref ref, int? id) {
  if (id == null) return Stream.value(null);
  return ref.watch(dbProvider).watchCollection(id);
}

@riverpod
Stream<List<Bookmark>> bookmarksOrderByCollection(Ref ref, int? collectionId) {
  if (collectionId == null) return ref.watch(dbProvider).watchBookmarks;
  return ref.watch(dbProvider).watchBookmarksOrderByCollectionId(collectionId);
}

@riverpod
Stream<List<CollectionBookmarkMapping>?> mappingWithCollectionId(
    Ref ref, int? collectionId) {
  if (collectionId == null) return Stream.value(null);
  return ref.watch(dbProvider).watchMappingWithCollectionId(collectionId);
}

@riverpod
Stream<List<CollectionBookmarkMapping>?> mappingWithBookmarkId(
    Ref ref, int? bookmarkId) {
  if (bookmarkId == null) return Stream.value(null);
  return ref.watch(dbProvider).watchMappingWithBookmarkId(bookmarkId);
}

@riverpod
Stream<List<Bookmark>> firstNBookmarksByCollectionId(
  Ref ref,
  int collectionId, [
  int n = 3,
]) =>
    ref.watch(dbProvider).watchFirstNMappedBookmarks(collectionId, n);

@riverpod
Stream<List<Bookmark>> bookmarksByCollectionId(Ref ref, int collectionId) =>
    ref.watch(dbProvider).watchMappedBookmarks(collectionId);
