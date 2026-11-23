import 'dart:math' as math;

import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_blend.dart';
import '../../foundation/loovi_icon.dart';
import '../../foundation/loovi_tap_target.dart';
import '../../generated/loovi_icon_names.g.dart';

/// Seed `Button.variant`.
enum LooviButtonVariant { solid, outline, text }

/// Seed `Button.size`. Heights 40 / 48 / 56 (`spacing/500|600|700`).
enum LooviButtonSize { sm, md, lg }

/// Seed `Button.intent`. `secondary` is intentional-sparse in the seed: it is
/// published only for `variant=solid, size=md`. On outline/text it paints like
/// `primary` (no frame to copy).
enum LooviButtonIntent { primary, success, danger, secondary }

/// Seed `Button.appearance` (`default | inverse`). `default` is a reserved word
/// in Dart, so the seed value `default` maps to [standard].
///
/// [inverse] is published only for `variant=outline|text` with
/// `intent=primary` (dark/brand surfaces, e.g. the Alert inverse action). On
/// any other combination it is ignored and the button paints as [standard]
/// (see [LooviButton.isInverse]).
enum LooviButtonAppearance { standard, inverse }

/// Button (Figma 3104:3723) — triggers an explicit user action.
///
/// Seed `state` maps to runtime: `pressed` from touch, `focus` from keyboard
/// focus-visible; `selected`, `disabled` and `loading` are props. `hover` is
/// not used on the app (mobile).
///
/// Paint (mode app-cliente):
/// - container: height `spacing/700|600|500` (lg|md|sm), padding-x
///   `spacing/400|300|200`, gap `spacing/200|150|100`; radius
///   `component/button/container/radius/lg` (md|lg) or `/sm` (sm) → full.
/// - solid fill + label/icon: primary `component/button/container/background`
///   + `component/button/label/color` / `icon/color`; success
///   `color/actions/success` + `text/on-color`; danger `color/actions/danger`
///   (#D81C1A, 5.12:1) + `text/on-color`; secondary `color/actions/secondary`
///   + `text/primary` (on-color was 1.8:1).
/// - outline stroke `border/width/012`: primary `color/border/1`; success
///   `color/border-feedback/success`; danger `color/border-feedback/danger`.
/// - outline/text label (TEXT): success `text/success`, danger `text/danger`
///   (AA); the leading/trailing icon next to it keeps `feedback/success` /
///   `color/actions/danger` (seed `feedbackColorRule`).
/// - appearance=inverse (outline|text + primary only): label, icons and the
///   outline stroke `text/on-color`; disabled `text/on-color-disabled`;
///   pressed fill `color/elevation/inverse-4`; focus keeps
///   `interactive/focus`. Loading (no inverse frame): indicator `text/on-color`.
/// - solid hover / selected / pressed (all intents): the fill darkens toward
///   `interactive/overlay` — 8 % / 12 % / 16 % alpha blend over the base
///   (seed tokenRules; Figma draws it as interactive/* LINEAR_BURN layers).
///   Hover only when a pointer reports it (no hover on the mobile app).
///   Outline/text get the `interactive/pressed|selected` fill directly.
/// - focus (keyboard): inner `effects/effect/focus` (4 spread) under a
///   `border/width/025` stroke of `interactive/focus`.
/// - loading: spinner-only, square when hugging (56/48/40); spinner 24/24/20
///   (track `color/background-surface/3`, indicator = intent fill). The
///   spinner is drawn here (internal) rather than via the seed LoadingSpinner.
class LooviButton extends StatefulWidget {
  const LooviButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = LooviButtonVariant.solid,
    this.size = LooviButtonSize.md,
    this.intent = LooviButtonIntent.primary,
    this.appearance = LooviButtonAppearance.standard,
    this.showLabel = true,
    this.showIcon = false,
    this.leadingIcon = LooviIcons.plusOutline,
    this.showTrailingIcon = false,
    this.trailingIcon = LooviIcons.chevronRightOutline,
    this.loading = false,
    this.disabled = false,
    this.selected = false,
    this.fullWidth = false,
    this.semanticLabel,
    this.loadingSemanticValue = 'Carregando',
    this.statesController,
    this.focusNode,
    this.autofocus = false,
  });

  /// Visible label (seed `label`). Also the accessible name when the label is
  /// hidden ([showLabel] = false) or while [loading].
  final String label;

  /// Tap callback. Null = disabled (same as [disabled] = true).
  final VoidCallback? onPressed;

  final LooviButtonVariant variant;
  final LooviButtonSize size;
  final LooviButtonIntent intent;

  /// Seed `appearance`. [LooviButtonAppearance.inverse] applies only to
  /// `variant=outline|text` + `intent=primary`; ignored otherwise.
  final LooviButtonAppearance appearance;

  /// Whether the inverse paint is in effect (seed-published combination).
  bool get isInverse =>
      appearance == LooviButtonAppearance.inverse &&
      variant != LooviButtonVariant.solid &&
      intent == LooviButtonIntent.primary;

  /// Seed `showLabel`.
  final bool showLabel;

  /// Seed `showIcon` — toggles [leadingIcon].
  final bool showIcon;

  /// Seed `Icon` (INSTANCE_SWAP for leadingIcon): lg 24, md 20, sm 16.
  final String leadingIcon;

  /// Seed `showTrailingIcon`.
  final bool showTrailingIcon;

  /// Seed `trailingIcon` (default chevron-right-outline): lg|md 24, sm 16.
  final String trailingIcon;

  /// Seed `state=loading`: spinner-only, blocks activation, busy semantics.
  final bool loading;

  /// Seed `disabled=true`.
  final bool disabled;

  /// Seed `state=selected` (toggle / segmented contexts only).
  final bool selected;

  /// Fill the available width (Figma "fill"). Default hugs content.
  final bool fullWidth;

  /// Overrides the accessible name (defaults to [label]).
  final String? semanticLabel;

  /// Semantics value announced while [loading] (Flutter has no aria-busy).
  final String loadingSemanticValue;

  /// Optional external interaction states (like Material buttons). Stories and
  /// goldens can force [WidgetState.pressed] or [WidgetState.focused] (focus ring).
  final WidgetStatesController? statesController;

  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<LooviButton> createState() => _LooviButtonState();
}

