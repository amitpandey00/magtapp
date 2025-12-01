import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/hive_service.dart';

class SettingsState {
  final ThemeMode themeMode;
  final bool notificationsEnabled;

  SettingsState({this.themeMode = ThemeMode.system, this.notificationsEnabled = true});

  SettingsState copyWith({ThemeMode? themeMode, bool? notificationsEnabled}) {
    return SettingsState(themeMode: themeMode ?? this.themeMode, notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled);
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState()) {
    _loadSettings();
  }

  void _loadSettings() {
    final box = HiveService.getSettingsBox();
    final themeModeIndex = box.get('themeMode', defaultValue: 0) as int;
    final notificationsEnabled = box.get('notificationsEnabled', defaultValue: true) as bool;

    state = state.copyWith(themeMode: ThemeMode.values[themeModeIndex], notificationsEnabled: notificationsEnabled);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final box = HiveService.getSettingsBox();
    await box.put('themeMode', mode.index);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> toggleTheme() async {
    final newMode = state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final box = HiveService.getSettingsBox();
    await box.put('notificationsEnabled', enabled);
    state = state.copyWith(notificationsEnabled: enabled);
  }

  Future<void> clearAllCache() async {
    await HiveService.clearAll();
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
