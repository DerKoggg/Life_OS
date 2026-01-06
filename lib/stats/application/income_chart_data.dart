import '../../features/finance/domain/shift.dart';
import '../../features/finance/domain/planned_shift.dart';

class IncomeChartPoint {
  final int day;
  final double value;

  IncomeChartPoint(this.day, this.value);
}

class IncomeChartData {
  static List<IncomeChartPoint> buildFact(
    List<Shift> shifts,
    int startDay,
    int endDay,
  ) {
    final map = <int, double>{};

    for (final shift in shifts) {
      final d = shift.date.day;
      if (d >= startDay && d <= endDay) {
        map[d] = (map[d] ?? 0) + shift.amount;
      }
    }

    double sum = 0;
    final result = <IncomeChartPoint>[];

    for (int day = startDay; day <= endDay; day++) {
      sum += map[day] ?? 0;
      result.add(IncomeChartPoint(day, sum));
    }

    return result;
  }

  static List<IncomeChartPoint> buildPlan(
    List<PlannedShift> shifts,
    int startDay,
    int endDay,
  ) {
    final map = <int, double>{};

    for (final shift in shifts) {
      final d = shift.date.day;
      if (d >= startDay && d <= endDay) {
        map[d] = (map[d] ?? 0) + shift.expectedAmount;
      }
    }

    double sum = 0;
    final result = <IncomeChartPoint>[];

    for (int day = startDay; day <= endDay; day++) {
      sum += map[day] ?? 0;
      result.add(IncomeChartPoint(day, sum));
    }

    return result;
  }
}
