import 'dart:ui' show PathMetric;

import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

/// FileUploaderDropzoneItem (Figma 3581:5628) — tappable surface that asks the
/// app to open its file picker. The package never picks files itself: the
/// app wires [onPick] to `file_picker` / `image_picker` (or any source).
///
/// Seed `state` maps to runtime: `focus` from keyboard focus-visible;
/// `disabled` and `drag-hover` are props ([disabled], [dragHover]). There is no
/// drag-and-drop on the mobile app — [dragHover] exists for parity (web /
/// desktop hosts that do support dropping can drive it).
///
/// Paint (mode app-cliente):
/// - root: radius `border/radius/200`; stroke on the root, fill on the
///   dropzone (inside the stroke).
///   - default: fill `color/background-surface/0`, dashed stroke
///     `color/border/1` `border/width/012`.
///   - drag-hover: fill `interactive/hover`, solid stroke
///     `color/border-feedback/primary` `border/width/025`.
///   - focus: fill `color/background-surface/0`, solid stroke
///     `interactive/focus` `border/width/025`.
///   - disabled: fill `interactive/disabled-surface`, dashed stroke
///     `color/border/2` `border/width/012`.
///   - pressed (no Figma frame): fill `interactive/hover` (touch feedback).
/// - dash pattern [4, 3] (Figma geometry, no token — seed tokenRules).
/// - dropzone padding: top `spacing/300`, sides `spacing/300`, bottom
///   `spacing/800`.
/// - helperText `body/small/regular`: `text/secondary` (disabled
///   `text/placeholder`).
///
/// Accessibility: button semantics named [semanticLabel] ("Selecionar
/// arquivo") with [helperText] as hint; Enter/Space activate; disabled is not
/// focusable. The whole surface (≥ 48 dp) is the touch target.
class LooviFileUploaderDropzoneItem extends StatefulWidget {
  const LooviFileUploaderDropzoneItem({
    super.key,
    required this.onPick,
    this.helperText = 'Toque para selecionar o arquivo.',
    this.disabled = false,
    this.dragHover = false,
    this.semanticLabel = 'Selecionar arquivo',
    this.statesController,
    this.focusNode,
    this.autofocus = false,
  });

  /// Called when the surface is activated: the app opens its picker. Null =
  /// disabled (same as [disabled] = true).
  final VoidCallback? onPick;

  /// Seed `helperText`: visible instruction.
  final String helperText;

  /// Seed `state=disabled`.
  final bool disabled;

  /// Seed `state=drag-hover` (a file is being dragged over the surface).
  final bool dragHover;

  /// Accessible name (the helper text is announced as the hint).
  final String semanticLabel;

  /// Optional external interaction states. Stories and goldens can force
  /// [WidgetState.focused] (focus ring) or [WidgetState.pressed].
  final WidgetStatesController? statesController;

  final FocusNode? focusNode;
  final bool autofocus;

  /// Figma dash pattern on default | disabled (no token).
  static const List<double> dashPattern = [4, 3];

  @override
  State<LooviFileUploaderDropzoneItem> createState() => _LooviFileUploaderDropzoneItemState();
}

class _LooviFileUploaderDropzoneItemState extends State<LooviFileUploaderDropzoneItem> {
  WidgetStatesController? _internalStates;
  WidgetStatesController get _states => widget.statesController ?? (_internalStates ??= WidgetStatesController());
  bool _focusHighlight = false;

  bool get _enabled => !widget.disabled && widget.onPick != null;

  @override
  void initState() {
    super.initState();
    _states.addListener(_onStates);
  }

  @override
  void didUpdateWidget(LooviFileUploaderDropzoneItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.statesController != widget.statesController) {
      (oldWidget.statesController ?? _internalStates)?.removeListener(_onStates);
      _states.addListener(_onStates);
    }
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
    if (_enabled) widget.onPick?.call();
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final focused = _enabled && (_focusHighlight || _states.value.contains(WidgetState.focused));
    final pressed = _enabled && _states.value.contains(WidgetState.pressed);

    final Color fill;
    final Color stroke;
    final double strokeWidth;
    final bool dashed;
    final Color text;
    if (!_enabled) {
      fill = t.interactive.disabledSurface;
      stroke = t.color.border2;
      strokeWidth = t.borderWidth.s012;
      dashed = true;
      text = t.text.placeholder;
    } else if (widget.dragHover) {
      fill = t.interactive.hover;
      stroke = t.color.borderFeedbackPrimary;
      strokeWidth = t.borderWidth.s025;
      dashed = false;
      text = t.text.secondary;
    } else if (focused) {
      fill = pressed ? t.interactive.hover : t.color.backgroundSurface0;
      stroke = t.interactive.focus;
      strokeWidth = t.borderWidth.s025;
      dashed = false;
      text = t.text.secondary;
    } else {
      fill = pressed ? t.interactive.hover : t.color.backgroundSurface0;
      stroke = t.color.border1;
      strokeWidth = t.borderWidth.s012;
      dashed = true;
      text = t.text.secondary;
    }

    final radius = t.radius.s200;
    final surface = CustomPaint(
      foregroundPainter: _DropzoneStrokePainter(
        color: stroke,
        width: strokeWidth,
        radius: radius,
        dashed: dashed,
      ),
      child: DecoratedBox(
        key: const Key('loovi-dropzone-fill'),
        decoration: BoxDecoration(color: fill, borderRadius: BorderRadius.circular(radius)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(t.spacing.s300, t.spacing.s300, t.spacing.s300, t.spacing.s800),
          child: SizedBox(
            width: double.infinity,
            child: Text(widget.helperText, style: t.typography.bodySmallRegular.copyWith(color: text)),
          ),
        ),
      ),
    );

    return Semantics(
      container: true,
      button: true,
      enabled: _enabled,
      label: widget.semanticLabel,
      hint: widget.helperText,
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
          child: surface,
        ),
      ),
    );
  }
}

/// Inside stroke of the root (solid or dashed [4, 3]).
class _DropzoneStrokePainter extends CustomPainter {
  const _DropzoneStrokePainter({required this.color, required this.width, required this.radius, required this.dashed});

  final Color color;
  final double width;
  final double radius;
  final bool dashed;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius((Offset.zero & size).deflate(width / 2), Radius.circular(radius - width / 2));
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..color = color;
    final path = Path()..addRRect(rrect);
    if (!dashed) {
      canvas.drawPath(path, paint);
      return;
    }
    final dash = LooviFileUploaderDropzoneItem.dashPattern[0];
    final gap = LooviFileUploaderDropzoneItem.dashPattern[1];
    for (final PathMetric metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        final end = (d + dash).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(d, end), paint);
        d += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DropzoneStrokePainter old) =>
      old.color != color || old.width != width || old.radius != radius || old.dashed != dashed;
}
