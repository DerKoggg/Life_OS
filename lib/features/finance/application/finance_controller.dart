import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/finance_storage.dart';
import '../domain/finance_models.dart';

// Контроллер управляет финансовой логикой
class FinanceController extends StateNotifier<FinanceState> {
  FinanceController()
    : super(
        FinanceState(
          // Загружаем сохранённые данные
          currentBalance: FinanceStorage.loadDouble('currentBalance', 0),
          pendingIncome: FinanceStorage.loadDouble('pendingIncome', 0),
          savings: FinanceStorage.loadDouble('savings', 0),
          mandatory: FinanceStorage.loadDouble('mandatory', 0),
        ),
      );

  // ---------- ТЕКУЩИЕ ДЕНЬГИ ----------

  // Установить текущий баланс (деньги сейчас)
  void setCurrentBalance(double value) {
    FinanceStorage.saveDouble('currentBalance', value);
    state = state.copyWith(currentBalance: value);
  }

  // ---------- БУДУЩАЯ ЗАРПЛАТА ----------

  double? tryReceiveSalaryIfNeeded() {
    final today = DateTime.now().day;

    final isSalaryDay = today == 15 || today == 30;
    if (!isSalaryDay) return null;
    if (state.pendingIncome <= 0) return null;

    final receivedAmount = state.pendingIncome;
    final newCurrentBalance = state.currentBalance + receivedAmount;

    state = state.copyWith(currentBalance: newCurrentBalance, pendingIncome: 0);

    FinanceStorage.saveDouble('currentBalance', newCurrentBalance);
    FinanceStorage.saveDouble('pendingIncome', 0);

    // 👈 ВАЖНО: возвращаем сумму
    return receivedAmount;
  }

  // Добавить доход в ожидании (смена)
  void addPendingIncome(double value) {
    final newValue = state.pendingIncome + value;
    FinanceStorage.saveDouble('pendingIncome', newValue);
    state = state.copyWith(pendingIncome: newValue);
  }

  // Получить зарплату (15 / 30)
  void receiveSalary() {
    final newBalance = state.currentBalance + state.pendingIncome;

    FinanceStorage.saveDouble('currentBalance', newBalance);
    FinanceStorage.saveDouble('pendingIncome', 0);

    state = state.copyWith(currentBalance: newBalance, pendingIncome: 0);
  }

  // ---------- ПЛАНИРОВАНИЕ ----------

  void setSavings(double value) {
    FinanceStorage.saveDouble('savings', value);
    state = state.copyWith(savings: value);
  }

  void setMandatory(double value) {
    FinanceStorage.saveDouble('mandatory', value);
    state = state.copyWith(mandatory: value);
  }

  // Перезаписать будущий доход (используется экраном редактирования)
  void setPendingIncome(double value) {
    FinanceStorage.saveDouble('pendingIncome', value);
    state = state.copyWith(pendingIncome: value);
  }

  void removePendingIncome(double amount) {
    final double updated = (state.pendingIncome - amount)
        .clamp(0, double.infinity)
        .toDouble();

    state = state.copyWith(pendingIncome: updated);

    FinanceStorage.saveDouble('pendingIncome', updated);
  }
}

// Riverpod provider
final financeProvider = StateNotifierProvider<FinanceController, FinanceState>(
  (ref) => FinanceController(),
);
