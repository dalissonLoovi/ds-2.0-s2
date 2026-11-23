import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../foundation/loovi_tap_target.dart';
import '../../generated/loovi_icon_names.g.dart';

/// Seed `Link.size` (default lg).
enum LooviLinkSize { lg, md, sm }

/// Seed `Link.appearance`: `inverse` on dark / on-color surfaces.
enum LooviLinkAppearance { defaultAppearance, inverse }

/// Link (Figma 3820:13913) — text navigation control.
///
/// Seed `state` maps to runtime: `active` = pressed (touch), `focus` =
/// keyboard focus-visible; `visited` and `disabled` are props. `hover` is not
/// used on the app (mobile).
///
/// Paint (mode app-cliente):
/// - label `body/large|medium|small/regular` (lg|md|sm); gap `spacing/100`;
///   trailing icon 16 | 16 | 14 (default arrow-narrow-right-outline).
/// - default appearance: default|focus `text/link`, active `text/primary`,
///   visited `text/secondary`, disabled `text/placeholder`.
/// - inverse: default|focus|active `text/on-color`, visited|disabled
///   `text/on-color-disabled`.
/// - focus ring (focus only): `border/width/012` `interactive/focus`, radius
///   `border/radius/100`, drawn over the frame (no layout shift).
/// - inline: 1 px underline bar in the label color under the label, no icon.
class LooviLink extends StatefulWidget {
  const LooviLink({
    super.key,
    required this.label,
    required this.onPressed,
    this.size = LooviLinkSize.lg,
    this.appearance = LooviLinkAppearance.defaultAppearance,
    this.inline = false,
    this.showIcon = true,
    this.trailingIcon = LooviIcons.arrowNarrowRightOutline,
    this.visited = false,
    this.disabled = false,
    this.semanticLabel,
    this.visitedSemanticHint = 'Visitado',
    this.statesController,
    this.focusNode,
    this.autofocus = false,
  });

  /// Visible link text (seed `label`).
  final String label;

  /// Navigation callback. Null = disabled.
  final VoidCallback? onPressed;

  final LooviLinkSize size;
  final LooviLinkAppearance appearance;

  /// Seed `inline`: underline, trailing icon hidden.
  final bool inline;

  /// Seed `showIcon` (standalone links only; ignored when [inline]).
  final bool showIcon;

  /// Seed `trailingIcon` (INSTANCE_SWAP).
  final String trailingIcon;

  /// Seed `state=visited`.
  final bool visited;

  /// Seed `state=disabled`.
  final bool disabled;

  /// Overrides the accessible name (defaults to [label]).
  final String? semanticLabel;

  /// Hint announced when [visited] (Flutter semantics has no visited flag).
  final String visitedSemanticHint;

  /// Optional external interaction states (like Material buttons). Stories and
  /// goldens can force [WidgetState.pressed] or [WidgetState.focused] (focus ring).
  final WidgetStatesController? statesController;

  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<LooviLink> createState() => _LooviLinkState();
}

class _LooviLinkState extends State<LooviLink> {
  WidgetStatesController? _internalStates;
  WidgetStatesController get _states => widget.statesController ?? (_internalStates ??= WidgetStatesController());
  bool _focusHighlight = false;

  bool get _enabled => widget.onPressed != null && !widget.disabled;

  @override
  void initState() {
    super.initState();
    _states.addListener(_onStates);
    _syncStates();
  }

  @override
  void didUpdateWidget(LooviLink oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.statesController != widget.statesController) {
      (oldWidget.statesController ?? _internalStates)?.removeListener(_onStates);
      _states.addListener(_onStates);
    }
    _syncStates();
  }

  void _syncStates() {
    _states.update(WidgetState.disabled, !_enabled);
    if (!_enabled) _states.update(WidgetState.pressed, false);
  }

  void _onStates() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _states.removeListener(_onStates);
    _internalStates?.dispose();
    super.dispose();
  }

  void _setPressed(bool v) {
    if (_enabled) _states.update(WidgetState.pressed, v);
  }

  void _activate() {
    if (_enabled) widget.onPressed?.call();
  }

  Color _color(LooviTokens t) {
    final s = _states.value;
    final inverse = widget.appearance == LooviLinkAppearance.inverse;
    if (s.contains(WidgetState.disabled)) return inverse ? t.text.onColorDisabled : t.text.placeholder;
    if (s.contains(WidgetState.pressed)) return inverse ? t.text.onColor : t.text.primary;
    if (widget.visited) return inverse ? t.text.onColorDisabled : t.text.secondary;
    return inverse ? t.text.onColor : t.text.link;
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final color = _color(t);
    final (style, iconSize) = switch (widget.size) {
      LooviLinkSize.lg => (t.typography.bodyLargeRegular, t.spacing.s200),
      LooviLinkSize.md => (t.typography.bodyMediumRegular, t.spacing.s200),
      // 14 has no spacing token: body/medium/font-size (= 14) is the token of same value.
      LooviLinkSize.sm => (t.typography.bodySmallRegular, t.typography.bodyMediumRegular.fontSize!),
    };
    final showTrailing = !widget.inline && widget.showIcon;

    Widget label = Text(widget.label, maxLines: 1, softWrap: false, overflow: TextOverflow.ellipsis, style: style.copyWith(color: color));
    if (widget.inline) {
      label = IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [label, SizedBox(height: t.borderWidth.s012, child: ColoredBox(color: color))],
        ),
      );
    }

    Widget frame = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: label),
        if (showTrailing) ...[
          SizedBox(width: t.spacing.s100),
          LooviIcon(widget.trailingIcon, size: iconSize, color: color),
        ],
      ],
    );

    if ((_focusHighlight || _states.value.contains(WidgetState.focused)) && _enabled) {
      frame = DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(t.radius.s100),
          border: Border.all(color: t.interactive.focus, width: t.borderWidth.s012),
        ),
        child: frame,
      );
    }

    final min = LooviTapTarget.minSize(context);
    return Semantics(
      container: true,
      link: true,
      enabled: _enabled,
      label: widget.semanticLabel ?? widget.label,
      hint: widget.visited ? widget.visitedSemanticHint : null,
      onTap: _enabled ? _activate : null,
      excludeSemantics: true,
      child: FocusableActionDetector(
        enabled: _enabled,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        onShowFocusHighlight: (v) => setState(() => _focusHighlight = v),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {
            _activate();
            return null;
          }),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _enabled ? _activate : null,
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          // Touch target >= 48 (spacing/600); paint keeps the Figma size.
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: min, minHeight: min),
            child: Center(widthFactor: 1, heightFactor: 1, child: frame),
          ),
        ),
      ),
    );
  }
}
