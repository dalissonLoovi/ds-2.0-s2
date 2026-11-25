import 'package:flutter/semantics.dart' show SemanticsValidationResult;
import 'package:flutter/services.dart';
import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_tap_target.dart';
import '../input/loovi_input.dart';
import '../slider_base_item/loovi_slider_base_item.dart';
import '../slider_item/loovi_slider_item.dart';
import '../slider_skeleton_item/loovi_slider_skeleton_item.dart';

/// Slider (Figma 3950:7327) — adjustable numeric value: horizontal track with
/// min / max labels plus a numeric Input that mirrors (and edits) the value.
///
/// Seed `status` is split as the Definition of Done asks:
/// - `enabled` = default; `hover` does not exist on the app;
/// - `focus` / `active` = runtime: keyboard focus on the track, dragging, or
///   focus in the Input → endCap 20 (SliderItem `active=true`) and Input focus;
/// - `error` = [errorText] non-null (Input `state=error` + message);
/// - `warning` = [warningText] non-null (Input default + message);
/// - `disabled` = [enabled] false; `read-only` = [readOnly] (default paint,
///   no interaction); `skeleton` = [skeleton] (swaps to SliderSkeletonItem).
///
/// Paint (mode app-cliente):
/// - root: column; with a message, gap `spacing/100` before it.
/// - [LooviSliderBaseItem]: label `caption/large/regular` `text/secondary`,
///   min/max `body/medium/regular` `text/primary` (disabled
///   `text/placeholder`); sliderRow gap `spacing/200`.
/// - track: [LooviSliderItem] (filled `color/actions/primary`, residual
///   `color/border/2`, endCap 14 / 20, middle tick `color/border/2`). Figma
///   keeps the primary fill on `status=disabled` too.
/// - Input: `LooviInput` (content=value, no icons, appearance=default),
///   label = [label]; error → Input `state=error`.
/// - errorText / warningText: `body/small/regular`, `text/danger` /
///   `text/warning` (AA; seed rebound from feedback/* on 2026-11-23).
///
/// Interaction: drag or tap anywhere on the 48 dp tall track area; keyboard
/// arrows (±[step]), Home / End (min / max) when the track has focus; typing
/// in the Input updates the value (clamped and snapped) live, and the text is
/// normalized when the Input loses focus or is submitted. No haptics.
///
/// Accessibility: the track is a `slider` semantics node named by [label],
/// with value / increased / decreased values and increase / decrease actions;
/// the message is its hint (errors also set `validationResult: invalid`).
/// Skeleton exposes [label] with the [loadingSemanticLabel] hint.
class LooviSlider extends StatefulWidget {
  const LooviSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0,
    this.max = 100,
    this.step = 1,
    this.label = 'Label',
    this.minValue,
    this.maxValue,
    this.errorText,
    this.warningText,
    this.enabled = true,
    this.readOnly = false,
    this.skeleton = false,
    this.valueFormatter,
    this.focusNode,
    this.autofocus = false,
    this.loadingSemanticLabel = 'Carregando',
  }) : assert(max > min, 'max must be greater than min');

  /// Current value (controlled). Clamped to [min]..[max] for paint.
  final double value;

  /// New value while dragging / typing / using the keyboard. Null makes the
  /// slider non-interactive (paint stays enabled; use [enabled] to disable).
  final ValueChanged<double>? onChanged;

  final ValueChanged<double>? onChangeStart;

  /// Final value after a drag, a tap, a key press or an Input commit.
  final ValueChanged<double>? onChangeEnd;

  final double min;
  final double max;

  /// Value increment for snapping and keyboard (null or ≤ 0 = continuous,
  /// keyboard moves 1 % of the range). Not in the seed: the Figma Input shows
  /// integers, hence the default 1.
  final double? step;

  /// Seed `label` (SliderBaseItem) — visible label, Input label and
  /// accessible name.
  final String label;

  /// Seed `minValue` (SliderBaseItem). Defaults to the formatted [min].
  final String? minValue;

  /// Seed `maxValue` (SliderBaseItem). Defaults to the formatted [max].
  final String? maxValue;

  /// Seed `errorText` — non-null = `status=error`.
  final String? errorText;

  /// Seed `warningText` — non-null = `status=warning` (error wins).
  final String? warningText;

  /// `false` = seed `status=disabled`.
  final bool enabled;

  /// Seed `status=read-only`: default paint, value cannot change.
  final bool readOnly;

  /// Seed `status=skeleton`: shows [LooviSliderSkeletonItem].
  final bool skeleton;

  /// Text for the Input, min / max labels and semantics. Default: integer
  /// when whole, otherwise the decimals of [step].
  final String Function(double value)? valueFormatter;

  /// Focus node of the track (keyboard control).
  final FocusNode? focusNode;
  final bool autofocus;

  /// Hint announced while [skeleton].
  final String loadingSemanticLabel;

  @override
  State<LooviSlider> createState() => _LooviSliderState();
}

