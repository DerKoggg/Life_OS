import 'dart:convert';
import 'package:hive/hive.dart';
import '../domain/shift.dart';
import 'package:flutter/foundation.dart';

class ShiftStorage {
  static const _key = 'shifts';

  static Box get _box => Hive.box('finance');

  static List<Shift> loadShifts() {
    final raw = _box.get(_key);
    if (raw == null) return [];

    try {
      final List decoded = jsonDecode(raw);
      return decoded.map((e) => Shift.fromJson(e)).toList();
    } catch (e, s) {
      debugPrint('❌ ShiftStorage load error: $e');
      debugPrintStack(stackTrace: s);
      return [];
    }
  }

  static void saveShifts(List<Shift> shifts) {
    final encoded = jsonEncode(shifts.map((e) => e.toJson()).toList());
    _box.put(_key, encoded);
  }
}
