part of '../loovi_tokens.dart';

/// Builds a Material [ThemeData] wired to the DS tokens.
///
/// The app reads tokens with `LooviTokens.of(context)`; the Material defaults
/// below only make plain Material widgets (Text, Scaffold, ink) land on DS values.
abstract final class LooviTheme {
  /// Light theme for [mode]. Dark mode was removed from the DS.
  static ThemeData light({LooviProductMode mode = LooviProductMode.appCliente}) {
    final t = LooviTokens.forMode(mode);
    final ty = t.typography;
    final textTheme = TextTheme(
      displayLarge: ty.displayLargeRegular,
      headlineLarge: ty.headingH1Medium,
      headlineMedium: ty.headingH2Medium,
      headlineSmall: ty.headingH3Medium,
      titleLarge: ty.headingH3Medium,
      titleMedium: ty.bodyLargeMedium,
      titleSmall: ty.bodyMediumMedium,
      bodyLarge: ty.bodyLargeRegular,
      bodyMedium: ty.bodyMediumRegular,
      bodySmall: ty.bodySmallRegular,
      labelLarge: ty.bodyMediumMedium,
      labelMedium: ty.bodySmallMedium,
      labelSmall: ty.captionLargeMedium,
    ).apply(bodyColor: t.text.primary, displayColor: t.text.primary);

    final scheme = ColorScheme.light(
      primary: t.color.actionsPrimary,
      onPrimary: t.text.onColor,
      secondary: t.color.actionsSecondary,
      onSecondary: t.text.primary,
      error: t.feedback.danger,
      onError: t.text.onColor,
      surface: t.color.backgroundSurface0,
      onSurface: t.text.primary,
      onSurfaceVariant: t.text.secondary,
      outline: t.color.border1,
      outlineVariant: t.color.border2,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: t.color.backgroundSurface0,
      fontFamily: LooviTypography.fontFamily,
      package: LooviTypography.fontPackage,
      textTheme: textTheme,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      splashFactory: NoSplash.splashFactory,
      extensions: <ThemeExtension<dynamic>>[t],
    );
  }
}
