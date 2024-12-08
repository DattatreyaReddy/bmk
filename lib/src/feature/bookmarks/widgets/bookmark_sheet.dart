import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../commons/utils/app_utils.dart';
import '../../../commons/utils/extensions/custom_extensions.dart';
import '../../../commons/utils/toast/toast.dart';
import '../../../core/controller/core_controller.dart';
import '../../../core/repository/app_database.dart';
import '../controller/bookmark_controller.dart';
import '../domain/bookmarks.dart';
import '../repository/bookmark_repository.dart';
import 'bookmark_action_tile.dart';
import 'bookmark_card.dart';
import 'bookmark_notes_popup.dart';
import 'upsert_book_mark_popup.dart';

class BookmarkSheet extends HookConsumerWidget {
  const BookmarkSheet({
    super.key,
    required this.bookmarkId,
  });
  final int bookmarkId;
  @override
  Widget build(context, ref) {
    final bookmarkData = ref.watch(bookmarkProvider(bookmarkId));
    return bookmarkData.showUiWhenData(
      context,
      (data) => BookmarkSheetView(bookmark: data),
      wrapper: (child) => Center(child: child),
    );
  }
}

class BookmarkSheetView extends HookConsumerWidget {
  const BookmarkSheetView({
    super.key,
    required this.bookmark,
  });

  final Bookmark bookmark;

  @override
  Widget build(context, ref) {
    final colorScheme = bookmark.colorScheme(context);
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
          onPressed: () => AppUtils.launchUrlInWeb(
            context,
            bookmark.uri.toString(),
            ref.read(toastProvider),
          ),
          label: Text(context.l10n.open),
          icon: Icon(Icons.link_rounded),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: [
              Gap(64),
              BookmarkCard(bookmark: bookmark, expanded: true),
              Card(
                color: colorScheme.primaryContainer,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Column(
                    children: [
                      BookmarkActionTile(
                        title: context.l10n.copyLink,
                        subtitle: bookmark.uri.toString(),
                        icon: Icons.copy_rounded,
                        roundTop: true,
                        onTap: () async {
                          await Clipboard.setData(
                              ClipboardData(text: bookmark.uri.toString()));
                          if (!context.mounted) return;
                          ref.read(toastProvider)?.show(context.l10n.urlCopied);
                        },
                      ),
                      BookmarkActionTile(
                        title: context.l10n.editBookmark,
                        icon: Icons.edit_rounded,
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) =>
                              UpsertBookMarkPopup(bookmark: bookmark),
                        ),
                      ),
                      BookmarkActionTile(
                        title: context.l10n.notes,
                        subtitle: bookmark.notes,
                        icon: Icons.notes_rounded,
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) =>
                              BookmarkNotesPopup(bookmark: bookmark),
                        ),
                      ),
                      BookmarkActionTile(
                        title: context.l10n.deleteBookMark,
                        roundBottom: true,
                        icon: Icons.delete_rounded,
                        onTap: () async {
                          final shouldDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(context.l10n.deleteBookMark),
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
                            await ref
                                .watch(dbProvider)
                                .deleteBookmark(bookmark.id);
                            if (context.mounted) {
                              ref
                                  .read(toastProvider)
                                  ?.show(context.l10n.deleted);
                              Navigator.pop(context);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Gap(128),
            ],
          ),
        ),
      ),
    );
  }
}