/// Resolved paint of one button state.
class _ButtonPaint {
  const _ButtonPaint({required this.fill, required this.border, required this.label, required this.icon});
  final Color? fill;
  final Color? border;
  final Color label;
  final Color icon;
}

class _LooviButtonState extends State<LooviButton> {
  WidgetStatesController? _internalStates;
  WidgetStatesController get _states => widget.statesController ?? (_internalStates ??= WidgetStatesController());
  bool _focusHighlight = false;

  bool get _disabled => widget.onPressed == null || widget.disabled;
  bool get _interactive => !_disabled && !widget.loading;

  @override
  void initState() {
    super.initState();
    _states.addListener(_onStates);
    _syncStates();
  }

  @override
  void didUpdateWidget(LooviButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.statesController != widget.statesController) {
      (oldWidget.statesController ?? _internalStates)?.removeListener(_onStates);
      _states.addListener(_onStates);
    }
    _syncStates();
  }

  void _syncStates() {
    _states.update(WidgetState.disabled, !_interactive);
    _states.update(WidgetState.selected, widget.selected);
    if (!_interactive) {
      _states.update(WidgetState.pressed, false);
      _states.update(WidgetState.hovered, false);
    }
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
    if (_interactive) _states.update(WidgetState.pressed, v);
  }

  void _activate() {
    if (_interactive) widget.onPressed?.call();
  }

  /// Solid fill / outline-text content color of the enabled intent.
  Color _intentColor(LooviTokens t) => switch (widget.intent) {
        LooviButtonIntent.primary => t.component.button.containerBackground,
        // Figma rebound feedback/success → color/actions/success (2026-11-23).
        LooviButtonIntent.success => t.color.actionsSuccess,
        LooviButtonIntent.danger => t.color.actionsDanger,
        LooviButtonIntent.secondary => t.color.actionsSecondary,
      };

  _ButtonPaint _resolve(LooviTokens t) {
    final s = _states.value;
    // Loading frames exist only with disabled=false: paint enabled colors.
    final disabled = _disabled && !widget.loading;
    final intent = widget.intent;
    final isPrimaryLike = intent == LooviButtonIntent.primary || intent == LooviButtonIntent.secondary;

    if (widget.variant == LooviButtonVariant.solid) {
      if (disabled) {
        return switch (intent) {
          LooviButtonIntent.success => _ButtonPaint(
              fill: t.color.backgroundFeedbackSecondarySuccess, border: null, label: t.text.placeholder, icon: t.text.placeholder),
          LooviButtonIntent.danger => _ButtonPaint(
              fill: t.interactive.errorSurface, border: null, label: t.color.backgroundSurface0, icon: t.color.backgroundSurface0),
          _ => _ButtonPaint(fill: t.interactive.disabledSurface, border: null, label: t.text.placeholder, icon: t.text.placeholder),
        };
      }
      final base = _intentColor(t);
      final LooviStateLayer? layer = s.contains(WidgetState.pressed)
          ? LooviStateLayer.pressed
          : s.contains(WidgetState.selected)
              ? LooviStateLayer.selected
              : s.contains(WidgetState.hovered)
                  ? LooviStateLayer.hover
                  : null;
      final fill = layer == null ? base : looviStateLayer(t, base, layer);
      final Color label;
      final Color icon;
      switch (intent) {
        case LooviButtonIntent.secondary:
          // color/actions/secondary (lavender-1) + text/primary (9.1:1).
          label = t.text.primary;
          icon = t.text.primary;
        case LooviButtonIntent.danger:
        case LooviButtonIntent.success:
          // actions/success | actions/danger + text/on-color (AA).
          label = t.text.onColor;
          icon = t.text.onColor;
        case LooviButtonIntent.primary:
          label = t.component.button.labelColor;
          icon = t.component.button.iconColor;
      }
      return _ButtonPaint(fill: fill, border: null, label: label, icon: icon);
    }

    final outline = widget.variant == LooviButtonVariant.outline;
    if (widget.isInverse) {
      if (disabled) {
        final c = t.text.onColorDisabled;
        return _ButtonPaint(fill: null, border: outline ? c : null, label: c, icon: c);
      }
      final c = t.text.onColor;
      // Published states: default | pressed | focus (no selected frame).
      return _ButtonPaint(
        fill: s.contains(WidgetState.pressed) ? t.color.elevationInverse4 : null,
        border: outline ? c : null,
        label: c,
        icon: c,
      );
    }
    if (disabled) {
      final content = isPrimaryLike
          ? t.text.placeholder
          : intent == LooviButtonIntent.danger
              ? t.interactive.errorSurface
              : t.interactive.successSurface;
      final border = isPrimaryLike ? t.color.border1 : t.color.border2;
      return _ButtonPaint(fill: null, border: outline ? border : null, label: content, icon: content);
    }
    final Color? fill = s.contains(WidgetState.pressed)
        ? t.interactive.pressed
        : s.contains(WidgetState.selected)
            ? t.interactive.selected
            : null;
    // Status label is TEXT → text/{status} (AA). The leading icon always sits
    // next to the label → feedback/success | actions/danger (Figma binding).
    final Color label;
    final Color icon;
    final Color border;
    switch (intent) {
      case LooviButtonIntent.success:
        label = t.text.success;
        icon = t.feedback.success;
        border = t.color.borderFeedbackSuccess;
      case LooviButtonIntent.danger:
        label = t.text.danger;
        icon = t.color.actionsDanger;
        border = t.color.borderFeedbackDanger;
      case LooviButtonIntent.primary:
      case LooviButtonIntent.secondary:
        // text + primary: leadingIcon uses text/primary across states (seed rule).
        label = t.text.primary;
        icon = t.text.primary;
        border = t.color.border1;
    }
    return _ButtonPaint(fill: fill, border: outline ? border : null, label: label, icon: icon);
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final p = _resolve(t);

    final (height, padX, gap, contentGap, leadSize, trailSize, spinnerSize, labelStyle) = switch (widget.size) {
      LooviButtonSize.lg => (
          t.spacing.s700,
          t.spacing.s400,
          t.spacing.s200,
          t.spacing.s100,
          t.spacing.s300,
          t.spacing.s300,
          t.spacing.s300,
          t.typography.bodyLargeMedium,
        ),
      LooviButtonSize.md => (
          t.spacing.s600,
          t.spacing.s300,
          t.spacing.s150,
          t.spacing.s100,
          t.spacing.s250,
          t.spacing.s300,
          t.spacing.s300,
          t.typography.bodyMediumMedium,
        ),
      LooviButtonSize.sm => (
          t.spacing.s500,
          t.spacing.s200,
          t.spacing.s100,
          t.spacing.s050,
          t.spacing.s200,
          t.spacing.s200,
          t.spacing.s250,
          t.typography.bodySmallMedium,
        ),
    };
    final radius = BorderRadius.circular(
      widget.size == LooviButtonSize.sm ? t.component.button.containerRadiusSm : t.component.button.containerRadiusLg,
    );

    Widget content;
    if (widget.loading) {
      content = _LooviButtonSpinner(
        size: spinnerSize,
        track: t.color.backgroundSurface3,
        indicator: widget.isInverse ? t.text.onColor : _intentColor(t),
      );
    } else {
      final children = <Widget>[
        if (widget.showIcon) LooviIcon(widget.leadingIcon, size: leadSize, color: p.icon),
        if (widget.showIcon && widget.showLabel) SizedBox(width: contentGap),
        if (widget.showLabel)
          Flexible(
            child: Text(
              widget.label,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: labelStyle.copyWith(color: p.label, fontWeight: t.component.button.labelFontWeight),
            ),
          ),
      ];
      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(child: Row(mainAxisSize: MainAxisSize.min, children: children)),
          if (widget.showTrailingIcon) ...[
            SizedBox(width: gap),
            LooviIcon(widget.trailingIcon, size: trailSize, color: p.icon),
          ],
        ],
      );
      content = Padding(padding: EdgeInsets.symmetric(horizontal: padX), child: content);
    }

    Widget container = DecoratedBox(
      decoration: BoxDecoration(
        color: p.fill,
        borderRadius: radius,
        border: p.border == null ? null : Border.all(color: p.border!, width: t.borderWidth.s012),
      ),
      child: ConstrainedBox(
        constraints: widget.loading && !widget.fullWidth
            ? BoxConstraints.tightFor(width: height, height: height)
            : BoxConstraints(minHeight: height, minWidth: widget.fullWidth ? double.infinity : 0),
        child: Center(widthFactor: widget.fullWidth ? null : 1, heightFactor: 1, child: content),
      ),
    );

    if ((_focusHighlight || _states.value.contains(WidgetState.focused)) && _interactive) {
      // Figma focusRingContainer: inner effects/effect/focus (spread 4) drawn
      // from the outer edge, then the interactive/focus stroke on top.
      final focusEffect = t.effects.effectFocus.first;
      container = DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(color: t.interactive.focus, width: t.borderWidth.s025),
        ),
        child: DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: focusEffect.color, width: focusEffect.spread),
          ),
          child: container,
        ),
      );
    }

    final min = LooviTapTarget.minSize(context);
    return Semantics(
      container: true,
      button: true,
      enabled: _interactive,
      selected: widget.selected ? true : null,
      label: widget.semanticLabel ?? widget.label,
      value: widget.loading ? widget.loadingSemanticValue : null,
      liveRegion: widget.loading ? true : null,
      onTap: _interactive ? _activate : null,
      excludeSemantics: true,
      child: FocusableActionDetector(
        enabled: _interactive,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        onShowFocusHighlight: (v) => setState(() => _focusHighlight = v),
        // Pointer hover only (web / desktop); touch devices never report it.
        onShowHoverHighlight: (v) => _states.update(WidgetState.hovered, v && _interactive),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {
            _activate();
            return null;
          }),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _interactive ? _activate : null,
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          // Touch target >= 48 (spacing/600). sm paints 40 tall; hit area grows outside.
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: min, minHeight: min),
            child: Center(
              widthFactor: widget.fullWidth ? null : 1,
              heightFactor: 1,
              child: container,
            ),
          ),
        ),
      ),
    );
  }
}

