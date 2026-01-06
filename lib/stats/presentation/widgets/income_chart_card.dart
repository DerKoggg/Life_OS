import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/finance/application/shift_controller.dart';
import '../../../features/finance/application/planned_shift_controller.dart';
import '../../application/income_chart_data.dart';
import 'income_line_chart.dart';

class IncomeChartCard extends ConsumerWidget {
  const IncomeChartCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shifts = ref.watch(shiftProvider);
    final planned = ref.watch(plannedShiftProvider);

    final now = DateTime.now();
    final startDay = now.day <= 15 ? 1 : 16;
    final endDay = now.day <= 15 ? 15 : 30;

    final factData = IncomeChartData.buildFact(shifts, startDay, endDay);
    final planData = IncomeChartData.buildPlan(planned, startDay, endDay);

    return Container(
      height: 220,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F1626), Color(0xFF0B1220)],
        ),
      ),
      child: IncomeLineChart(
        key: UniqueKey(), // 👈 ВАЖНО
        fact: factData,
        plan: planData,
      ),
    );
  }
}
