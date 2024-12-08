import 'package:flutter/material.dart';

import '../../commons/utils/extensions/custom_extensions.dart';
import 'widgets/bookmark_grid_view.dart';
import 'widgets/upsert_book_mark_popup.dart';

class BookmarkListScreen extends StatelessWidget {
  const BookmarkListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.bookmarks)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => UpsertBookMarkPopup(),
        ),
        child: Icon(Icons.add_rounded),
      ),
      body: CustomScrollView(
        slivers: [
          BookmarkGridView(),
        ],
      ),
    );
  }
}
