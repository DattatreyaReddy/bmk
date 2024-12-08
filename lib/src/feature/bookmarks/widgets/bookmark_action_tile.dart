import 'package:flutter/material.dart';

import '../../../commons/utils/extensions/custom_extensions.dart';

class BookmarkActionTile extends StatelessWidget {
  const BookmarkActionTile({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.onTap,
    this.roundTop = false,
    this.roundBottom = false,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool roundTop;
  final bool roundBottom;

  @override
  Widget build(context) {
    BorderRadius radius = BorderRadius.circular(6);
    if (roundTop) {
      radius += BorderRadius.vertical(top: Radius.circular(6));
    }
    if (roundBottom) {
      radius += BorderRadius.vertical(bottom: Radius.circular(6));
    }
    return Card(
      margin: EdgeInsets.symmetric(vertical: 2),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
      ),
      child: ListTile(
        dense: true,
        leading: icon != null ? Icon(icon, size: 20) : null,
        title: Text(title),
        subtitle: subtitle.isNotBlank ? Text(subtitle!) : null,
        onTap: onTap,
      ),
    );
  }
}
