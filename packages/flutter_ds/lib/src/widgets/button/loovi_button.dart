import 'dart:math' as math;

import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

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
/// - solid fill: primary `component/button/container/background`; success
///   `feedback/success`; danger `color/actions/danger`; secondary
///   `color/actions/secondary`.
/// - outline stroke `border/width/012`: primary `color/border/1`; success
///   `color/border-feedback/success`; danger `color/border-feedback/danger`.
/// - pressed / selected: `interactive/pressed|selected` composited over the
///   solid fill with Plus Darker (LINEAR_BURN); outline/text get the
///   interactive fill directly. Secondary has no pressed overlay in Figma.
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

/// Plus Darker / LINEAR_BURN of two opaque colors: `dst + src - 1` per channel.
/// Flutter has no LINEAR_BURN BlendMode; with opaque token colors the result is
/// exact, so it is resolved here instead of via a compositing layer.
Color _plusDarker(Color dst, Color src) => Color.from(
      alpha: dst.a,
      red: (dst.r + src.r - 1).clamp(0, 1).toDouble(),
      green: (dst.g + src.g - 1).clamp(0, 1).toDouble(),
      blue: (dst.b + src.b - 1).clamp(0, 1).toDouble(),
    );

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
    if (!_interactive) _states.update(WidgetState.pressed, false);
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
        LooviButtonIntent.success => t.feedback.success,
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
      final Color? overlay = intent == LooviButtonIntent.secondary
          ? null // Figma 3942:24936 (pressed) has no overlay.
          : s.contains(WidgetState.pressed)
              ? t.interactive.pressed
              : s.contains(WidgetState.selected)
                  ? t.interactive.selected
                  : null;
      final fill = overlay == null ? base : _plusDarker(base, overlay);
      final Color label;
      final Color icon;
      switch (intent) {
        case LooviButtonIntent.danger:
          label = t.color.backgroundSurface0;
          icon = t.color.backgroundSurface0;
        case LooviButtonIntent.secondary:
          label = t.text.onColor;
          icon = t.text.onColor;
        case LooviButtonIntent.primary:
        case LooviButtonIntent.success:
          label = t.component.button.labelColor;
          icon = t.component.button.iconColor;
      }
      return _ButtonPaint(fill: fill, border: null, label: label, icon: icon);
    }

    final outline = widget.variant == LooviButtonVariant.outline;
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
    final Color content;
    final Color border;
    switch (intent) {
      case LooviButtonIntent.success:
        content = t.feedback.success;
        border = t.color.borderFeedbackSuccess;
      case LooviButtonIntent.danger:
        content = t.color.actionsDanger;
        border = t.color.borderFeedbackDanger;
      case LooviButtonIntent.primary:
      case LooviButtonIntent.secondary:
        // text + primary: leadingIcon uses text/primary across states (seed rule).
        content = t.text.primary;
        border = t.color.border1;
    }
    return _ButtonPaint(fill: fill, border: outline ? border : null, label: content, icon: content);
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
        indicator: _intentColor(t),
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
