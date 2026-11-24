import 'dart:ui' show SemanticsRole;

import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../generated/loovi_icon_names.g.dart';

/// Seed ListActionDropdownItem (Figma 3681:11151) — actionable row of a
/// `LooviListActionDropdown` action menu (e.g. "Editar").
///
/// Seed `state` mapping: `default` / `pressed` / `focus` are runtime
/// interaction states (no `hover` on mobile); `selected` and `disabled` are
/// the [selected] / [disabled] props.
///
/// Paint tokens (mode app-cliente):
/// - row: padding `spacing/200` (h) / `spacing/0` (v), gap `spacing/100`,
///   corners `border/radius/100`;
/// - fill: default/focus `color/background-surface/0`, pressed
///   `interactive/pressed`, selected `interactive/selected`, disabled
///   `interactive/disabled-surface`;
/// - leadingIcon 20 dp (`spacing/250`) `text/secondary` (disabled
///   `text/placeholder`); decorative;
/// - label `body/medium/regular` `text/primary` (16.6:1; disabled
///   `text/placeholder`, exempt from AA as inactive UI);
/// - focusRing `border/width/025` `interactive/focus`, keyboard focus only.
///
/// Height: the Figma row is 40 dp (`spacing/500`); rows here are at least
/// 48 dp (`spacing/600`) so every stacked row keeps a full touch target
/// without overlapping its neighbours. Grows with the system textScaler.
///
/// Semantics: role menuItem inside a `LooviListActionDropdown` (button
/// otherwise), label = [label]; disabled rows are not focusable/clickable;
/// [selected] is exposed only when true (selectable parents).
class LooviListActionDropdownItem extends StatefulWidget {
  const LooviListActionDropdownItem({
    super.key,
    required this.label,
    this.icon = LooviIcons.editOutline,
    this.showIcon = true,
    this.selected = false,
    this.disabled = false,
    this.onSelect,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
  });

  /// Seed `label` — visible action text.
  final String label;

  /// Seed `icon` (INSTANCE_SWAP) — DS outline icon, e.g. [LooviIcons.editOutline].
  final String icon;

  /// Seed `showIcon`.
  final bool showIcon;

  /// Seed `state=selected` (only when the parent represents a value).
  final bool selected;

  /// Seed `state=disabled`.
  final bool disabled;

  /// Called on tap / Enter / Space. Null (or [disabled]) = inactive row.
  final VoidCallback? onSelect;

  /// Accessible label. Defaults to [label].
  final String? semanticLabel;

  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<LooviListActionDropdownItem> createState() => _LooviListActionDropdownItemState();
}

class _LooviListActionDropdownItemState extends State<LooviListActionDropdownItem> {
  bool _pressed = false;
  bool _focused = false;

  bool get _enabled => !widget.disabled && widget.onSelect != null;

  void _setPressed(bool v) {
    if (_pressed != v) setState(() => _pressed = v);
  }

  @override
  void didUpdateWidget(LooviListActionDropdownItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_enabled) {
      _pressed = false;
      _focused = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final disabled = widget.disabled;
    final radius = BorderRadius.circular(t.radius.s100);

    final Color fill;
    if (disabled) {
      fill = t.interactive.disabledSurface;
    } else if (_pressed) {
      fill = t.interactive.pressed;
    } else if (widget.selected) {
      fill = t.interactive.selected;
    } else {
      fill = t.color.backgroundSurface0;
    }

    final row = Container(
      constraints: BoxConstraints(minHeight: t.spacing.s600),
      padding: EdgeInsets.symmetric(horizontal: t.spacing.s200, vertical: t.spacing.s0),
      decoration: BoxDecoration(color: fill, borderRadius: radius),
      foregroundDecoration: _focused && _enabled
          ? BoxDecoration(
              border: Border.all(color: t.interactive.focus, width: t.borderWidth.s025),
              borderRadius: radius,
            )
          : null,
      child: Row(
        children: [
          if (widget.showIcon) ...[
            LooviIcon(
              widget.icon,
              size: t.spacing.s250,
              color: disabled ? t.text.placeholder : t.text.secondary,
            ),
            SizedBox(width: t.spacing.s100),
          ],
          Expanded(
            child: Text(
              widget.label,
              style: t.typography.bodyMediumRegular.copyWith(color: disabled ? t.text.placeholder : t.text.primary),
            ),
          ),
        ],
      ),
    );

    Widget child = ExcludeSemantics(child: row);
    if (_enabled) {
      child = FocusableActionDetector(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        mouseCursor: SystemMouseCursors.click,
        onShowFocusHighlight: (v) => setState(() => _focused = v),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {
            widget.onSelect?.call();
            return null;
          }),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          onTap: widget.onSelect,
          excludeFromSemantics: true,
          child: child,
        ),
      );
    }

    final inMenu = LooviListActionDropdownScope.maybeOf(context);
    return Semantics(
      container: true,
      role: inMenu ? SemanticsRole.menuItem : null,
      button: inMenu ? null : true,
      enabled: _enabled,
      focusable: _enabled,
      focused: _enabled ? _focused : null,
      selected: widget.selected ? true : null,
      label: widget.semanticLabel ?? widget.label,
      onTap: _enabled ? widget.onSelect : null,
      child: child,
    );
  }
}

/// Marks a subtree as the content of an action menu so
/// [LooviListActionDropdownItem] can take `SemanticsRole.menuItem` (which
/// Flutter only allows under a menu node). Provided by
/// `LooviListActionDropdown`.
class LooviListActionDropdownScope extends InheritedWidget {
  const LooviListActionDropdownScope({super.key, required super.child});

  static bool maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LooviListActionDropdownScope>() != null;

  @override
  bool updateShouldNotify(LooviListActionDropdownScope oldWidget) => false;
}
