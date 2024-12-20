// Copyright (c) 2024 Panta Dattatreya Reddy
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

part of '../custom_extensions.dart';

extension IterableExtensions<T> on Iterable<T>? {
  bool get isNull => this == null;

  bool get isBlank => isNull || this!.isEmpty;

  bool get isNotBlank => !isBlank;

  bool get isSingleton => isNotBlank && this!.length == 1;

  T? get firstOrNull {
    if (isNull) return null;
    var iterator = this!.iterator;
    if (iterator.moveNext()) return iterator.current;
    return null;
  }

  String get toPath => isNotBlank ? this!.join("/") : "/";

  T? lastWhereOrNull(bool Function(T element) test, {T Function()? orElse}) {
    if (isNull) return null;
    try {
      return this!.lastWhere(test, orElse: orElse);
    } catch (e) {
      return null;
    }
  }

  T? firstWhereOrNull(bool Function(T element) test, {T Function()? orElse}) {
    if (isNull) return null;
    try {
      return this!.firstWhere(test, orElse: orElse);
    } catch (e) {
      return null;
    }
  }

  T? get getRandom =>
      isNull ? null : this!.elementAt(Random().nextInt(this!.length));

  Iterable<T>? get filterOutNulls => this?.where((element) => element != null);

  LinkedHashMap<S, List<T>>? groupBy<S>(S Function(T) key) {
    if (this == null) {
      return null;
    }
    LinkedHashMap<S, List<T>> map = LinkedHashMap<S, List<T>>();
    for (var element in this!) {
      (map[key(element)] ??= []).add(element);
    }
    return map;
  }
}
