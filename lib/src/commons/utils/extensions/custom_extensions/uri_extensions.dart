part of '../custom_extensions.dart';

extension UriExtensions on Uri {
  String? get domain {
    if (host.isEmpty) return null;

    // Regex to match the base domain name
    final regex = RegExp(r'^(?:www\.)?([^\.]+)');
    final match = regex.firstMatch(host);

    // Return the first captured group (domain name) or null if no match
    return match?.group(1);
  }
}
