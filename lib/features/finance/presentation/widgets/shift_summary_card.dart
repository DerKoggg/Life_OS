import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/shift_controller.dart';
import '../../../../core/ui/app_icon.dart';

class ShiftSummaryCard extends ConsumerStatefulWidget {
  const ShiftSummaryCard({super.key});

  @override
  ConsumerState<ShiftSummaryCard> createState() => _ShiftSummaryCardState();
}

class _ShiftSummaryCardState extends ConsumerState<ShiftSummaryCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final shifts = ref.watch(shiftProvider);

    final total = shifts.fold<double>(0, (sum, s) => sum + s.amount);

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutBack,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _expanded
                ? const [
                    Color(0xFF1B2A4A), // чуть светлее синий
                    Color(0xFF14203A), // глубина
                  ]
                : const [
                    Color(0xFF0F1626), // очень тёмный синий
                    Color(0xFF0B1220), // почти чёрный
                  ],
          ),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(total, shifts.length),
            const SizedBox(height: 12),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: _ShiftList(),
              crossFadeState: _expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(double total, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: const [
            AppIcon(asset: 'assets/icons/shifts_done.png', size: 22),
            SizedBox(width: 10),
            Text(
              'Пройденные смены',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${total.toStringAsFixed(0)} ₽',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            Text(
              '$count смен',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ],
    );
  }
}

class _ShiftList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shifts = ref.watch(shiftProvider);

    if (shifts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 12),
        child: Text('Смен пока нет', style: TextStyle(color: Colors.white54)),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: shifts.length,
      itemBuilder: (context, i) {
        final shift = shifts[i];

        return Dismissible(
          key: ValueKey('${shift.date}-${shift.amount}-$i'),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: Colors.redAccent.withOpacity(0.8),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) {
            ref.read(shiftProvider.notifier).removeShift(i);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const AppIcon(asset: 'assets/icons/calendar.png', size: 14),
                    const SizedBox(width: 6),
                    Text(
                      '${shift.date.day}.${shift.date.month}.${shift.date.year}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),

                Text(
                  '${shift.amount.toStringAsFixed(0)} ₽',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
