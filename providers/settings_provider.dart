import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final settingsProvider = Provider<SettingsRepository>((ref) => SettingsRepository());

class SettingsRepository {
  static const _boxName = 'settings';
  static const _keyExtras = 'extras_unlocked';

  Box<dynamic>? _box;

  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox(_boxName);
    } else {
      _box = Hive.box(_boxName);
    }
  }

  bool get extrasUnlocked => _box?.get(_keyExtras, defaultValue: false) as bool;

  Future<void> setExtrasUnlocked(bool value) async {
    await _box?.put(_keyExtras, value);
  }
}
