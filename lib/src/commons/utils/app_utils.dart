// Copyright (c) 2024 Panta Dattatreya Reddy
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/gen/constants.dart';
import 'extensions/custom_extensions.dart';
import 'toast/toast.dart';

abstract class AppUtils {
  static Widget wrapOn(Widget Function(Widget)? wrapper, Widget child) {
    if (wrapper != null) {
      return wrapper(child);
    }
    return child;
  }

  static Widget wrapChildIf({
    bool? condition,
    Widget Function(Widget)? wrap,
    Widget Function(Widget)? elseWrap,
    required Widget child,
  }) {
    if (wrap != null && condition.ifNull()) {
      return wrap(child);
    }
    return elseWrap?.call(child) ?? child;
  }

  static T? wrapIf<T, U>({
    bool? condition,
    required U? child,
    T? Function(U?)? wrap,
  }) {
    if (wrap != null && condition.ifNull()) {
      return wrap(child);
    }
    return null;
  }

  static T? returnIf<T>(
    bool? condition,
    T? value, [
    T? elseValue,
  ]) {
    if (condition.ifNull()) {
      return value;
    }
    return elseValue;
  }

  static Future<T?> guard<T>(
    Future<T> Function() future,
    Toast? toast, [
    bool Function(Object)? test,
  ]) async =>
      (await AsyncValue.guard(future, test)).valueOrToast(toast);

  static String formatDates(DateTime d1, DateTime d2) {
    StringBuffer stringBuffer = StringBuffer();
    if (d1.year == d2.year) {
      if (d1.month == d2.month) {
        stringBuffer.write(d1.day);
      } else {
        stringBuffer.write(d1.toDayMonthString);
      }
    } else {
      stringBuffer.write(d1.toDateString);
    }
    stringBuffer.write(" - ");
    stringBuffer.write(d2.toDateString);
    return stringBuffer.toString();
  }

  static Future<void> launchUrlInWeb(BuildContext context, String url,
      [Toast? toast]) async {
    if (!await launchUrl(
      Uri.parse(url),
      webOnlyWindowName: "_blank",
    )) {
      await Clipboard.setData(ClipboardData(text: url));
      if (context.mounted) toast?.showError(context.l10n.errorLaunchUrl(url));
    }
  }

  static void appUpdateDialog({
    required String title,
    required String newRelease,
    required BuildContext context,
    required Toast? toast,
    String? url,
  }) =>
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(context.l10n.newUpdateAvailable),
            content: Text(context.l10n.versionAvailable(title, newRelease)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(context.l10n.close),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  launchUrlInWeb(
                      context, url ?? Constants.githubLatestReleaseUrl, toast);
                  Navigator.pop(context);
                },
                icon: Icon(FontAwesomeIcons.github),
                label: Text(context.l10n.gitHub),
              ),
            ],
          );
        },
      );

  static Future<AsyncValue<Version?>> checkUpdate(
      PackageInfo packageInfo) async {
    final gitResponse = await AsyncValue.guard<Map<String, dynamic>?>(
        () async => json.decode((await http.get(
              Uri.parse(Constants.latestReleaseApiUrl),
            ))
                .body));

    return gitResponse.copyWithData<Version?>(
      (data) {
        String? tag = data?["tag_name"];
        Version? latestReleaseBuildNumber =
            tag != null ? Version.parse(tag) : null;
        Version? packageBuildNumber = Version.parse(packageInfo.version);
        if (latestReleaseBuildNumber != null &&
            latestReleaseBuildNumber
                .compareTo(packageBuildNumber)
                .isGreaterThan(0)) {
          return latestReleaseBuildNumber;
        }
        return null;
      },
    );
  }

  static int responsiveCardCount(BuildContext context) =>
      context.responsiveValue(
        watch: 1,
        mobile: 2,
        largeMobile: 3,
        tablet: 4,
        largeTablet: 5,
        smallDesktop: 6,
        desktop: 7,
        largeDesktop: 8,
      );
}
