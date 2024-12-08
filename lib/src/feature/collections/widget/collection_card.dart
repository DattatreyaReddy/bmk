import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../commons/utils/extensions/custom_extensions.dart';
import '../../../core/repository/app_database.dart';
import '../../../router/router_config.dart';
import '../../bookmarks/domain/bookmarks.dart';
import '../controller/collection_controller.dart';
import 'collection_image_stack.dart';

class CollectionCard extends HookConsumerWidget {
  const CollectionCard({super.key, required this.collection});
  final Collection collection;
  @override
  Widget build(context, ref) {
    final bookmarks =
        ref.watch(firstNBookmarksByCollectionIdProvider(collection.id));
    final colorScheme = bookmarks.valueOrNull?.first.colorScheme(context);
    return Card(
      color: colorScheme?.primaryContainer,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => CollectionDetailsRoute(collection.id).go(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: CollectionImageStack(
                    collection: collection, bookmarks: bookmarks),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8) +
                    EdgeInsets.only(top: 8),
                child: Text(
                  collection.name,
                  style: context.textTheme.labelLarge
                      ?.copyWith(color: colorScheme?.onPrimaryContainer),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
