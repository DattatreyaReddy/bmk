import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../commons/utils/app_utils.dart';
import '../../../commons/utils/extensions/custom_extensions.dart';
import '../../../commons/utils/toast/toast.dart';
import '../../../core/repository/app_database.dart';
import '../domain/bookmarks.dart';
import 'bookmark_sheet.dart';
import 'preview_place_holder.dart';

class BookmarkCard extends HookConsumerWidget {
  const BookmarkCard({
    super.key,
    required this.bookmark,
    this.selected = false,
    this.expanded = false,
    this.onTap,
  });
  final Bookmark bookmark;
  final bool expanded;
  final bool selected;
  final VoidCallback? onTap;
  @override
  Widget build(context, ref) {
    final colorScheme = bookmark.colorScheme(context);
    return Card(
      color: colorScheme.primaryContainer,
      shape: selected
          ? RoundedRectangleBorder(
              side: BorderSide(
                width: 2,
                color: colorScheme.onPrimaryContainer ??
                    context.colorScheme.onSurface,
              ),
              borderRadius: BorderRadius.circular(12),
            )
          : null,
      clipBehavior: Clip.hardEdge,
      child: AppUtils.wrapChildIf(
        condition: expanded,
        elseWrap: (child) => InkWell(
          onSecondaryTap: () => AppUtils.launchUrlInWeb(
            context,
            bookmark.uri.toString(),
            ref.read(toastProvider),
          ),
          onDoubleTap: () => AppUtils.launchUrlInWeb(
            context,
            bookmark.uri.toString(),
            ref.read(toastProvider),
          ),
          onTap: onTap ??
              () => context
                  .pushBottomSheet(BookmarkSheet(bookmarkId: bookmark.id)),
          child: child,
        ),
        wrap: (child) => Stack(
          alignment: Alignment.topRight,
          children: [
            child,
            Card.filled(
              clipBehavior: Clip.hardEdge,
              color: colorScheme.onPrimary,
              margin: EdgeInsets.all(6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.close_rounded),
                ),
              ),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              margin: const EdgeInsets.all(6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.hardEdge,
              color: colorScheme.primary,
              child: bookmark.preview != null
                  ? CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: AppUtils.wrapUriWithProxy(bookmark.preview),
                      progressIndicatorBuilder: (_, __, ___) =>
                          PreviewPlaceHolder(
                        label: bookmark.placeholderLabel,
                        colorScheme: colorScheme,
                      ),
                      errorWidget: (context, url, error) => PreviewPlaceHolder(
                        label: bookmark.placeholderLabel,
                        colorScheme: colorScheme,
                      ),
                    )
                  : PreviewPlaceHolder(
                      label: bookmark.placeholderLabel,
                      colorScheme: colorScheme,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12) +
                  EdgeInsets.only(bottom: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (bookmark.siteName.isNotBlank)
                    Text(
                      bookmark.siteName!,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                  if (bookmark.title.isNotBlank)
                    Text(
                      bookmark.title!,
                      overflow: TextOverflow.ellipsis,
                      style: (expanded
                              ? context.textTheme.titleMedium
                              : context.textTheme.titleSmall)
                          ?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  if (bookmark.description.isNotBlank)
                    Text(
                      bookmark.description!,
                      style: context.textTheme.bodySmall?.copyWith(
                        height: 1.3,
                        color: colorScheme.onPrimaryContainer?.withOpacity(0.8),
                      ),
                      overflow: expanded ? null : TextOverflow.ellipsis,
                      maxLines: expanded ? null : 3,
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
