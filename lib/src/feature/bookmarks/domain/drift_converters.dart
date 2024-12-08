import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../commons/utils/dto/color_scheme_dto.dart';

// stores preferences as strings
class UriConverter extends TypeConverter<Uri, String>
    with JsonTypeConverter<Uri, String> {
  const UriConverter();

  @override
  Uri fromSql(String fromDb) {
    return Uri.parse(json.decode(fromDb) as String);
  }

  @override
  String toSql(Uri value) {
    return json.encode(value.toString());
  }
}

// stores preferences as strings
class ColorSchemaDtoConverter extends TypeConverter<ColorSchemeDto, String>
    with JsonTypeConverter<ColorSchemeDto, String> {
  const ColorSchemaDtoConverter();

  @override
  ColorSchemeDto fromSql(String fromDb) {
    return ColorSchemeDto.fromJson(json.decode(fromDb) as Map<String, dynamic>);
  }

  @override
  String toSql(ColorSchemeDto value) {
    return json.encode(value.toJson());
  }
}
