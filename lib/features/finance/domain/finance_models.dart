// Финансовое состояние приложения
class FinanceState {
  // Деньги, которые есть ПРЯМО СЕЙЧАС
  final double currentBalance;

  // Деньги, которые будут получены в ЗП (15 / 30)
  final double pendingIncome;

  // Часть текущих денег, которую мы откладываем
  final double savings;

  // Обязательные траты будущего периода
  final double mandatory;

  const FinanceState({
    required this.currentBalance,
    required this.pendingIncome,
    required this.savings,
    required this.mandatory,
  });

  // Деньги, которые реально можно тратить СЕЙЧАС
  double get freeMoneyNow {
    final value = currentBalance - savings;
    return value < 0 ? 0 : value;
  }

  // Деньги, которые будут доступны ПОСЛЕ зарплаты
  double get balanceAfterSalary {
    return currentBalance + pendingIncome;
  }

  FinanceState copyWith({
    double? currentBalance,
    double? pendingIncome,
    double? savings,
    double? mandatory,
  }) {
    return FinanceState(
      currentBalance: currentBalance ?? this.currentBalance,
      pendingIncome: pendingIncome ?? this.pendingIncome,
      savings: savings ?? this.savings,
      mandatory: mandatory ?? this.mandatory,
    );
  }
}
