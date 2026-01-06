import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/planned_shift_controller.dart';
import '../../domain/planned_shift.dart';
import '../../../../core/ui/app_icon.dart';

class ShiftPlannerSummaryCard extends ConsumerStatefulWidget {
  const ShiftPlannerSummaryCard({super.key});

  @override
  ConsumerState<ShiftPlannerSummaryCard> createState() =>
      _ShiftPlannerSummaryCardState();
}

class _ShiftPlannerSummaryCardState
    extends ConsumerState<ShiftPlannerSummaryCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final planned = ref.watch(plannedShiftProvider);

    final total = planned.fold<double>(0, (sum, s) => sum + s.expectedAmount);

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
                ? const [Color(0xFF1B2A4A), Color(0xFF14203A)]
                : const [Color(0xFF0F1626), Color(0xFF0B1220)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(planned.length, total),
            const SizedBox(height: 12),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: _expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox.shrink(),
              secondChild: const _PlannerList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(int count, double total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: const [
            AppIcon(asset: 'assets/icons/shifts_planned.png', size: 22),
            SizedBox(width: 10),
            Text(
              'Планируемые смены',
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
              style: const TextStyle(color: Colors.white),
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

class _PlannerList extends ConsumerWidget {
  const _PlannerList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planned = ref.watch(plannedShiftProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (planned.isEmpty)
          const Text(
            'Запланированных смен нет',
            style: TextStyle(color: Colors.white54),
          )
        else
          ...List.generate(planned.length, (i) {
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
          }),
        const SizedBox(height: 12),
        const _AddPlannedShiftForm(),
      ],
    );
  }
}

class _AddPlannedShiftForm extends ConsumerStatefulWidget {
  const _AddPlannedShiftForm();

  @override
  ConsumerState<_AddPlannedShiftForm> createState() =>
      _AddPlannedShiftFormState();
}

class _AddPlannedShiftFormState extends ConsumerState<_AddPlannedShiftForm> {
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));

  bool get _canSubmit =>
      _amountController.text.isNotEmpty &&
      double.tryParse(_amountController.text) != null;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: Colors.white12, height: 24),

        _amountField(),
        const SizedBox(height: 12),
        _datePicker(context),
        const SizedBox(height: 12),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: _canSubmit ? _submit : null,
            child: const Text(
              'Запланировать',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _amountField() {
    return TextField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: const AppIcon(asset: 'assets/icons/money.png', size: 18),
        hintText: 'Сумма за смену',
        hintStyle: const TextStyle(color: Colors.white54),
        border: InputBorder.none,
      ),
      onChanged: (_) => setState(() {}),
    );
  }

  Widget _datePicker(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );

        if (date != null) {
          setState(() => _selectedDate = date);
        }
      },
      child: Text(
        'Дата: ${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}',
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }

  void _submit() {
    final amount = double.parse(_amountController.text);

    ref
        .read(plannedShiftProvider.notifier)
        .addPlannedShift(
          PlannedShift(date: _selectedDate, expectedAmount: amount),
        );

    _amountController.clear();
    setState(() {
      _selectedDate = DateTime.now().add(const Duration(days: 1));
    });
  }
}