/// Indeterminate spinner of the Button loading frames (Figma LoadingSpinner
/// instance 3133:4033): full track ring + a quarter-arc indicator from 12 to
/// 3 o'clock, rotating. Static when animations are disabled.
class _LooviButtonSpinner extends StatefulWidget {
  const _LooviButtonSpinner({required this.size, required this.track, required this.indicator});
  final double size;
  final Color track;
  final Color indicator;

  @override
  State<_LooviButtonSpinner> createState() => _LooviButtonSpinnerState();
}

class _LooviButtonSpinnerState extends State<_LooviButtonSpinner> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (reduceMotion) {
      _controller.stop();
      _controller.value = 0;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: RotationTransition(
        turns: _controller,
        child: CustomPaint(
          size: Size.square(widget.size),
          painter: _SpinnerPainter(track: widget.track, indicator: widget.indicator),
        ),
      ),
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  const _SpinnerPainter({required this.track, required this.indicator});
  final Color track;
  final Color indicator;

  // Stroke ≈ 1/6 of the spinner box (4 px at 24, as measured in the frame).
  static const double _strokeFactor = 1 / 6;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.shortestSide * _strokeFactor;
    final rect = (Offset.zero & size).deflate(stroke / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(rect, 0, 2 * math.pi, false, paint..color = track);
    canvas.drawArc(rect, -math.pi / 2, math.pi / 2, false, paint..color = indicator);
  }

  @override
  bool shouldRepaint(_SpinnerPainter old) => old.track != track || old.indicator != indicator;
}
