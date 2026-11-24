import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

/// Seed `DividerHorizontal.variant` (`full-width | inset | middle-inset |
/// with-subhead`).
enum LooviDividerHorizontalVariant { fullWidth, inset, middleInset, withSubhead }

/// DividerHorizontal (Figma 3653:22914) — non-interactive horizontal
/// separator. Never focusable, never tappable; not a layout container.
///
/// Paint (mode app-cliente):
/// - dividerLine: `border/width/012` (1) stroke `color/border/2`, fills the
///   available width.
/// - full-width: edge to edge.
/// - inset: start inset `spacing/250` (aligns with content padding).
/// - middle-inset: `spacing/250` on both sides.
/// - with-subhead: padding-x `spacing/250`; line, gap `spacing/050`, then the
///   [label] in `body/small/medium` + `text/secondary` (AA; was
///   `text/on-color-disabled` 1.5:1 until 2026-11-24).
///
/// Accessibility (seed): decorative by default (hidden). Set
/// [decorative] = false to expose separator semantics. The with-subhead label
/// is contextual text and is always exposed.
class LooviDividerHorizontal extends StatelessWidget {
  const LooviDividerHorizontal({
    super.key,
    this.variant = LooviDividerHorizontalVariant.fullWidth,
    this.label,
    this.decorative = true,
  });

  final LooviDividerHorizontalVariant variant;

  /// Seed `label` — only rendered with `variant=with-subhead`.
  final String? label;

  /// Hide from assistive technologies (React default true).
  final bool decorative;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final line = SizedBox(
      width: double.infinity,
      height: t.borderWidth.s012,
      child: ColoredBox(color: t.color.border2),
    );

    final inset = t.spacing.s250;
    final Widget divider = switch (variant) {
      LooviDividerHorizontalVariant.fullWidth => line,
      LooviDividerHorizontalVariant.inset => Padding(padding: EdgeInsetsDirectional.only(start: inset), child: line),
      LooviDividerHorizontalVariant.middleInset => Padding(padding: EdgeInsets.symmetric(horizontal: inset), child: line),
      LooviDividerHorizontalVariant.withSubhead => Padding(
          padding: EdgeInsets.symmetric(horizontal: inset),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              line,
              if (label != null) ...[
                SizedBox(height: t.spacing.s050),
                Text(label!, style: t.typography.bodySmallMedium.copyWith(color: t.text.secondary)),
              ],
            ],
          ),
        ),
    };

    final hasLabel = variant == LooviDividerHorizontalVariant.withSubhead && label != null;
    if (decorative && !hasLabel) return ExcludeSemantics(child: divider);
    // Flutter has no separator role: expose the label (if any) as a header-like
    // grouping node; a bare separator is announced as "Separador".
    return Semantics(
      container: true,
      label: hasLabel ? label : 'Separador',
      child: ExcludeSemantics(child: divider),
    );
  }
}
