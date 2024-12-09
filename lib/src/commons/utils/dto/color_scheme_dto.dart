import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../app_utils.dart';
import '../extensions/custom_extensions.dart';

class ColorSchemeDto {
  const ColorSchemeDto(
    this.brightness,
    this.primary,
    this.onPrimary,
    this.primaryContainer,
    this.onPrimaryContainer,
    this.surface,
    this.onSurface,
  );

  final Brightness brightness;
  final Color primary;
  final Color onPrimary;
  final Color? primaryContainer;
  final Color? onPrimaryContainer;
  final Color surface;
  final Color onSurface;

  // Convert to JSON (Map)
  Map<String, dynamic> toJson() {
    return {
      'brightness':
          brightness.name, // Store as a string like 'Brightness.light'
      'primary': primary.value,
      'onPrimary': onPrimary.value,
      'primaryContainer': primaryContainer?.value,
      'onPrimaryContainer': onPrimaryContainer?.value,
      'surface': surface.value,
      'onSurface': onSurface.value,
    };
  }

  // Convert from JSON (Map)
  factory ColorSchemeDto.fromJson(Map<String, dynamic> json) {
    return ColorSchemeDto(
      json['brightness'] == 'light' ? Brightness.light : Brightness.dark,
      Color(json['primary'] as int),
      Color(json['onPrimary'] as int),
      json['primaryContainer'] != null
          ? Color(json['primaryContainer'] as int)
          : null,
      json['onPrimaryContainer'] != null
          ? Color(json['onPrimaryContainer'] as int)
          : null,
      Color(json['surface'] as int),
      Color(json['onSurface'] as int),
    );
  }

  factory ColorSchemeDto.fromColorScheme(ColorScheme colorScheme) {
    return ColorSchemeDto(
      colorScheme.brightness,
      colorScheme.primary,
      colorScheme.onPrimary,
      colorScheme.primaryContainer,
      colorScheme.onPrimaryContainer,
      colorScheme.surface,
      colorScheme.onSurface,
    );
  }

  static Future<ColorSchemeDto?> fromUrl(
      String? imageUrl, Brightness brightness) async {
    if (imageUrl.isBlank) return null;
    try {
      ColorScheme scheme = await ColorScheme.fromImageProvider(
        provider: CachedNetworkImageProvider(AppUtils.wrapWithProxy(imageUrl)),
        brightness: brightness,
      );
      return ColorSchemeDto.fromColorScheme(scheme);
    } catch (e) {
      return null;
    }
  }
}
