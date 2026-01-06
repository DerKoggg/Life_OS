import 'dart:convert';
import 'package:hive/hive.dart';

import '../domain/planned_shift.dart';

class PlannedShiftStorage {
  static const _key = 'planned_shifts';

  static List<PlannedShift> load() {
    final box = Hive.box('finance');
    final raw = box.get(_key);

    if (raw == null) return [];

    try {
      final List decoded = jsonDecode(raw);
      return decoded.map((e) => PlannedShift.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static void save(List<PlannedShift> shifts) {
    final box = Hive.box('finance');
    final encoded = jsonEncode(shifts.map((e) => e.toJson()).toList());
    box.put(_key, encoded);
  }
}
