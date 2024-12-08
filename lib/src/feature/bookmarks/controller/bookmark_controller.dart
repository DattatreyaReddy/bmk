import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/controller/core_controller.dart';
import '../../../core/repository/app_database.dart';
import '../repository/bookmark_repository.dart';

part 'bookmark_controller.g.dart';

@riverpod
Stream<List<Bookmark>> bookmarks(Ref ref) =>
    ref.watch(dbProvider).watchBookmarks;

@riverpod
Stream<Bookmark> bookmark(Ref ref, int id) =>
    ref.watch(dbProvider).watchBookmark(id);
