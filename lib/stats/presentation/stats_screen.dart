import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/finance/application/shift_controller.dart';
import '../../features/finance/application/planned_shift_controller.dart';
import 'widgets/income_chart_card.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shifts = ref.watch(shiftProvider);
    final planned = ref.watch(plannedShiftProvider);

    final now = DateTime.now();
    final startDay = now.day <= 15 ? 1 : 16;
    final endDay = now.day <= 15 ? 15 : 30;

    bool inPeriod(DateTime d) =>
        d.year == now.year &&
        d.month == now.month &&
        d.day >= startDay &&
        d.day <= endDay;

    final factTotal = shifts
        .where((s) => inPeriod(s.date))
        .fold<double>(0, (sum, s) => sum + s.amount);

    final planTotal = planned
        .where((s) => inPeriod(s.date))
        .fold<double>(0, (sum, s) => sum + s.expectedAmount);

    final diff = factTotal - planTotal;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(
                'Статистика',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ─── ГРАФИК ─────────────────────────────
            const IncomeChartCard(),

            const SizedBox(height: 16),

            // ─── ФАКТ / ПЛАН / РАЗНИЦА ──────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatValue(
                    label: 'Факт',
                    value: '${factTotal.toStringAsFixed(0)} ₽',
                  ),
                  _StatValue(
                    label: 'План',
                    value: '${planTotal.toStringAsFixed(0)} ₽',
                  ),
                  _StatValue(
                    label: 'Разница',
                    value:
                        '${diff >= 0 ? '+' : ''}${diff.toStringAsFixed(0)} ₽',
                    color: diff >= 0 ? Colors.greenAccent : Colors.redAccent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatValue extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _StatValue({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color ?? Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white54),
        ),
      ],
    );
  }
}
