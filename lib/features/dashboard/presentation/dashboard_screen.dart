import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../finance/application/finance_controller.dart';
import '../../../core/time/salary_period.dart';
import '../../../core/ui/app_icon.dart';
import '../../../core/ui/animated_number.dart';
import '../../../core/ui/fade_slide.dart';
import '../../../data/local/finance_storage.dart';

// Главный экран "Сегодня"
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final received = ref
          .read(financeProvider.notifier)
          .tryReceiveSalaryIfNeeded();

      if (received != null && received > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 96),
            backgroundColor: const Color(0xFF1A1A22),
            content: Row(
              children: [
                const Icon(Icons.payments_rounded, color: Color(0xFF6C8EFF)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Зарплата получена  +${received.toStringAsFixed(0)} ₽',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });

    final lastSalaryDay = FinanceStorage.loadInt('lastSalaryDay', -1);

    final today = DateTime.now().day;

    final showSalaryBanner =
        (today == 15 || today == 30) && lastSalaryDay == today;
    final finance = ref.watch(financeProvider);
    final period = SalaryPeriod();
    final daysLeft = period.daysUntilSalary;
    final dailyLimit = daysLeft > 0
        ? finance.freeMoneyNow / daysLeft
        : finance.freeMoneyNow;
    String dayMood;
    Color dayMoodColor;

    if (dailyLimit < 500) {
      dayMood = 'День требует аккуратности';
      dayMoodColor = Colors.orangeAccent;
    } else if (dailyLimit < 1500) {
      dayMood = 'Хороший спокойный день';
      dayMoodColor = Colors.lightGreenAccent;
    } else {
      dayMood = 'День с запасом свободы';
      dayMoodColor = const Color(0xFF6C8EFF);
    }

    final salaryProgress = daysLeft <= 0
        ? 1.0
        : 1 - (daysLeft / period.totalDaysInPeriod);

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  16,
                  20,
                  16 + MediaQuery.of(context).padding.bottom + 72,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ----------------------------
                      // Заголовок
                      // ----------------------------
                      Row(
                        children: [
                          const AppIcon(
                            asset: 'assets/icons/calendar.png',
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Сегодня',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      Text(
                        'Твой день в цифрах',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ----------------------------
                      // Главная карточка
                      // ----------------------------
                      FadeSlide(
                        child: _PrimaryCard(
                          title: 'Можно потратить сейчас',
                          value: finance.freeMoneyNow,
                        ),
                      ),

                      const SizedBox(height: 12),

                      if (showSalaryBanner)
                        FadeSlide(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6C8EFF).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: const Color(
                                  0xFF6C8EFF,
                                ).withOpacity(0.35),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  '💰',
                                  style: TextStyle(fontSize: 18),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Зарплата получена',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF6C8EFF),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      const SizedBox(height: 12),

                      FadeSlide(
                        child: _SecondaryCard(
                          title: 'Можно потратить в день',
                          value: dailyLimit,
                          iconAsset: 'assets/icons/calendar.png',
                          suffix: '₽/день',
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        'До зарплаты осталось $daysLeft дней',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),

                      const SizedBox(height: 12),

                      FadeSlide(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LinearProgressIndicator(
                              value: salaryProgress.clamp(0, 1),
                              minHeight: 6,
                              backgroundColor: Colors.white.withOpacity(0.08),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF6C8EFF),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Пройдено ${(salaryProgress * 100).toStringAsFixed(0)}% периода',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.4),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      FadeSlide(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: dayMoodColor.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: dayMoodColor.withOpacity(0.25),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: dayMoodColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  dayMood,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: dayMoodColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ----------------------------
                      // Нижние карточки
                      // ----------------------------
                      FadeSlide(
                        child: Row(
                          children: [
                            Expanded(
                              child: _SecondaryCard(
                                title: 'Деньги сейчас',
                                value: finance.currentBalance,
                                iconAsset: 'assets/icons/coins.png',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _SecondaryCard(
                                title: 'После зарплаты',
                                value: finance.balanceAfterSalary,
                                iconAsset: 'assets/icons/chart.png',
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // ----------------------------
                      // Футер
                      // ----------------------------
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'Сегодня • Life OS',
                              style: TextStyle(
                                fontSize: 11,
                                letterSpacing: 0.6,
                                color: Colors.white.withOpacity(0.25),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'День имеет значение',
                              style: TextStyle(
                                fontSize: 10,
                                letterSpacing: 0.4,
                                color: Colors.white.withOpacity(0.18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
    // Кнопка редактирования
  }
}

//
// ----------------------------
// ГЛАВНАЯ карточка (акцент)
// ----------------------------
class _PrimaryCard extends StatelessWidget {
  final String title;
  final double value;

  const _PrimaryCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF1E1E28),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AppIcon(asset: 'assets/icons/wallet.png', size: 28),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          AnimatedNumber(
            value: value,
            suffix: ' ₽',
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

//
// ----------------------------
// ВТОРИЧНАЯ карточка
// ----------------------------
class _SecondaryCard extends StatelessWidget {
  final String title;
  final double value;
  final String iconAsset;
  final String suffix; // суффикс единицы измерения

  const _SecondaryCard({
    required this.title,
    required this.value,
    required this.iconAsset,
    this.suffix = '₽', // значение по умолчанию
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 96),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xff1a1a22),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppIcon(asset: iconAsset, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            AnimatedNumber(
              value: value,
              suffix: ' $suffix',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
