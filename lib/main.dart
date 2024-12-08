import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'src/bmk.dart';
import 'src/core/controller/core_controller.dart';
import 'src/core/repository/app_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase();
  final packageInfo = await PackageInfo.fromPlatform();

  runApp(
    ProviderScope(
      overrides: [
        dbProvider.overrideWithValue(database),
        packageInfoProvider.overrideWithValue(packageInfo),
      ],
      child: const Bmk(),
    ),
  );
}
