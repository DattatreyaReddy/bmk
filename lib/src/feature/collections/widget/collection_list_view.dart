import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../commons/utils/extensions/custom_extensions.dart';
import '../../../router/router_config.dart';
import '../controller/collection_controller.dart';
import 'collection_card.dart';

class CollectionListView extends ConsumerWidget {
  const CollectionListView({super.key});

  @override
  Widget build(context, ref) {
    final collections = ref.watch(collectionsProvider);
    return collections.showUiWhenData(context,
        wrapper: (child) => Center(child: child), (data) {
      if (data.isBlank) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Card(
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap: () => const AddCollectionRoute().go(context),
              child: SizedBox(
                width: 128,
                height: 64,
                child: Center(child: Text(context.l10n.addCollection)),
              ),
            ),
          ),
        );
      }
      return SizedBox(
        height: 192,
        width: context.width,
        child: ListView.builder(
          itemCount: data.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final collection = data[index];
            return CollectionCard(collection: collection);
          },
        ),
      );
    });
  }
}
