import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../commons/utils/app_utils.dart';
import '../../commons/utils/extensions/custom_extensions.dart';
import '../../router/router_config.dart';
import 'controller/collection_controller.dart';
import 'widget/collection_card.dart';

class CollectionListScreen extends ConsumerWidget {
  const CollectionListScreen({super.key});

  @override
  Widget build(context, ref) {
    final collections = ref.watch(collectionsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.collections),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => const AddCollectionRoute().go(context),
        child: Icon(Icons.add_rounded),
      ),
      body: collections.showUiWhenData(context, (data) {
        if (data.isBlank) {
          return Center(child: Text(context.l10n.noCollections));
        }
        return MasonryGridView.count(
          padding: EdgeInsets.only(bottom: 96),
          crossAxisCount: AppUtils.responsiveCardCount(context),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final collection = data[index];
            return CollectionCard(collection: collection);
          },
        );
      }),
    );
  }
}
