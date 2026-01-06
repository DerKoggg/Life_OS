import 'package:flutter/material.dart';
import 'dart:ui';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A22).withOpacity(0.75),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _BarItem(
                  icon: 'assets/icons/home.png',
                  activeIcon: 'assets/icons/home_active.png',
                  label: 'Сегодня',
                  isActive: currentIndex == 0,
                  onTap: () => onTap(0),
                ),
                _BarItem(
                  icon: 'assets/icons/briefcase.png',
                  activeIcon: 'assets/icons/briefcase_active.png',
                  label: 'Смены',
                  isActive: currentIndex == 1,
                  onTap: () => onTap(1),
                ),
                _BarItem(
                  icon: 'assets/icons/chart.png',
                  activeIcon: 'assets/icons/chart_active.png',
                  label: 'Статистика',
                  isActive: currentIndex == 2,
                  onTap: () => onTap(2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  final String icon;
  final String activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _BarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF6C8EFF).withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: Image.asset(
                isActive ? activeIcon : icon,
                key: ValueKey(isActive),
                width: 22,
                height: 22,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isActive ? 1 : 0,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6C8EFF),
                ),
              ),
            ),

            const SizedBox(height: 6),

            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: isActive ? 6 : 0,
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xff6c8eff),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
