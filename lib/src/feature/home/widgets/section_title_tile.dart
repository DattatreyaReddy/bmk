import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SectionTitleTile extends StatelessWidget {
  const SectionTitleTile({
    super.key,
    required this.onTap,
    required this.title,
  });
  final VoidCallback onTap;
  final String title;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Gap(8),
          Expanded(child: Text(title, overflow: TextOverflow.ellipsis)),
          Card.filled(
            clipBehavior: Clip.hardEdge,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(Icons.keyboard_arrow_right_rounded),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
