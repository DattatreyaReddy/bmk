import 'package:flutter/material.dart';

class CenterCircularProgressIndicator extends StatelessWidget {
  const CenterCircularProgressIndicator({super.key, this.color, this.value});

  final Color? color;
  final double? value;
  @override
  Widget build(BuildContext context) =>
      Center(child: CircularProgressIndicator(color: color, value: value));
}

class MiniCircularProgressIndicator extends StatelessWidget {
  const MiniCircularProgressIndicator({
    super.key,
    this.color,
    this.value,
    this.padding,
  });
  final Color? color;
  final double? value;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) => Padding(
        padding: padding ?? EdgeInsets.all(8),
        child: SizedBox.square(
          dimension: 16,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: color,
            value: value,
          ),
        ),
      );
}
