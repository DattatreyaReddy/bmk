import 'package:any_link_preview/any_link_preview.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../commons/utils/app_utils.dart';
import '../../../commons/utils/dto/color_scheme_dto.dart';
import '../../../commons/utils/extensions/custom_extensions.dart';
import '../../../commons/utils/toast/toast.dart';
import '../../../commons/utils/widgets/custom_circular_progress_indicator.dart';
import '../../../core/controller/core_controller.dart';
import '../../../core/repository/app_database.dart';
import '../repository/bookmark_repository.dart';

class UpsertBookMarkPopup extends HookConsumerWidget {
  const UpsertBookMarkPopup(
      {super.key, this.bookmark, this.url, this.collectionId});
  final Bookmark? bookmark;
  final String? url;
  final int? collectionId;
  @override
  Widget build(context, ref) {
    final uriController =
        useTextEditingController(text: url ?? bookmark?.uri.toString());
    final isLoading = useState(false);
    return AlertDialog(
      title: Text(bookmark != null
          ? context.l10n.editBookmark
          : context.l10n.addBookmark),
      content: TextField(
        controller: uriController,
        decoration: InputDecoration(
          hintText: context.l10n.enterUrl,
          border: const OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel)),
        FilledButton(
          onPressed: AppUtils.returnIf(!isLoading.value, () async {
            if (Uri.tryParse(uriController.text) == null) {
              ref.watch(toastProvider)?.showError(context.l10n.validUrl);
              return;
            }
            if (!AnyLinkPreview.isValidLink(uriController.text)) {
              ref.watch(toastProvider)?.showError(context.l10n.validUrl);
              return;
            }
            isLoading.value = true;
            final uri = Uri.parse(uriController.text);
            Metadata? metadata = await AnyLinkPreview.getMetadata(
              link: uri.toString(),
              cache: Duration(days: 7),
              proxyUrl: kIsWeb
                  ? "https://api.codetabs.com/v1/proxy?quest="
                  : null, // Need for web
            );

            final schemeDtoList = await Future.wait([
              ColorSchemeDto.fromUrl(metadata?.image, Brightness.light),
              ColorSchemeDto.fromUrl(metadata?.image, Brightness.dark)
            ]);
            if (bookmark != null) {
              final newBookmark = bookmark!.copyWith(
                uri: (metadata?.url).isNotBlank
                    ? Uri.tryParse(metadata!.url!)
                    : bookmark!.uri,
                description: Value(metadata?.desc ?? bookmark!.description),
                title: Value(metadata?.title ?? bookmark!.title),
                preview: Value((metadata?.image).isNotBlank
                    ? Uri.tryParse(metadata!.image!)
                    : bookmark!.preview),
                siteName: Value(metadata?.siteName ?? bookmark!.siteName),
                lightColorSchema:
                    Value(schemeDtoList.first ?? bookmark!.lightColorSchema),
                darkColorSchema:
                    Value(schemeDtoList.last ?? bookmark!.darkColorSchema),
              );
              await ref
                  .read(dbProvider)
                  .updateBookmark(newBookmark, collectionId);
            } else {
              final newBookmark = BookmarksCompanion.insert(
                uri: uri,
                createdAt: DateTime.now(),
                description: Value(metadata?.desc),
                title: Value(metadata?.title),
                preview: Value((metadata?.image).isNotBlank
                    ? Uri.tryParse(metadata!.image!)
                    : null),
                siteName: Value(metadata?.siteName ?? uri.host),
                lightColorSchema: Value(schemeDtoList.first),
                darkColorSchema: Value(schemeDtoList.last),
              );
              await ref
                  .read(dbProvider)
                  .createBookmark(newBookmark, collectionId);
            }
            if (context.mounted) {
              isLoading.value = false;
              Navigator.pop(context);
            }
          }),
          child: isLoading.value
              ? MiniCircularProgressIndicator()
              : Text(context.l10n.save),
        ),
      ],
    );
  }
}
