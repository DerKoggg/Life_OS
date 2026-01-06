import 'package:flutter/material.dart';

class FadeSlide extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final double offsetY;

  const FadeSlide({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.offsetY = 12,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      curve: Curves.easeOut,
      builder: (context, value, _) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * offsetY),
            child: child,
          ),
        );
      },
    );
  }
}
