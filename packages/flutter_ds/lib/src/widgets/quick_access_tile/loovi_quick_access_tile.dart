import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../generated/loovi_icon_names.g.dart';

/// QuickAccessTile (Figma 4203:447) — compact shortcut tile for the home
/// "Acesso rápido" grid (the grid itself is a screen composition of N tiles,
/// not a component).
///
/// Seed `state` maps to runtime: `pressed` from touch (state layer),
/// `disabled` is a prop. No hover/focus variants in Figma (mobile press
/// model); keyboard focus still shows the `interactive/focus` ring so the
/// tile stays operable without touch.
///
/// Paint (mode app-cliente, seed tokenRules):
/// - surface `color/background-surface/2`, radius `border/radius/400`;
///   size `spacing/1000` × `spacing/1100` (80 × 88 — the height is a MIN so
///   a larger system text scale grows the tile instead of clipping);
///   padding `spacing/200` (vertical) / `spacing/150` (horizontal);
///   gap `spacing/050`.
/// - icon 24 (`spacing/300`) stroke `text/brand`; disabled `text/placeholder`.
/// - label `caption/medium/medium` + `text/primary` (disabled
///   `text/placeholder`), left-aligned, up to 2 lines.
/// - pressed: absolute stateLayer `interactive/pressed` over the surface,
///   under the content (Figma layer order).
class LooviQuickAccessTile extends StatefulWidget {
  const LooviQuickAccessTile({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = LooviIcons.appsOutline,
    this.disabled = false,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
  });

  /// Seed `label` (also the accessible name).
  final String label;

  /// Seed `icon` (INSTANCE_SWAP) — DS contract name, default
  /// [LooviIcons.appsOutline].
  final String icon;

  /// Tap callback. Null = disabled (same as [disabled] = true).
  final VoidCallback? onPressed;

  /// Seed `state=disabled`: not focusable, not tappable.
  final bool disabled;

  /// Overrides the accessible name (defaults to [label]).
  final String? semanticLabel;

  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<LooviQuickAccessTile> createState() => _LooviQuickAccessTileState();
}

class _LooviQuickAccessTileState extends State<LooviQuickAccessTile> {
  bool _pressed = false;
  bool _focused = false;

  bool get _enabled => !widget.disabled && widget.onPressed != null;

  void _setPressed(bool v) {
    if (_pressed != v) setState(() => _pressed = v);
  }

  @override
  void didUpdateWidget(LooviQuickAccessTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_enabled) {
      _pressed = false;
      _focused = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final ink = _enabled ? t.text.brand : t.text.placeholder;
    final labelColor = _enabled ? t.text.primary : t.text.placeholder;
    final radius = BorderRadius.circular(t.radius.s400);

    final content = Padding(
      padding: EdgeInsets.symmetric(horizontal: t.spacing.s150, vertical: t.spacing.s200),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LooviIcon(widget.icon, size: t.spacing.s300, color: ink),
          SizedBox(height: t.spacing.s050),
          Text(
            widget.label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: t.typography.captionMediumMedium.copyWith(color: labelColor),
          ),
        ],
      ),
    );

    Widget tile = ConstrainedBox(
      constraints: BoxConstraints(minHeight: t.spacing.s1100),
      child: SizedBox(
        width: t.spacing.s1000,
        child: DecoratedBox(
          decoration: BoxDecoration(color: t.color.backgroundSurface2, borderRadius: radius),
          child: Stack(
            children: [
              if (_pressed)
                Positioned.fill(
                  child: DecoratedBox(decoration: BoxDecoration(color: t.interactive.pressed, borderRadius: radius)),
                ),
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: t.spacing.s1100, minWidth: t.spacing.s1000),
                child: Align(alignment: AlignmentDirectional.centerStart, widthFactor: 1, heightFactor: 1, child: content),
              ),
              if (_focused)
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: radius,
                        border: Border.all(color: t.interactive.focus, width: t.borderWidth.s025),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    if (_enabled) {
      tile = FocusableActionDetector(
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
          excludeFromSemantics: true,
          child: tile,
        ),
      );
    }

    return Semantics(
      container: true,
      button: true,
      enabled: _enabled,
      focusable: _enabled,
      focused: _enabled ? _focused : null,
      label: widget.semanticLabel ?? widget.label,
      onTap: _enabled ? widget.onPressed : null,
      child: ExcludeSemantics(child: tile),
    );
  }
}
