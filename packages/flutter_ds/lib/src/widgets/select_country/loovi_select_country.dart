import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../foundation/loovi_tap_target.dart';
import '../../generated/loovi_icon_names.g.dart';

/// Seed `SelectCountry.size` — `sm` is the in-field density of InputNumber.
enum LooviSelectCountrySize { sm, md }

/// Seed `SelectCountry` (Figma 3935:5522) — compact country / DDI trigger,
/// building block of InputNumber (phone). Mode app-cliente.
///
/// Anatomy / paint:
/// - root: padding `spacing/050` (sm) or `spacing/100` vert × `spacing/200`
///   horiz (md); gap `spacing/050`; radius `border/radius/300`; no fill.
/// - countryFlag 20 (`spacing/250`), clipped to a circle (Flags
///   `Style=Square, Radius=On`). [countryFlag] null = token-painted
///   placeholder (`color/background-surface/3` + [countryCode] in
///   `caption/small/medium` `text/primary`) until the Flags assets ship.
/// - expandIcon 20: `chevron-down-outline` (expanded=false) /
///   `chevron-up-outline` (expanded=true); `text/primary`, disabled
///   `text/placeholder`. The parent field may override it ([iconColor]).
/// - state=focus: stroke `interactive/focus` `border/width/012` (real
///   keyboard focus). Hover does not exist on the app.
/// - state=disabled: root opacity [disabledOpacity] (Figma 0.64, no opacity
///   token), no stroke; never expanded (sparse matrix).
///
/// The country list is never nested: [onPressed] opens a list composed by the
/// screen and [expanded] reflects it. Touch target ≥ 48 via [LooviTapTarget]
/// (sm paints 52 × 28).
class LooviSelectCountry extends StatefulWidget {
  const LooviSelectCountry({
    super.key,
    this.size = LooviSelectCountrySize.md,
    this.expanded = false,
    this.disabled = false,
    this.countryFlag,
    this.countryCode = 'BR',
    this.countryName = 'Brasil',
    this.onPressed,
    this.semanticLabel,
    this.iconColor,
    this.focusNode,
    this.autofocus = false,
  });

  final LooviSelectCountrySize size;

  /// Seed `expanded` — external country list open. Ignored when [disabled].
  final bool expanded;

  /// Seed `state=disabled`.
  final bool disabled;

  /// Seed `countryFlag` (INSTANCE_SWAP → Flags). Painted at 20 × 20 and
  /// clipped to a circle. Null = placeholder with [countryCode].
  final Widget? countryFlag;

  /// ISO code shown by the placeholder flag (e.g. `BR`).
  final String countryCode;

  /// Country name used in the accessible name.
  final String countryName;

  /// Opens / closes the external country list.
  final VoidCallback? onPressed;

  /// Accessible name. Default: "Selecionar país, [countryName]".
  final String? semanticLabel;

  /// Expand icon override (InputNumber `appearance=inverse` → on-color).
  final Color? iconColor;

  final FocusNode? focusNode;
  final bool autofocus;

  /// Figma disabled root opacity (no opacity token exists).
  static const double disabledOpacity = 0.64;

  @override
  State<LooviSelectCountry> createState() => _LooviSelectCountryState();
}

class _LooviSelectCountryState extends State<LooviSelectCountry> {
  bool _focused = false;

  bool get _enabled => !widget.disabled && widget.onPressed != null;

  void _activate() {
    if (_enabled) widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final sm = widget.size == LooviSelectCountrySize.sm;
    final expanded = widget.expanded && !widget.disabled;
    final iconSize = t.spacing.s250;
    final iconColor = widget.disabled ? (widget.iconColor ?? t.text.placeholder) : (widget.iconColor ?? t.text.primary);
    final focused = _focused && !widget.disabled;

    final flag = SizedBox.square(
      dimension: iconSize,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(t.radius.full),
        child: widget.countryFlag ?? _FlagPlaceholder(code: widget.countryCode),
      ),
    );

    Widget body = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(t.radius.s300),
        border: focused ? Border.all(color: t.interactive.focus, width: t.borderWidth.s012) : null,
      ),
      child: Padding(
        padding: sm
            ? EdgeInsets.all(t.spacing.s050)
            : EdgeInsets.symmetric(horizontal: t.spacing.s200, vertical: t.spacing.s100),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            flag,
            SizedBox(width: t.spacing.s050),
            LooviIcon(
              expanded ? LooviIcons.chevronUpOutline : LooviIcons.chevronDownOutline,
              size: iconSize,
              color: iconColor,
            ),
          ],
        ),
      ),
    );
    if (widget.disabled) body = Opacity(opacity: LooviSelectCountry.disabledOpacity, child: body);

    return Semantics(
      button: true,
      enabled: _enabled,
      expanded: expanded,
      label: widget.semanticLabel ?? 'Selecionar país, ${widget.countryName}',
      excludeSemantics: true,
      onTap: _enabled ? _activate : null,
      child: FocusableActionDetector(
        enabled: _enabled,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        onShowFocusHighlight: (v) => setState(() => _focused = v),
        actions: {ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) => _activate())},
        child: LooviTapTarget(enabled: _enabled, onTap: _activate, child: body),
      ),
    );
  }
}

/// Token-painted stand-in for the Flags asset (not exported to the package).
class _FlagPlaceholder extends StatelessWidget {
  const _FlagPlaceholder({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return ColoredBox(
      color: t.color.backgroundSurface3,
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(code, maxLines: 1, style: t.typography.captionSmallMedium.copyWith(color: t.text.primary)),
        ),
      ),
    );
  }
}
