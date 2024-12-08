import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../commons/utils/app_utils.dart';
import '../../commons/utils/extensions/custom_extensions.dart';
import '../../commons/utils/toast/toast.dart';
import '../../core/controller/core_controller.dart';
import '../../router/router_config.dart';
import '../bookmarks/widgets/bookmark_card.dart';
import '../bookmarks/widgets/upsert_book_mark_popup.dart';
import 'controller/collection_controller.dart';
import 'repository/collection_repository.dart';

class CollectionDetailsScreen extends ConsumerWidget {
  const CollectionDetailsScreen({super.key, required this.collectionId});
  final int collectionId;
  @override
  Widget build(context, ref) {
    final bookmarkList =
        ref.watch(bookmarksByCollectionIdProvider(collectionId));
    final collection = ref.watch(collectionProvider(collectionId)).valueOrNull;
    return Scaffold(
      appBar: AppBar(
        title: Text(collection?.name ?? context.l10n.collections),
        actions: [
          IconButton(
            onPressed: () => EditCollectionRoute(collectionId).go(context),
            icon: Icon(Icons.edit_rounded),
          ),
          if (collection != null)
            IconButton(
              onPressed: () async {
                final shouldDelete = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(context.l10n.deleteCollection),
                    content: Text(context.l10n.areYouSure),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(context.l10n.close),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(context.l10n.delete),
                      ),
                    ],
                  ),
                );
                if (shouldDelete.ifNull()) {
                  await ref.watch(dbProvider).deleteCollection(collection.id);
                  if (context.mounted) {
                    ref.read(toastProvider)?.show(context.l10n.deleted);
                    Navigator.pop(context);
                  }
                }
              },
              icon: Icon(Icons.delete),
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => UpsertBookMarkPopup(collectionId: collectionId),
        ),
        child: Icon(Icons.add_rounded),
      ),
      body: bookmarkList.showUiWhenData(context, (data) {
        if (data.isBlank) {
          return Center(child: Text(context.l10n.noCollections));
        }
        return MasonryGridView.count(
          padding: EdgeInsets.only(bottom: 96),
          crossAxisCount: AppUtils.responsiveCardCount(context),
          itemCount: data.length,
          itemBuilder: (context, index) => BookmarkCard(bookmark: data[index]),
        );
      }),
    );
  }
}
