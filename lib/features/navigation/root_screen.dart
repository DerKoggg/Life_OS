import 'package:flutter/material.dart';
import 'package:life_os/features/finance/presentation/finance_edit_screen.dart';
import 'package:life_os/features/finance/presentation/shift_screen.dart';

// Подключаем экраны
import '../dashboard/presentation/dashboard_screen.dart';
import '../../core/ui/custom_bottom_bar.dart';
import '../../stats/presentation/stats_screen.dart';

// Корневой экран с нижней навигацией
class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  // Текущий индекс нижнего бара
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // ❗ ВАЖНО: список экранов ДОЛЖЕН быть здесь,
    // потому что он зависит от _currentIndex
    final screens = [
      const DashboardScreen(),
      const ShiftScreen(),

      // ✅ TickerMode ТОЛЬКО для статистики
      TickerMode(
        enabled: _currentIndex == 2, // индекс вкладки "Статистика"
        child: const StatsScreen(),
      ),

      const Placeholder(),
    ];

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          IndexedStack(index: _currentIndex, children: screens),

          // FAB только на экране "Сегодня"
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            right: 20,
            bottom: _currentIndex == 0 ? 88 : -100,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _currentIndex == 0 ? 1 : 0,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const FinanceEditScreen(),
                    ),
                  );
                },
                child: const Icon(Icons.edit),
              ),
            ),
          ),

          // Нижний бар
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
