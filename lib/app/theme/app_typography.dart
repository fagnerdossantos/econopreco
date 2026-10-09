import 'package:material_ui/material_ui.dart';

import 'app_fonts.dart';

/// Builds the app [TextTheme] for the given [brightness], applying the bundled
/// Inter family.
///
/// Starts from the Material 3 (material2021) role sizes so that Flutter's
/// `TextScaler` scales text predictably, then overrides weights to the bundled
/// set (400 / 500 / 600 / 700) to avoid falling back for missing weights.
TextTheme buildAppTextTheme({required Brightness brightness}) {
  //
  final typography = Typography.material2021();

  final TextTheme base = switch (brightness) {
    .dark => typography.white,
    .light => typography.black,
  };

  // Material's 2021 typography bakes fontFamily:'Roboto' into every role, and
  // TextTheme.apply doesn't reliably override it. Set the family directly on
  // each role alongside its weight so the bundled Inter always wins.
  TextStyle? role(TextStyle? source, FontWeight weight) => source?.copyWith(
    fontFamily: AppFonts.inter,
    fontFamilyFallback: const ['Inter'],
    fontWeight: weight,
  );

  return base.copyWith(
    // Large
    displayLarge: role(base.displayLarge, .w700),
    headlineLarge: role(base.headlineLarge, .w600),
    titleLarge: role(base.titleLarge, .w600),
    bodyLarge: role(base.bodyLarge, .w400),
    labelLarge: role(base.labelLarge, .w500),

    // Medium
    displayMedium: role(base.displayMedium, .w700),
    headlineMedium: role(base.headlineMedium, .w600),
    titleMedium: role(base.titleMedium, .w500),
    bodyMedium: role(base.bodyMedium, .w400),
    labelMedium: role(base.labelMedium, .w500),

    // Small
    displaySmall: role(base.displaySmall, .w600),
    headlineSmall: role(base.headlineSmall, .w600),
    titleSmall: role(base.titleSmall, .w500),
    bodySmall: role(base.bodySmall, .w400),
    labelSmall: role(base.labelSmall, .w500),
  );
}
