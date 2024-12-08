// Copyright (c) 2024 Panta Dattatreya Reddy
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../feature/bookmarks/bookmark_list_screen.dart';
import '../feature/collections/collection_details_screen.dart';
import '../feature/collections/collection_list_screen.dart';
import '../feature/collections/upsert_collection_screen.dart';
import '../feature/home/home_screen.dart';

part 'router_config.g.dart';

abstract class _Routes {
  static const home = '/';
  static const collectionList = 'collection';
  static const addCollection = 'add';
  static const collection = ':collectionId';

  static const editCollection = 'edit';

  static const bookmarkList = 'bookmark';
}

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

@riverpod
GoRouter routerConfig(Ref ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: kDebugMode,
    initialLocation: const HomeRoute().location,
    routes: $appRoutes,
  );
}

@TypedGoRoute<HomeRoute>(
  path: _Routes.home,
  routes: [
    TypedGoRoute<CollectionListRoute>(path: _Routes.collectionList, routes: [
      TypedGoRoute<AddCollectionRoute>(path: _Routes.addCollection),
      TypedGoRoute<CollectionDetailsRoute>(path: _Routes.collection, routes: [
        TypedGoRoute<EditCollectionRoute>(path: _Routes.editCollection),
      ]),
    ]),
    TypedGoRoute<BookmarkListRoute>(path: _Routes.bookmarkList),
  ],
)
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(context, state) => HomeScreen();
}

class BookmarkListRoute extends GoRouteData {
  const BookmarkListRoute();

  @override
  Widget build(context, state) => BookmarkListScreen();
}

class CollectionListRoute extends GoRouteData {
  const CollectionListRoute();

  @override
  Widget build(context, state) => CollectionListScreen();
}

class AddCollectionRoute extends GoRouteData {
  const AddCollectionRoute();

  @override
  Widget build(context, state) => UpsertCollectionScreen();
}

class CollectionDetailsRoute extends GoRouteData {
  const CollectionDetailsRoute(this.collectionId);
  final int collectionId;
  @override
  Widget build(context, state) =>
      CollectionDetailsScreen(collectionId: collectionId);
}

class EditCollectionRoute extends GoRouteData {
  const EditCollectionRoute(this.collectionId);
  final int collectionId;
  @override
  Widget build(context, state) =>
      UpsertCollectionScreen(collectionId: collectionId);
}
