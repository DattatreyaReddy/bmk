import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repository/app_database.dart';

part 'core_controller.g.dart';

@riverpod
AppDatabase db(Ref ref) => throw UnimplementedError("");

@riverpod
PackageInfo packageInfo(Ref ref) => throw UnimplementedError();

@Riverpod(keepAlive: true)
class AppUpdateCheck extends _$AppUpdateCheck {
  @override
  bool build() => false;

  bool checkCompleted() => state = true;
}
