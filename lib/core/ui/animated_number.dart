import 'package:flutter/material.dart';

class AnimatedNumber extends StatelessWidget {
  final double value;
  final TextStyle style;
  final Duration duration;
  final String suffix;

  const AnimatedNumber({
    super.key,
    required this.value,
    required this.style,
    this.duration = const Duration(milliseconds: 600),
    this.suffix = '',
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, _) {
        return Text('${animatedValue.toStringAsFixed(0)}$suffix', style: style);
      },
    );
  }
}
