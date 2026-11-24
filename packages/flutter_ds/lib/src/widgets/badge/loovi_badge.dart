import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../generated/loovi_icon_names.g.dart';

/// Seed `Badge.size`. Figma: `sm` only with `content=dot`; `lg` with
/// `content=count|overflow`.
enum LooviBadgeSize { sm, lg }

/// Seed `Badge.content`.
enum LooviBadgeContent { dot, count, overflow }

/// Badge (Figma 3669:8175) — compact, NON-interactive notification / count
/// indicator attached to another element (icon, tab, avatar, nav item). Never
/// focusable or tappable; interaction belongs to the parent.
///
/// Paint (mode app-cliente):
/// - dot (sm): 16 box (`spacing/200`) with the `player-record-filled` glyph in
///   `color/palette/tangerine-1`.
/// - count (lg): circle `spacing/200` (16), fill `color/palette/tangerine-1`,
///   radius `border/radius/full`, label `caption/large/regular` +
///   `text/primary` (≈6.7:1 on tangerine-1).
/// - overflow (lg): height `spacing/200`, padding-x `spacing/050`, same fill,
///   radius and label (e.g. "999+").
/// - The frame is a minimum: a larger system text scale grows the pill.
///
/// Accessibility (seed): if the badge is the only indicator, it exposes
/// [semanticLabel] (default: the count / overflow label, "Nova notificação"
/// for a dot). With [decorative] = true it is hidden (adjacent text explains it).
class LooviBadge extends StatelessWidget {
  const LooviBadge({
    super.key,
    this.size = LooviBadgeSize.sm,
    this.content = LooviBadgeContent.dot,
    this.count = 1,
    this.overflowLabel = '999+',
    this.decorative = false,
    this.semanticLabel,
  });

  /// Count badge (`size=lg, content=count`).
  const LooviBadge.count(this.count, {super.key, this.decorative = false, this.semanticLabel})
    : size = LooviBadgeSize.lg,
      content = LooviBadgeContent.count,
      overflowLabel = '999+';

  /// Overflow badge (`size=lg, content=overflow`).
  const LooviBadge.overflow({super.key, this.overflowLabel = '999+', this.decorative = false, this.semanticLabel})
    : size = LooviBadgeSize.lg,
      content = LooviBadgeContent.overflow,
      count = 1;

  final LooviBadgeSize size;
  final LooviBadgeContent content;

  /// Seed `count` (visible number for `content=count`).
  final int count;

  /// Seed `overflowLabel` (visible label for `content=overflow`).
  final String overflowLabel;

  /// Hide from assistive technologies.
  final bool decorative;

  /// Accessible name override.
  final String? semanticLabel;

  String get _visibleText => content == LooviBadgeContent.overflow ? overflowLabel : '$count';

  String get _defaultSemantic => content == LooviBadgeContent.dot ? 'Nova notificação' : _visibleText;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final fill = t.color.paletteTangerine1;
    final box = t.spacing.s200;

    final Widget badge;
    if (content == LooviBadgeContent.dot) {
      badge = LooviIcon(LooviIcons.playerRecordFilled, size: box, color: fill);
    } else {
      badge = Container(
        constraints: BoxConstraints(minWidth: box, minHeight: box),
        padding: content == LooviBadgeContent.overflow ? EdgeInsets.symmetric(horizontal: t.spacing.s050) : null,
        decoration: BoxDecoration(color: fill, borderRadius: BorderRadius.circular(t.radius.full)),
        child: Center(
          widthFactor: 1,
          heightFactor: 1,
          child: Text(
            _visibleText,
            maxLines: 1,
            softWrap: false,
            textAlign: TextAlign.center,
            style: t.typography.captionLargeRegular.copyWith(color: t.text.primary),
          ),
        ),
      );
    }
    final hug = Align(widthFactor: 1, heightFactor: 1, child: badge);
    if (decorative) return ExcludeSemantics(child: hug);
    return Semantics(
      container: true,
      label: semanticLabel ?? _defaultSemantic,
      child: ExcludeSemantics(child: hug),
    );
  }
}
