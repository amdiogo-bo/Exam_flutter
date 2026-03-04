import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider pour gérer le thème light/dark de l'application
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

/// Notifier pour basculer entre light et dark mode
extension ThemeModeNotifier on WidgetRef {
  void toggleTheme() {
    final current = read(themeModeProvider);
    final next = current == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    read(themeModeProvider.notifier).state = next;
  }

  bool get isDarkMode => read(themeModeProvider) == ThemeMode.dark;
}
