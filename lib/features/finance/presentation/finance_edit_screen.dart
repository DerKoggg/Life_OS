import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/finance_controller.dart';

// Экран редактирования финансов
class FinanceEditScreen extends ConsumerStatefulWidget {
  const FinanceEditScreen({super.key});

  @override
  ConsumerState<FinanceEditScreen> createState() => _FinanceEditScreenState();
}

class _FinanceEditScreenState extends ConsumerState<FinanceEditScreen> {
  // Контроллеры для полей ввода
  final _balanceController = TextEditingController();
  final _pendingIncomeController = TextEditingController();
  final _savingsController = TextEditingController();
  final _mandatoryController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final finance = ref.read(financeProvider);

    // Деньги сейчас
    _balanceController.text = finance.currentBalance.toStringAsFixed(0);

    // Деньги потом (будущая зарплата)
    _pendingIncomeController.text = finance.pendingIncome.toStringAsFixed(0);

    // Накопления
    _savingsController.text = finance.savings.toStringAsFixed(0);

    // Обязательные траты
    _mandatoryController.text = finance.mandatory.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Финансы')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _MoneyField(label: 'Деньги сейчас', controller: _balanceController),
            const SizedBox(height: 16),

            _MoneyField(
              label: 'Будущая зарплата',
              controller: _pendingIncomeController,
            ),
            const SizedBox(height: 16),

            _MoneyField(label: 'Накопления', controller: _savingsController),
            const SizedBox(height: 16),

            _MoneyField(
              label: 'Обязательные траты',
              controller: _mandatoryController,
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: () {
                final balance = double.tryParse(_balanceController.text) ?? 0;
                final pending =
                    double.tryParse(_pendingIncomeController.text) ?? 0;
                final savings = double.tryParse(_savingsController.text) ?? 0;
                final mandatory =
                    double.tryParse(_mandatoryController.text) ?? 0;

                final notifier = ref.read(financeProvider.notifier);

                notifier.setCurrentBalance(balance);

                // Мы ПЕРЕЗАПИСЫВАЕМ pendingIncome,
                // а не прибавляем
                notifier.setPendingIncome(pending);

                notifier.setSavings(savings);
                notifier.setMandatory(mandatory);

                Navigator.of(context).pop();
              },
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------
// Поле ввода денег
// ----------------------------
class _MoneyField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _MoneyField({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
