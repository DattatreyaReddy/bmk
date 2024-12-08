import 'package:drift/drift.dart';
import 'package:flutter/material.dart' as m;

import '../../../commons/utils/dto/color_scheme_dto.dart';
import '../../../commons/utils/extensions/custom_extensions.dart';
import '../../../core/repository/app_database.dart';
import 'drift_converters.dart';

class Bookmarks extends Table {
  late final id = integer().autoIncrement()();
  late final uri = text().map(const UriConverter())();
  late final description = text().nullable()();
  late final title = text().nullable()();
  late final notes = text().nullable()();
  late final createdAt = dateTime()();
  late final preview = text().map(const UriConverter()).nullable()();
  late final siteName = text().nullable()();
  late final lightColorSchema =
      text().map(const ColorSchemaDtoConverter()).nullable()();
  late final darkColorSchema =
      text().map(const ColorSchemaDtoConverter()).nullable()();
}

extension BookmarkExt on Bookmark {
  String get placeholderLabel => title ?? siteName ?? uri.toString();

  ColorSchemeDto colorScheme(m.BuildContext context) =>
      (context.isDarkMode ? darkColorSchema : lightColorSchema) ??
      ColorSchemeDto.fromColorScheme(context.colorScheme);
}
