import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

/// Seed `TextHeader.size`.
enum LooviTextHeaderSize { large, medium, small }

/// Seed `TextHeader.alignment`.
enum LooviTextHeaderAlignment { left, center }

/// TextHeader (Figma 3667:4129) — compact title + optional supporting text
/// used inside AppHeader, SystemHeader and similar chrome. Not a page hero,
/// Banner, Chip or Button label. Published 6/6 (size x alignment).
///
/// Paint (mode app-cliente):
/// - root: vertical, padding `spacing/0`, radius `border/radius/0`; gap
///   title to description `spacing/050` (large | medium) | `spacing/0`
///   (small); width Fill.
/// - size=large: `heading/h1/medium` + `body/large/regular`.
/// - size=medium: `heading/h2/medium` + `body/medium/regular`.
/// - size=small: `heading/h3/medium` + `body/small/regular`.
/// - title `text/primary`; description `text/secondary`. [inverse] (nested in
///   appearance=inverse chrome, seed rule `inverseOverride`): title
///   `text/on-color`, description `text/on-color-disabled`.
/// - alignment left = start (RTL aware) | center. Text wraps; the system
///   textScaler is respected.
///
/// Semantics: title is a header (level 1 | 2 | 3 by size, as the React h1/h2/h3
/// map); the description is plain text.
class LooviTextHeader extends StatelessWidget {
  const LooviTextHeader({
    super.key,
    required this.title,
    this.description = '',
    this.size = LooviTextHeaderSize.large,
    this.alignment = LooviTextHeaderAlignment.left,
    this.showDescription = true,
    this.inverse = false,
  });

  /// Seed `title` (TEXT).
  final String title;

  /// Seed `description` (TEXT). Empty = not shown.
  final String description;

  final LooviTextHeaderSize size;
  final LooviTextHeaderAlignment alignment;

  /// Seed `showDescription` (default true).
  final bool showDescription;

  /// Seed rule `inverseOverride` (on-color texts on inverse chrome).
  final bool inverse;

  /// (title, description) styles of [size] (seed tokenRules).
  static (TextStyle, TextStyle) stylesFor(LooviTokens t, LooviTextHeaderSize size) => switch (size) {
    LooviTextHeaderSize.large => (t.typography.headingH1Medium, t.typography.bodyLargeRegular),
    LooviTextHeaderSize.medium => (t.typography.headingH2Medium, t.typography.bodyMediumRegular),
    LooviTextHeaderSize.small => (t.typography.headingH3Medium, t.typography.bodySmallRegular),
  };

  /// Title to description gap of [size].
  static double gapFor(LooviTokens t, LooviTextHeaderSize size) =>
      size == LooviTextHeaderSize.small ? t.spacing.s0 : t.spacing.s050;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final (titleStyle, descStyle) = stylesFor(t, size);
    final center = alignment == LooviTextHeaderAlignment.center;
    final align = center ? TextAlign.center : TextAlign.start;
    final hasDescription = showDescription && description.isNotEmpty;
    final level = switch (size) {
      LooviTextHeaderSize.large => 1,
      LooviTextHeaderSize.medium => 2,
      LooviTextHeaderSize.small => 3,
    };

    return Padding(
      padding: EdgeInsets.all(t.spacing.s0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            header: true,
            headingLevel: level,
            child: Text(
              title,
              textAlign: align,
              style: titleStyle.copyWith(color: inverse ? t.text.onColor : t.text.primary),
            ),
          ),
          if (hasDescription) ...[
            SizedBox(height: gapFor(t, size)),
            Text(
              description,
              textAlign: align,
              style: descStyle.copyWith(color: inverse ? t.text.onColorDisabled : t.text.secondary),
            ),
          ],
        ],
      ),
    );
  }
}
