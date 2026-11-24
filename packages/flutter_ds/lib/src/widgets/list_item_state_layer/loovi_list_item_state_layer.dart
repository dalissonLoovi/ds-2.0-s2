import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

/// Seed `ListItemStateLayer.state`. `default` is a reserved word in Dart, so
/// the seed value `default` maps to [standard]. The seed `hover` value is not
/// mapped: the app is mobile-only (no hover).
enum LooviListItemStateLayerState {
  /// Seed `default` — no fill, no ring.
  standard,

  /// Seed `focus` — ring only (no wash): 2 dp `interactive/focus`.
  focus,

  /// Seed `pressed` — `interactive/pressed` wash.
  pressed,

  /// Seed `dragged` — `interactive/selected` wash + `elevation/1` shadow.
  dragged,
}

/// Seed ListItemStateLayer (Figma 3720:28) — visual-only interaction surface
/// that [LooviListItem] paints behind its content row (`Positioned.fill`).
///
/// Paint tokens (mode app-cliente):
/// - wash corners `border/radius/0`;
/// - pressed: `interactive/pressed`;
/// - dragged: `interactive/selected` + `effects/elevation/1`
///   (DROP_SHADOW 0/8/8, `color/elevation/6`);
/// - focus: ring `border/width/025` in `interactive/focus`, corners
///   `border/radius/200`, no fill.
///
/// The optional Figma `pressedRipple` layer is not painted (seed marks it
/// optional; the pressed wash carries the feedback).
///
/// No runtime role: excluded from semantics and hit testing — the parent row
/// owns focus, keyboard and semantics.
class LooviListItemStateLayer extends StatelessWidget {
  const LooviListItemStateLayer({super.key, this.state = LooviListItemStateLayerState.standard});

  final LooviListItemStateLayerState state;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final wash = switch (state) {
      LooviListItemStateLayerState.pressed => t.interactive.pressed,
      LooviListItemStateLayerState.dragged => t.interactive.selected,
      _ => null,
    };
    final focused = state == LooviListItemStateLayerState.focus;
    return IgnorePointer(
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: wash,
            borderRadius: BorderRadius.circular(t.radius.s0),
            boxShadow: state == LooviListItemStateLayerState.dragged ? LooviEffects.box(t.effects.elevation1) : null,
          ),
          child: focused
              ? DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: t.interactive.focus, width: t.borderWidth.s025),
                    borderRadius: BorderRadius.circular(t.radius.s200),
                  ),
                  child: const SizedBox.expand(),
                )
              : const SizedBox.expand(),
        ),
      ),
    );
  }
}
