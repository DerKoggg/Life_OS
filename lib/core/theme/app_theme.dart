import 'package:flutter/material.dart';
import 'app_colors.dart';

// Тема приложения (одна на все платформы)
class AppTheme {
  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,

      // Глобальный шрифт приложения
      fontFamily: 'Inter',

      // Цвет фона всех экранов
      scaffoldBackgroundColor: AppColors.background,

      // Material 3 (актуально и для Android, и для iOS)
      useMaterial3: true,

      // Цветовая схема
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        background: AppColors.background,
        surface: AppColors.surface,
      ),
    );
  }
}
