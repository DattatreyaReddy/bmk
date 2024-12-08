import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../commons/utils/app_utils.dart';
import '../../../commons/utils/extensions/custom_extensions.dart';
import '../../../commons/utils/toast/toast.dart';
import '../../../core/controller/core_controller.dart';
import '../../../core/repository/app_database.dart';
import '../../bookmarks/widgets/bookmark_card.dart';
import '../repository/collection_bookmark_mapping_repository.dart';

class UpsertCollectionView extends HookConsumerWidget {
  const UpsertCollectionView({
    super.key,
    this.collection,
    required this.bookmarks,
    this.mappings,
  });
  final Collection? collection;
  final List<Bookmark> bookmarks;
  final List<CollectionBookmarkMapping>? mappings;
  @override
  Widget build(context, ref) {
    final collectionNameController =
        useTextEditingController(text: collection?.name);
    final selectedBookmarkIdSet =
        useState(mappings?.map((m) => m.bookmarkId).toSet() ?? {});
    final isLoading = useState(true);
    return Scaffold(
      appBar: AppBar(
        title: Text(collection != null
            ? context.l10n.editCollection
            : context.l10n.addCollection),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(context.l10n.save),
        icon: Icon(Icons.save_rounded),
        onPressed: () async {
          final collectionName = collectionNameController.text;
          if (collectionName.isBlank) {
            ref
                .watch(toastProvider)
                ?.showError(context.l10n.collectionNameRequired);
            return;
          }
          isLoading.value = true;
          final newlyAddedBookmarkIds = {...selectedBookmarkIdSet.value};

          if (collection != null) {
            final newCollection = collection!.copyWith(name: collectionName);
            await ref.watch(dbProvider).updateCollectionAndMapping(
                newCollection, newlyAddedBookmarkIds);
          } else {
            final newCollection = CollectionsCompanion.insert(
              name: collectionName,
              createdAt: DateTime.now(),
            );
            await ref.watch(dbProvider).createCollectionAndMapping(
                newCollection, newlyAddedBookmarkIds);
          }
          if (context.mounted) {
            context.pop();
            isLoading.value = true;
          }
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: TextField(
              controller: collectionNameController,
              decoration: InputDecoration(
                hintText: context.l10n.collectionName,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ListTile(
            dense: true,
            onTap: selectedBookmarkIdSet.value.isNotEmpty
                ? () => selectedBookmarkIdSet.value = {}
                : null,
            title: Text(
              "${context.l10n.selected}${selectedBookmarkIdSet.value.length.compact(addPrefixAndSuffix: true)}",
            ),
          ),
          Expanded(
            child: MasonryGridView.count(
              padding: EdgeInsets.only(bottom: 96),
              crossAxisCount: AppUtils.responsiveCardCount(context),
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final bookmark = bookmarks[index];
                return BookmarkCard(
                  bookmark: bookmark,
                  selected: selectedBookmarkIdSet.value.contains(bookmark.id),
                  onTap: () {
                    final neSelectedSet = {...selectedBookmarkIdSet.value};
                    if (neSelectedSet.contains(bookmark.id)) {
                      neSelectedSet.remove(bookmark.id);
                    } else {
                      neSelectedSet.add(bookmark.id);
                    }
                    selectedBookmarkIdSet.value = neSelectedSet;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
