import 'package:drift/drift.dart';

class Collections extends Table {
  late final id = integer().autoIncrement()();
  late final name = text()();
  late final createdAt = dateTime()();
}
