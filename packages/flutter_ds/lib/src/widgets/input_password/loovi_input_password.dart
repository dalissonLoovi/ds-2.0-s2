import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../foundation/loovi_tap_target.dart';
import '../../generated/loovi_icon_names.g.dart';
import '../input/loovi_input.dart';

/// Seed `InputPassword.visibility` — password reveal axis.
enum LooviInputPasswordVisibility {
  /// Masked value (••••), action `eye-closed-outline` + "Mostrar senha".
  hidden,

  /// Plain value, action `eye-outline` + "Ocultar senha".
  visible,
}

/// Seed `InputPassword` (Figma 3950:1701) — outlined password field.
///
/// Composes [LooviInput] (same field identity, radius
/// `component/input/field/radius` → app-cliente full) plus the
/// `visibilityAction` (Button variant=text size=sm icon-only). `state=error`
/// shows `alert-circle-outline` beside the action. The action is always
/// present; it is disabled when the field is disabled.
///
/// [visibility] null = uncontrolled (starts [LooviInputPasswordVisibility.hidden]).
class LooviInputPassword extends StatefulWidget {
  const LooviInputPassword({
    super.key,
    this.label = 'Senha',
    this.placeholder = 'Digite sua senha',
    this.supportingText,
    this.showSupportingText = true,
    this.errorText,
    this.error = false,
    this.enabled = true,
    this.appearance = LooviInputAppearance.standard,
    this.leadingIcon = true,
    this.leading = LooviIcons.lockOutline,
    this.visibility,
    this.onVisibilityChange,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.autofillHints = const [AutofillHints.password],
    this.autofocus = false,
    this.showCursor,
  });

  /// Seed `label` (default `Senha`).
  final String label;

  /// Seed `placeholder` (default `Digite sua senha`).
  final String? placeholder;
  final String? supportingText;
  final bool showSupportingText;
  final String? errorText;
  final bool error;
  final bool enabled;
  final LooviInputAppearance appearance;

  /// Seed `leadingIcon` (default true).
  final bool leadingIcon;

  /// Seed `leading` (default `lock-outline`).
  final String leading;

  /// Seed `visibility`. Null = uncontrolled.
  final LooviInputPasswordVisibility? visibility;

  /// Called with the next visibility when the action is tapped.
  final ValueChanged<LooviInputPasswordVisibility>? onVisibilityChange;

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final bool autofocus;
  final bool? showCursor;

  @override
  State<LooviInputPassword> createState() => _LooviInputPasswordState();
}

class _LooviInputPasswordState extends State<LooviInputPassword> {
  LooviInputPasswordVisibility _uncontrolled = LooviInputPasswordVisibility.hidden;

  LooviInputPasswordVisibility get _visibility => widget.visibility ?? _uncontrolled;

  void _toggle() {
    final next = _visibility == LooviInputPasswordVisibility.visible
        ? LooviInputPasswordVisibility.hidden
        : LooviInputPasswordVisibility.visible;
    if (widget.visibility == null) setState(() => _uncontrolled = next);
    widget.onVisibilityChange?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visibility == LooviInputPasswordVisibility.visible;
    return LooviInput(
      label: widget.label,
      placeholder: widget.placeholder,
      supportingText: widget.supportingText,
      showSupportingText: widget.showSupportingText,
      errorText: widget.errorText,
      error: widget.error,
      enabled: widget.enabled,
      appearance: widget.appearance,
      leadingIcon: widget.leadingIcon,
      leading: widget.leading,
      controller: widget.controller,
      focusNode: widget.focusNode,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      keyboardType: visible ? TextInputType.visiblePassword : TextInputType.text,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      autofocus: widget.autofocus,
      showCursor: widget.showCursor,
      obscureText: !visible,
      trailingAction: _VisibilityAction(
        visible: visible,
        enabled: widget.enabled,
        inverse: widget.appearance == LooviInputAppearance.inverse,
        onTap: _toggle,
      ),
    );
  }
}

/// `visibilityAction` — local Button variant=text size=sm intent=primary,
/// icon-only. Text buttons have no container fill, so only the geometry is
/// painted: padding `spacing/200` × `spacing/100`, content height
/// `spacing/250`, icon 16 (`spacing/200`), min height `spacing/500`.
/// The 48 dp target comes from [LooviTapTarget] (button is 48 wide already).
class _VisibilityAction extends StatelessWidget {
  const _VisibilityAction({required this.visible, required this.enabled, required this.inverse, required this.onTap});

  final bool visible;
  final bool enabled;
  final bool inverse;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    // Figma binds the nested Button icon to text/primary (enabled) and
    // text/secondary (disabled) — 3955:15448 / 3955:15920. Inverse: on-color.
    final color = inverse
        ? (enabled ? t.text.onColor : t.text.onColorDisabled)
        : (enabled ? t.text.primary : t.text.secondary);
    return Semantics(
      button: true,
      enabled: enabled,
      label: visible ? 'Ocultar senha' : 'Mostrar senha',
      excludeSemantics: true,
      onTap: enabled ? onTap : null,
      child: LooviTapTarget(
        enabled: enabled,
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: t.spacing.s500),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: t.spacing.s200, vertical: t.spacing.s100),
            child: SizedBox(
              height: t.spacing.s250,
              child: Center(
                widthFactor: 1,
                child: LooviIcon(
                  visible ? LooviIcons.eyeOutline : LooviIcons.eyeClosedOutline,
                  size: t.spacing.s200,
                  color: color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
