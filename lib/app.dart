import 'package:flutter/material.dart';
import 'package:life_os/features/navigation/root_screen.dart';

import 'core/theme/app_theme.dart';

// Корневой виджет приложения
class LifeOSApp extends StatelessWidget {
  const LifeOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Life OS',
      theme: AppTheme.dark(), // <-- теперь существует
      home: const RootScreen(),
    );
  }
}
