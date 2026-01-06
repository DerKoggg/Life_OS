// Логика зарплатного периода (15 / 30)
class SalaryPeriod {
  int get totalDaysInPeriod {
    final now = DateTime.now();
    final startDay = now.day <= 15 ? 1 : 16;
    final endDay = now.day <= 15 ? 15 : 30;
    return endDay - startDay + 1;
  }

  // Сегодняшняя дата
  final DateTime today;

  SalaryPeriod({DateTime? now}) : today = now ?? DateTime.now();

  // Ближайшая дата зарплаты
  DateTime get nextSalaryDate {
    if (today.day <= 15) {
      return DateTime(today.year, today.month, 15);
    } else {
      return DateTime(today.year, today.month, 30);
    }
  }

  // Сколько дней до зарплаты
  int get daysUntilSalary {
    final diff = nextSalaryDate.difference(today).inDays;
    return diff < 0 ? 0 : diff;
  }
}
