import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/planned_shift_controller.dart';
import '../../domain/planned_shift.dart';

class ShiftPlannerCard extends ConsumerWidget {
  const ShiftPlannerCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planned = ref.watch(plannedShiftProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F1626), Color(0xFF0B1220)],
        ),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Планировщик смен',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            if (planned.isEmpty)
              const Text(
                'Запланированных смен нет',
                style: TextStyle(color: Colors.white54),
              )
            else
              ..._buildList(planned, ref),

            const SizedBox(height: 12),
            _AddPlannedShiftButton(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildList(List<PlannedShift> planned, WidgetRef ref) {
    return List.generate(planned.length, (i) {
      final shift = planned[i];
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${shift.date.day}.${shift.date.month}.${shift.date.year}',
              style: const TextStyle(color: Colors.white70),
            ),
            Row(
              children: [
                Text(
                  '${shift.expectedAmount.toStringAsFixed(0)} ₽',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    ref
                        .read(plannedShiftProvider.notifier)
                        .removePlannedShift(i);
                  },
                  child: const Icon(
                    Icons.close,
                    size: 18,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class _AddPlannedShiftButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () async {
        final now = DateTime.now().add(const Duration(days: 1));

        ref
            .read(plannedShiftProvider.notifier)
            .addPlannedShift(PlannedShift(date: now, expectedAmount: 1500));
      },
      child: const Text(
        '+ Запланировать смену',
        style: TextStyle(color: Colors.white70),
      ),
    );
  }
}
