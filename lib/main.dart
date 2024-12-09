import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'src/bmk.dart';
import 'src/core/controller/core_controller.dart';
import 'src/core/repository/db/connection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = constructDb();
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
