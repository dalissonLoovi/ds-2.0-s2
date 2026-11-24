import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

/// CarouselPaginationItem (Figma 4152:495) — pagination dots of [LooviCarousel]
/// (internal; not a slide, ProgressBar, StepProgressIndicator or Tabs).
///
/// Seed `itemCount` (2…5) and `itemView` (1…[itemCount], 1-based active dot)
/// are numeric variants, kept as `int` (sparse matrix, 14 published: itemView
/// must be ≤ itemCount — asserted).
///
/// Paint (mode app-cliente):
/// - root: full width (Fill), padding top/bottom `spacing/100`, other
///   paddings/gaps `spacing/0`; dots row centered.
/// - dot: circle `spacing/100` × `spacing/100`, gap `spacing/100`.
/// - active dot (index = [itemView]) `color/actions/primary`; inactive
///   `color/border/2`.
///
/// Semantics: decorative (excluded). The parent Carousel announces
/// "Slide X de Y". Dots are not focus / tap targets (seed).
class LooviCarouselPaginationItem extends StatelessWidget {
  const LooviCarouselPaginationItem({super.key, required this.itemCount, required this.itemView})
    : assert(itemCount >= 2 && itemCount <= 5, 'CarouselPaginationItem.itemCount is 2…5 (seed)'),
      assert(itemView >= 1 && itemView <= itemCount, 'CarouselPaginationItem.itemView must be 1…itemCount (seed)');

  /// Seed `itemCount` — number of dots (2…5).
  final int itemCount;

  /// Seed `itemView` — active dot, 1-based (1…[itemCount]).
  final int itemView;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final dot = t.spacing.s100;
    final gap = t.spacing.s100;
    return ExcludeSemantics(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: t.spacing.s100, horizontal: t.spacing.s0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 1; i <= itemCount; i++) ...[
              if (i > 1) SizedBox(width: gap),
              SizedBox.square(
                dimension: dot,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i == itemView ? t.color.actionsPrimary : t.color.border2,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
