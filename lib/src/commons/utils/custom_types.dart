// Copyright (c) 2024 Panta Dattatreya Reddy
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import 'dart:async';

import 'abstracts/generic_entity.dart';

typedef ConvertFunction<S, R> = R Function(S);

typedef JsonObject = Map<String, Object?>;

typedef AsyncConvertFunction<S, R> = FutureOr<R> Function(S event);

typedef GenericFromJson<T extends GenericEntity> = T Function(
    Map<String, dynamic>);
