import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_blend.dart';

/// INTERNAL — not exported from `lib/loovi_ds.dart`. Shared implementation
/// of the three Card surface items (CardOutlinedItem / CardElevatedItem /
/// CardFilledItem) and the background of CardHorizontal / CardStacked.
enum LooviCardItemKind { outlined, elevated, filled }

/// Card surface state shell (seed `Card*Item`). See the public wrappers for
/// the paint per kind.
///
/// Seed `state` → runtime: `pressed` from touch (only when [onPressed] is
/// set), `focus` from keyboard focus-visible, `dragged` is the [dragged] prop
/// (the product owns drag & drop). `hover` is not used on the app (mobile).
class LooviCardItemSurface extends StatefulWidget {
  const LooviCardItemSurface({
    super.key,
    required this.kind,
    this.child,
    this.padding,
    this.onPressed,
    this.dragged = false,
    this.showFocusIndicator = true,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
  });

  final LooviCardItemKind kind;
  final Widget? child;

  /// Null = stateLayer padding `spacing/100` (Figma). Parent Cards pass zero.
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onPressed;
  final bool dragged;
  final bool showFocusIndicator;
  final String? semanticLabel;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<LooviCardItemSurface> createState() => _LooviCardItemSurfaceState();
}

class _LooviCardItemSurfaceState extends State<LooviCardItemSurface> {
  bool _pressed = false;
  bool _focused = false;

  bool get _interactive => widget.onPressed != null;

  void _setPressed(bool v) {
    if (_pressed != v) setState(() => _pressed = v);
  }

  @override
  void didUpdateWidget(LooviCardItemSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_interactive) {
      _pressed = false;
      _focused = false;
    }
  }

  Color _surface(LooviTokens t) => switch (widget.kind) {
        LooviCardItemKind.outlined => t.color.backgroundSurface0,
        LooviCardItemKind.elevated => t.color.backgroundSurface1,
        LooviCardItemKind.filled => t.color.backgroundSurface2,
      };

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final radius = BorderRadius.circular(t.radius.s300);
    final surface = _surface(t);

    // dragged: stateLayer `interactive/selected` (opaque) over the surface;
    // pressed: root `interactive/pressed` composited Plus Darker over it.
    final Color fill;
    if (widget.dragged) {
      fill = t.interactive.selected;
    } else if (_pressed) {
      fill = looviPlusDarker(surface, t.interactive.pressed);
    } else {
      fill = surface;
    }

    final List<LooviShadow>? shadow = widget.dragged
        ? t.effects.elevation2
        : widget.kind == LooviCardItemKind.elevated
            ? t.effects.elevation1
            : null;

    Widget card = DecoratedBox(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: radius,
        boxShadow: shadow == null ? null : LooviEffects.box(shadow),
      ),
      position: DecorationPosition.background,
      child: DecoratedBox(
        // Outline (outlined only) and the focus ring paint on top of the
        // content so media never covers them.
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          borderRadius: radius,
          border: widget.kind == LooviCardItemKind.outlined
              ? Border.all(color: t.color.border2, width: t.borderWidth.s012)
              : null,
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: Padding(
            padding: widget.padding ?? EdgeInsets.all(t.spacing.s100),
            child: widget.child ?? const SizedBox.shrink(),
          ),
        ),
      ),
    );

    if (_focused && widget.showFocusIndicator) {
      card = DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(
            color: t.color.actionsPrimary,
            width: t.borderWidth.s025,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        child: card,
      );
    }

    if (!_interactive) {
      return Semantics(container: true, label: widget.semanticLabel, child: card);
    }

    return Semantics(
      container: true,
      button: true,
      label: widget.semanticLabel,
      child: FocusableActionDetector(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        mouseCursor: SystemMouseCursors.click,
        onShowFocusHighlight: (v) => setState(() => _focused = v),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {
            widget.onPressed?.call();
            return null;
          }),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          onTap: widget.onPressed,
          child: card,
        ),
      ),
    );
  }
}

/// INTERNAL — media slot of CardHorizontal / CardStacked: the product's photo
/// (`BoxFit.cover` = Figma scaleMode FILL) over the `color/background-surface/2`
/// placeholder. Decorative unless [semanticLabel] is given.
class LooviCardMedia extends StatelessWidget {
  const LooviCardMedia({super.key, this.image, this.semanticLabel});

  final ImageProvider? image;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final Widget box = DecoratedBox(
      decoration: BoxDecoration(
        color: t.color.backgroundSurface2,
        image: image == null ? null : DecorationImage(image: image!, fit: BoxFit.cover),
      ),
      child: const SizedBox.expand(),
    );
    if (image == null || semanticLabel == null) return ExcludeSemantics(child: box);
    return Semantics(image: true, label: semanticLabel, child: ExcludeSemantics(child: box));
  }
}
