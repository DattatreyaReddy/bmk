// Copyright (c) 2024 Panta Dattatreya Reddy
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
// we use the gql_exec from ferry itself to avoid version incompatibility
// ignore: depend_on_referenced_packages
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../app_utils.dart';
import '../toast/toast.dart';
import '../widgets/emoticons.dart';

part 'custom_extensions/async_value_extensions.dart';
part 'custom_extensions/bool_extensions.dart';
part 'custom_extensions/context_extensions.dart';
part 'custom_extensions/date_time_extensions.dart';
part 'custom_extensions/double_extensions.dart';
part 'custom_extensions/int_extensions.dart';
part 'custom_extensions/iterable_extensions.dart';
part 'custom_extensions/map_extensions.dart';
part 'custom_extensions/string_extensions.dart';
part 'custom_extensions/uri_extensions.dart';
