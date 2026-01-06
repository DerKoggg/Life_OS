import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/shift.dart';
import 'shift_storage.dart';
import 'finance_controller.dart';

final shiftProvider = StateNotifierProvider<ShiftController, List<Shift>>(
  (ref) => ShiftController(ref),
);

class ShiftController extends StateNotifier<List<Shift>> {
  ShiftController(this.ref) : super([]) {
    _loadShifts();
  }

  final Ref ref;

  void _loadShifts() {
    final loaded = ShiftStorage.loadShifts();
    state = loaded;
  }

  void addShift(Shift shift) {
    final updated = [...state, shift];
    state = updated;
    ShiftStorage.saveShifts(updated);

    // 💡 ВАЖНО: сразу добавляем в pendingIncome
    ref
        .read(financeProvider.notifier)
        .setPendingIncome(
          ref.read(financeProvider).pendingIncome + shift.amount,
        );
  }

  void removeShift(int index) {
    final shift = state[index];

    // уменьшаем pendingIncome
    ref.read(financeProvider.notifier).removePendingIncome(shift.amount);

    final updated = [...state]..removeAt(index);
    state = updated;

    ShiftStorage.saveShifts(updated);
  }
}
