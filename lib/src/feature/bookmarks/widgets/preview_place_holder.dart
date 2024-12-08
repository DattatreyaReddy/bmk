import 'package:flutter/material.dart';

import '../../../commons/utils/dto/color_scheme_dto.dart';
import '../../../commons/utils/extensions/custom_extensions.dart';

class PreviewPlaceHolder extends StatelessWidget {
  const PreviewPlaceHolder({
    super.key,
    required this.label,
    this.lightColorScheme,
    this.darkColorScheme,
    this.colorScheme,
  });

  final String label;
  final ColorSchemeDto? lightColorScheme;
  final ColorSchemeDto? darkColorScheme;
  final ColorSchemeDto? colorScheme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 128,
      child: Center(
        child: Text(
          label,
          style: context.textTheme.titleMedium?.copyWith(
            color: ((context.isDarkMode ? darkColorScheme : lightColorScheme) ??
                    colorScheme)
                ?.onPrimary,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
