// Copyright (c) 2024 Panta Dattatreya Reddy
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

part of '../custom_extensions.dart';

extension DoubleExtensions on double? {
  bool liesBetween({double lower = 0, double upper = 1}) =>
      this != null ? this! >= lower && this! <= upper : false;
  bool get isZero => this != null ? this! == 0 : true;
  bool get isNotZero => !isZero;
}
