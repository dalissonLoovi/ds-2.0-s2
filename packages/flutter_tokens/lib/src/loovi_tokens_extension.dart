part of '../loovi_tokens.dart';

/// All DS tokens for one product mode, as a [ThemeExtension].
///
/// Foundation groups (color, text, spacing, radius, typography, effects) are the
/// same in every mode. Only [component] (the `product-theme` collection) changes.
@immutable
class LooviTokens extends ThemeExtension<LooviTokens> {
  const LooviTokens._(this.mode, this.component);

  /// Tokens for [mode]. Default = `app-cliente`.
  factory LooviTokens.forMode([LooviProductMode mode = LooviProductMode.appCliente]) =>
      switch (mode) {
        LooviProductMode.escritorioVirtual => escritorioVirtual,
        LooviProductMode.siteLoovi => siteLoovi,
        LooviProductMode.appCliente => appCliente,
      };

  /// Mode `app-cliente` (default of this package).
  static const LooviTokens appCliente =
      LooviTokens._(LooviProductMode.appCliente, LooviComponentTokens.appCliente);

  /// Mode `escritorio-virtual` (resolved only; no widgets/gallery in this stage).
  static const LooviTokens escritorioVirtual =
      LooviTokens._(LooviProductMode.escritorioVirtual, LooviComponentTokens.escritorioVirtual);

  /// Mode `site-loovi` (resolved only; no widgets/gallery in this stage).
  static const LooviTokens siteLoovi =
      LooviTokens._(LooviProductMode.siteLoovi, LooviComponentTokens.siteLoovi);

  /// Product mode these tokens were resolved for.
  final LooviProductMode mode;

  /// `product-theme` component tokens for [mode].
  final LooviComponentTokens component;

  LooviColors get color => const LooviColors._();
  LooviTextColors get text => const LooviTextColors._();
  LooviFeedbackColors get feedback => const LooviFeedbackColors._();
  LooviInteractiveColors get interactive => const LooviInteractiveColors._();
  LooviPrimitiveColors get primitive => const LooviPrimitiveColors._();
  LooviSpacing get spacing => const LooviSpacing._();
  LooviRadius get radius => const LooviRadius._();
  LooviBorderWidth get borderWidth => const LooviBorderWidth._();
  LooviBreakpoints get breakpoint => const LooviBreakpoints._();
  LooviTypography get typography => const LooviTypography._();
  LooviEffects get effects => const LooviEffects._();

  /// Tokens from the nearest [Theme]. Falls back to `app-cliente` when the
  /// theme has no [LooviTokens] extension (e.g. a bare MaterialApp in a test).
  static LooviTokens of(BuildContext context) =>
      Theme.of(context).extension<LooviTokens>() ?? appCliente;

  @override
  LooviTokens copyWith({LooviProductMode? mode}) =>
      mode == null ? this : LooviTokens.forMode(mode);

  /// Product modes are discrete: no interpolation between them.
  @override
  LooviTokens lerp(covariant ThemeExtension<LooviTokens>? other, double t) {
    if (other is! LooviTokens) return this;
    return t < 0.5 ? this : other;
  }
}
