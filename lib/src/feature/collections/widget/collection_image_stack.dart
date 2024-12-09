import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../commons/utils/app_utils.dart';
import '../../../commons/utils/dto/color_scheme_dto.dart';
import '../../../commons/utils/extensions/custom_extensions.dart';
import '../../../core/repository/app_database.dart';
import '../../bookmarks/domain/bookmarks.dart';
import '../../bookmarks/widgets/preview_place_holder.dart';

class CollectionImageStack extends StatelessWidget {
  const CollectionImageStack({
    super.key,
    required this.collection,
    required this.bookmarks,
  });
  final Collection collection;
  final AsyncValue<List<Bookmark>> bookmarks;
  @override
  Widget build(context) {
    if (bookmarks.valueOrNull == null ||
        (bookmarks.hasValue && bookmarks.valueOrNull.isBlank)) {
      return PreviewPlaceHolder(
        label: collection.name,
        colorScheme: ColorSchemeDto.fromColorScheme(context.colorScheme),
      );
    }
    final bookmarkList = bookmarks.valueOrNull;
    return Card.outlined(
      margin: EdgeInsets.zero,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 224),
        child: Stack(
          children: [
            for (int i = (bookmarkList?.length ?? 3) - 1; i >= 0; i--)
              Card.outlined(
                margin: EdgeInsets.only(left: i * 32),
                clipBehavior: Clip.hardEdge,
                color: bookmarkList?[i].colorScheme(context).primary,
                child: CachedNetworkImage(
                  height: 128,
                  width: 128,
                  fit: BoxFit.cover,
                  imageUrl: AppUtils.wrapUriWithProxy(bookmarkList?[i].preview),
                  progressIndicatorBuilder: (_, __, ___) => PreviewPlaceHolder(
                    label: bookmarkList?[i].placeholderLabel ?? collection.name,
                    colorScheme: bookmarkList?[i].colorScheme(context),
                  ),
                  errorWidget: (context, url, error) => PreviewPlaceHolder(
                    label: bookmarkList?[i].placeholderLabel ?? collection.name,
                    colorScheme: bookmarkList?[i].colorScheme(context),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
