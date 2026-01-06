import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/planned_shift.dart';
import 'planned_shift_storage.dart';

final plannedShiftProvider =
    StateNotifierProvider<PlannedShiftController, List<PlannedShift>>(
      (ref) => PlannedShiftController(),
    );

class PlannedShiftController extends StateNotifier<List<PlannedShift>> {
  PlannedShiftController() : super([]) {
    _load();
  }

  void _load() {
    state = PlannedShiftStorage.load();
  }

  void addPlannedShift(PlannedShift shift) {
    final updated = [...state, shift];
    state = updated;
    PlannedShiftStorage.save(updated);
  }

  void removePlannedShift(int index) {
    final updated = [...state]..removeAt(index);
    state = updated;
    PlannedShiftStorage.save(updated);
  }
}
