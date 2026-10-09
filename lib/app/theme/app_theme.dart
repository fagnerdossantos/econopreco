import 'package:material_ui/material_ui.dart';

import 'app_fonts.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Seed/brand color for the app's Material 3 [ColorScheme].
const _seedColor = Color(0xFF16A34A);

/// Central ThemeData factory for the app.
abstract final class AppTheme {
  //
  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final ColorScheme colors = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      fontFamily: AppFonts.inter,
      textTheme: buildAppTextTheme(brightness: brightness),
      extensions: <ThemeExtension<dynamic>>[AppSpacing.standard()],
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
