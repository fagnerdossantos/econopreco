/// Single source of truth for bundled font family names.
///
/// The `family` values here must match the `family:` entries declared under
/// `flutter: fonts:` in `pubspec.yaml`. Fonts are bundled local `.ttf` assets,
/// resolved offline — no runtime fetching.
abstract final class AppFonts {
  static const String inter = 'Inter';
}