class _AdjustIntent extends Intent {
  const _AdjustIntent(this.direction);

  /// -1 / +1 (logical: down / up).
  final int direction;
}

class _PhysicalAdjustIntent extends Intent {
  const _PhysicalAdjustIntent(this.direction);

  /// -1 = physical left, +1 = physical right.
  final int direction;
}

class _JumpIntent extends Intent {
  const _JumpIntent({required this.toMax});
  final bool toMax;
}

class _LooviSliderState extends State<LooviSlider> {
  final TextEditingController _input = TextEditingController();
  final FocusNode _inputFocus = FocusNode(debugLabel: 'LooviSlider input');
  bool _trackFocused = false;
  bool _dragging = false;
  bool _editing = false;
  double _trackWidth = 0;
  late double _latest;

  bool get _interactive => widget.enabled && !widget.readOnly && widget.onChanged != null;

  double get _clampedValue => widget.value.clamp(widget.min, widget.max).toDouble();

  double get _keyStep {
    final s = widget.step;
    return (s == null || s <= 0) ? (widget.max - widget.min) / 100 : s;
  }

  @override
  void initState() {
    super.initState();
    _latest = _clampedValue;
    _input.text = _format(_clampedValue);
    _inputFocus.addListener(_onInputFocus);
  }

  @override
  void didUpdateWidget(LooviSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    _latest = _clampedValue;
    if (!_inputFocus.hasFocus) {
      final text = _format(_clampedValue);
      if (_input.text != text) _input.text = text;
    }
  }

  @override
  void dispose() {
    _inputFocus.removeListener(_onInputFocus);
    _inputFocus.dispose();
    _input.dispose();
    super.dispose();
  }

  String _format(double v) {
    final f = widget.valueFormatter;
    if (f != null) return f(v);
    if (v == v.roundToDouble()) return v.toInt().toString();
    final s = widget.step;
    final decimals = (s == null || s <= 0 || s == s.roundToDouble())
        ? 2
        : (s.toString().split('.').elementAtOrNull(1)?.length ?? 2);
    return v.toStringAsFixed(decimals);
  }

  double _snap(double raw) {
    final min = widget.min;
    final max = widget.max;
    var v = raw.clamp(min, max).toDouble();
    final s = widget.step;
    if (s != null && s > 0) {
      v = (min + ((v - min) / s).round() * s).clamp(min, max).toDouble();
    }
    return v;
  }

  void _emit(double raw) {
    if (!_interactive) return;
    final v = _snap(raw);
    if (v == _latest) return;
    _latest = v;
    widget.onChanged!(v);
  }

  void _adjust(int direction) {
    if (!_interactive) return;
    widget.onChangeStart?.call(_latest);
    _emit(_latest + direction * _keyStep);
    widget.onChangeEnd?.call(_latest);
  }

  void _jump({required bool toMax}) {
    if (!_interactive) return;
    widget.onChangeStart?.call(_latest);
    _emit(toMax ? widget.max : widget.min);
    widget.onChangeEnd?.call(_latest);
  }

  double _valueAt(double dx) {
    if (_trackWidth <= 0) return _latest;
    var f = (dx / _trackWidth).clamp(0.0, 1.0);
    if (Directionality.of(context) == TextDirection.rtl) f = 1 - f;
    return widget.min + f * (widget.max - widget.min);
  }

  void _onDragStart(DragStartDetails d) {
    if (!_interactive) return;
    setState(() => _dragging = true);
    widget.onChangeStart?.call(_latest);
    _emit(_valueAt(d.localPosition.dx));
  }

  void _onDragUpdate(DragUpdateDetails d) {
    if (!_dragging) return;
    _emit(_valueAt(d.localPosition.dx));
  }

  void _onDragEnd() {
    if (!_dragging) return;
    setState(() => _dragging = false);
    widget.onChangeEnd?.call(_latest);
  }

  void _onTapUp(TapUpDetails d) {
    if (!_interactive) return;
    widget.onChangeStart?.call(_latest);
    _emit(_valueAt(d.localPosition.dx));
    widget.onChangeEnd?.call(_latest);
  }

  void _onInputChanged(String text) {
    final parsed = double.tryParse(text.trim().replaceAll(',', '.'));
    if (parsed == null || !parsed.isFinite) return;
    if (!_editing) {
      _editing = true;
      widget.onChangeStart?.call(_latest);
    }
    _emit(parsed);
  }

  void _commitInput() {
    final text = _format(_latest);
    if (_input.text != text) _input.text = text;
    if (_editing) {
      _editing = false;
      widget.onChangeEnd?.call(_latest);
    }
  }

