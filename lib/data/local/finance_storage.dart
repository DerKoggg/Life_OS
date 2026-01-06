import 'package:hive_flutter/hive_flutter.dart';

// Класс-обёртка над Hive
class FinanceStorage {
  static final _box = Hive.box('finance');

  // ------SAVE-------

  static void saveDouble(String key, double value) {
    _box.put(key, value);
  }

  static void saveInt(String key, int value) {
    _box.put(key, value);
  }

  // ------LOAD-------

  static double loadDouble(String key, double defaultValue) {
    return (_box.get(key) as double?) ?? defaultValue;
  }

  static int loadInt(String key, int defaultValue) {
    return (_box.get(key) as int?) ?? defaultValue;
  }
}
