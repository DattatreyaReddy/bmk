import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import '../../commons/utils/extensions/custom_extensions.dart';
import '../../router/router_config.dart';
import '../bookmarks/widgets/bookmark_grid_view.dart';
import '../bookmarks/widgets/upsert_book_mark_popup.dart';
import '../collections/widget/collection_list_view.dart';
import 'widgets/section_title_tile.dart';

class HomeScreen extends StatefulHookWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription _intentSub;
  @override
  void initState() {
    super.initState();
    if (kIsWeb || !Platform.isAndroid) return;
    // Listen to media sharing coming from outside the app while the app is in the memory.
    _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen((value) {
      setState(() {
        final media = value.firstOrNull;
        String? url = media?.message.extractFirstUrl;
        if (url.isBlank) {
          url = media?.path.extractFirstUrl;
        }
        if (url.isNotBlank) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            showDialog(
                context: context, builder: (context) => UpsertBookMarkPopup());
          });
        }
      });
    }, onError: (err) {
      log("getIntentDataStream error: $err");
    });

    // Get the media sharing coming from outside the app while the app is closed.
    ReceiveSharingIntent.instance.getInitialMedia().then((value) {
      setState(() {
        final media = value.firstOrNull;
        String? url = media?.message.extractFirstUrl;
        if (url.isBlank) {
          url = media?.path.extractFirstUrl;
        }
        if (url.isNotBlank) {
          showDialog(
            context: context,
            builder: (context) {
              return UpsertBookMarkPopup(url: url);
            },
          );
        }

        // Tell the library that we are done processing the intent.
        ReceiveSharingIntent.instance.reset();
      });
    });
  }

  @override
  void dispose() {
    if (!kIsWeb && Platform.isAndroid) _intentSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.appName)),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () => showDialog(
          context: context,
          builder: (context) => UpsertBookMarkPopup(),
        ),
        child: Icon(Icons.add_rounded),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SectionTitleTile(
                onTap: () => const CollectionListRoute().go(context),
                title: context.l10n.collections,
              ),
            ),
            SliverToBoxAdapter(child: CollectionListView()),
            SliverToBoxAdapter(
              child: SectionTitleTile(
                onTap: () => const BookmarkListRoute().go(context),
                title: context.l10n.bookmarks,
              ),
            ),
            BookmarkGridView(),
            SliverToBoxAdapter(child: Gap(96)),
          ],
        ),
      ),
    );
  }
}