  void _onInputFocus() {
    if (!_inputFocus.hasFocus) _commitInput();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);

    if (widget.skeleton) {
      return Semantics(
        container: true,
        label: widget.label,
        hint: widget.loadingSemanticLabel,
        child: const LooviSliderSkeletonItem(),
      );
    }

    final hasError = widget.errorText != null;
    final message = widget.errorText ?? widget.warningText;
    final value = _clampedValue;
    final fraction = (value - widget.min) / (widget.max - widget.min);
    final interactive = _interactive;
    final active = interactive && (_dragging || _trackFocused || _inputFocus.hasFocus);
    final rtl = Directionality.of(context) == TextDirection.rtl;

    final track = Semantics(
      container: true,
      slider: true,
      label: widget.label,
      value: _format(value),
      increasedValue: _format(_snap(value + _keyStep)),
      decreasedValue: _format(_snap(value - _keyStep)),
      hint: message,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      focused: _trackFocused,
      validationResult: hasError ? SemanticsValidationResult.invalid : SemanticsValidationResult.none,
      onIncrease: interactive ? () => _adjust(1) : null,
      onDecrease: interactive ? () => _adjust(-1) : null,
      child: ExcludeSemantics(
        child: FocusableActionDetector(
          enabled: widget.enabled,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          onFocusChange: (f) => setState(() => _trackFocused = f),
          shortcuts: const {
            SingleActivator(LogicalKeyboardKey.arrowUp): _AdjustIntent(1),
            SingleActivator(LogicalKeyboardKey.arrowDown): _AdjustIntent(-1),
            SingleActivator(LogicalKeyboardKey.arrowRight): _PhysicalAdjustIntent(1),
            SingleActivator(LogicalKeyboardKey.arrowLeft): _PhysicalAdjustIntent(-1),
            SingleActivator(LogicalKeyboardKey.home): _JumpIntent(toMax: false),
            SingleActivator(LogicalKeyboardKey.end): _JumpIntent(toMax: true),
          },
          actions: {
            _AdjustIntent: CallbackAction<_AdjustIntent>(onInvoke: (i) => _adjust(i.direction)),
            _PhysicalAdjustIntent: CallbackAction<_PhysicalAdjustIntent>(
              onInvoke: (i) => _adjust(rtl ? -i.direction : i.direction),
            ),
            _JumpIntent: CallbackAction<_JumpIntent>(onInvoke: (i) => _jump(toMax: i.toMax)),
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              _trackWidth = constraints.maxWidth;
              return GestureDetector(
                key: const ValueKey('loovi-slider-track'),
                behavior: HitTestBehavior.opaque,
                onTapUp: interactive ? _onTapUp : null,
                onHorizontalDragStart: interactive ? _onDragStart : null,
                onHorizontalDragUpdate: interactive ? _onDragUpdate : null,
                onHorizontalDragEnd: interactive ? (_) => _onDragEnd() : null,
                onHorizontalDragCancel: interactive ? _onDragEnd : null,
                child: ConstrainedBox(
                  // 48 dp touch target around the 20 dp track.
                  constraints: BoxConstraints(minHeight: LooviTapTarget.minSize(context)),
                  child: Center(child: LooviSliderItem(active: active, fraction: fraction)),
                ),
              );
            },
          ),
        ),
      ),
    );

    Widget input = LooviInput(
      label: widget.label,
      controller: _input,
      focusNode: _inputFocus,
      enabled: widget.enabled,
      error: hasError,
      showSupportingText: false,
      keyboardType: TextInputType.numberWithOptions(
        decimal: !(widget.step != null && widget.step! > 0 && widget.step! == widget.step!.roundToDouble()),
        signed: widget.min < 0,
      ),
      textInputAction: TextInputAction.done,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,\-]'))],
      onChanged: _onInputChanged,
      onSubmitted: (_) => _commitInput(),
    );
    if (widget.readOnly || widget.onChanged == null) {
      // Input has no read-only state (seed): default paint, no editing. The
      // value is announced by the slider node.
      input = IgnorePointer(child: ExcludeFocus(child: ExcludeSemantics(child: input)));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LooviSliderBaseItem(
          label: widget.label,
          minValue: widget.minValue ?? _format(widget.min),
          maxValue: widget.maxValue ?? _format(widget.max),
          disabled: !widget.enabled,
          sliderItem: track,
          input: input,
        ),
        if (message != null) ...[
          SizedBox(height: t.spacing.s100),
          ExcludeSemantics(
            child: Text(
              message,
              style: t.typography.bodySmallRegular.copyWith(color: hasError ? t.text.danger : t.text.warning),
            ),
          ),
        ],
      ],
    );
  }
}
