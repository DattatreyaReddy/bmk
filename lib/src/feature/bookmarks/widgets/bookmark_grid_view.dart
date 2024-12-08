import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../commons/utils/app_utils.dart';
import '../../../commons/utils/extensions/custom_extensions.dart';
import '../controller/bookmark_controller.dart';
import 'bookmark_card.dart';

class BookmarkGridView extends ConsumerWidget {
  const BookmarkGridView({super.key});
  @override
  Widget build(context, ref) {
    final bookmarkList = ref.watch(bookmarksProvider);
    return bookmarkList.showUiWhenData(
      context,
      wrapper: (child) => SliverToBoxAdapter(
        child: Container(
          height: 400,
          alignment: Alignment.center,
          child: Center(child: child),
        ),
      ),
      (data) {
        if (data.isBlank) {
          return SliverToBoxAdapter(
            child: Container(
              height: 400,
              alignment: Alignment.center,
              child: Text("Add Bookmarks"),
            ),
          );
        }
        return SliverMasonryGrid.count(
          crossAxisCount: AppUtils.responsiveCardCount(context),
          childCount: data.length,
          itemBuilder: (context, index) => BookmarkCard(bookmark: data[index]),
        );
      },
    );
  }
}
