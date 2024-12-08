import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../commons/utils/extensions/custom_extensions.dart';
import 'controller/collection_controller.dart';
import 'widget/upsert_collection_view.dart';

class UpsertCollectionScreen extends ConsumerWidget {
  const UpsertCollectionScreen({super.key, this.collectionId});

  final int? collectionId;
  @override
  Widget build(context, ref) {
    final bookmarksOrderedByCollection =
        ref.watch(bookmarksOrderByCollectionProvider(collectionId));
    final mappings = ref.watch(mappingWithCollectionIdProvider(collectionId));
    final collection = ref.watch(collectionProvider(collectionId));
    return bookmarksOrderedByCollection.showUiWhenData(context, (data) {
      return UpsertCollectionView(
        bookmarks: data,
        mappings: mappings.valueOrNull,
        collection: collection.valueOrNull,
      );
    });
  }
}
