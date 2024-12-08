import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../commons/utils/app_utils.dart';
import '../../../commons/utils/extensions/custom_extensions.dart';
import '../../../commons/utils/widgets/custom_circular_progress_indicator.dart';
import '../../../core/controller/core_controller.dart';
import '../../../core/repository/app_database.dart';
import '../repository/bookmark_repository.dart';

class BookmarkNotesPopup extends HookConsumerWidget {
  const BookmarkNotesPopup({super.key, required this.bookmark});
  final Bookmark bookmark;
  @override
  Widget build(context, ref) {
    final notesController = useTextEditingController(text: bookmark.notes);
    final isLoading = useState(false);
    return AlertDialog(
      title: Text(context.l10n.notes),
      content: TextField(
        controller: notesController,
        maxLines: 5,
        minLines: 1,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          hintText: context.l10n.enterNotes,
          border: const OutlineInputBorder(),
        ),
        onTapOutside: (event) => context.hideKeyboard,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.close),
        ),
        FilledButton(
          onPressed: AppUtils.returnIf(!isLoading.value, () async {
            isLoading.value = true;
            await ref.read(dbProvider).updateBookmark(
                  bookmark.copyWith(notes: Value(notesController.text)),
                );
            isLoading.value = true;
            if (context.mounted) Navigator.pop(context);
          }),
          child: isLoading.value
              ? MiniCircularProgressIndicator()
              : Text(context.l10n.save),
        ),
      ],
    );
  }
}
