import 'package:flutter/material.dart';

/// Fanus marka renkleri.
abstract final class FanusColors {
  /// Fanusun içindeki dinginlik: koyu yeşil-turkuaz.
  static const Color seed = Color(0xFF0F766E);
}

/// Uygulama genelinde kullanılan Material 3 temaları.
abstract final class FanusTheme {
  static ThemeData light() => _base(Brightness.light);

  static ThemeData dark() => _base(Brightness.dark);

  static ThemeData _base(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: FanusColors.seed,
      brightness: brightness,
    );
    return ThemeData(
      colorScheme: scheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        centerTitle: true,
      ),
      inputDecorationTheme:
          const InputDecorationTheme(border: OutlineInputBorder()),
      snackBarTheme:
          const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    );
  }
}
