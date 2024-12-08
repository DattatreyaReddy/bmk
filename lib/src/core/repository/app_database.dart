import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../commons/utils/dto/color_scheme_dto.dart';
import '../../feature/bookmarks/domain/bookmarks.dart';
import '../../feature/bookmarks/domain/drift_converters.dart';
import '../../feature/collections/domain/collection_bookmark_mapping.dart';
import '../../feature/collections/domain/collections.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Bookmarks, Collections, CollectionBookmarkMappings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() => driftDatabase(name: 'bmk');
}
