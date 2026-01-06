import 'package:flutter/material.dart';

// Универсальная иконка приложения
class AppIcon extends StatelessWidget {
  final String asset;
  final double size;

  const AppIcon({super.key, required this.asset, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return Image.asset(asset, width: size, height: size, fit: BoxFit.contain);
  }
}
