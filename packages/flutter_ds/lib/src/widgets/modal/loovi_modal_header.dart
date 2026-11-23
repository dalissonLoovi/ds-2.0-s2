import 'dart:math' as math;

import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../foundation/loovi_tap_target.dart';
import '../../generated/loovi_icon_names.g.dart';

/// Seed `ModalHeader.layout`. Maps from `Modal.platform`:
/// web → [desktop]; mobile | mobile-landscape → [mobile].
enum LooviModalHeaderLayout { desktop, mobile }

/// Seed `ModalHeader.alignment` (default [start]).
enum LooviModalHeaderAlignment { start, center }

/// ModalHeader (Figma 3786:9403) — header block used only inside [LooviModal].
///
/// Paint (mode app-cliente):
/// - root: padding `spacing/200` (mobile) | left `spacing/300`, right
///   `spacing/0`, vertical `spacing/200` (desktop); gap `spacing/100`;
///   cross-axis start (component master).
/// - headingContent: gap `spacing/050`; label `body/small/regular` +
///   `text/secondary`; title `heading/h3/semi-bold` (mobile) |
///   `heading/h1/semi-bold` (desktop) + `text/primary`.
/// - closeAction (Button text/sm/primary + x-outline 16 = `spacing/200`):
///   fill `component/modal-header/close-action/background` (surface/2),
///   radius `component/modal-header/close-action/radius` (full), size
///   `component/modal-header/close-action/size-mobile` (32) on mobile,
///   `spacing/500` (40) on desktop. Pressed → `interactive/pressed`.
/// - alignment=center: leadingSpacer with the close width (optical centering).
///
/// Touch target: the close paints at the token size and its hit area grows to
/// 48 (`spacing/600`). The extra area eats into the header padding/gap, so the
/// painted geometry matches the frame (where the padding allows it).
class LooviModalHeader extends StatelessWidget {
  const LooviModalHeader({
    super.key,
    required this.title,
    this.layout = LooviModalHeaderLayout.mobile,
    this.alignment = LooviModalHeaderAlignment.start,
    this.label = '',
    this.showLabel = false,
    this.showCloseAction = true,
    this.onClose,
    this.closeSemanticLabel = 'Fechar modal',
    this.closeStatesController,
  });

  /// Seed `title` — modal heading (header semantics; names the dialog route).
  final String title;

  final LooviModalHeaderLayout layout;
  final LooviModalHeaderAlignment alignment;

  /// Seed `label` — optional supporting label above the title.
  final String label;

  /// Seed `showLabel`.
  final bool showLabel;

  /// Seed `showCloseAction`.
  final bool showCloseAction;

  /// Close tap. Null keeps the chip visible but inert.
  final VoidCallback? onClose;

  /// Accessible name of the icon-only close (seed: "Fechar modal").
  final String closeSemanticLabel;

  /// Optional external states (stories/goldens can force pressed/focused).
  final WidgetStatesController? closeStatesController;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final mobile = layout == LooviModalHeaderLayout.mobile;
    final center = alignment == LooviModalHeaderAlignment.center;

    final pad = mobile
        ? EdgeInsets.all(t.spacing.s200)
        : EdgeInsets.fromLTRB(t.spacing.s300, t.spacing.s200, t.spacing.s0, t.spacing.s200);
    final gap = t.spacing.s100;
    final closeSize = mobile ? t.component.modalHeader.closeActionSizeMobile : t.spacing.s500;
    final target = LooviTapTarget.minSize(context);
    // Half of the hit-area growth around the painted close.
    final inset = showCloseAction ? math.max(t.spacing.s0, (target - closeSize) / 2) : t.spacing.s0;

    final heading = Column(
      crossAxisAlignment: center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel) ...[
          Text(
            label,
            textAlign: center ? TextAlign.center : TextAlign.start,
            style: t.typography.bodySmallRegular.copyWith(color: t.text.secondary),
          ),
          SizedBox(height: t.spacing.s050),
        ],
        Semantics(
          container: true,
          header: true,
          child: Text(
            title,
            textAlign: center ? TextAlign.center : TextAlign.start,
            style: (mobile ? t.typography.headingH3SemiBold : t.typography.headingH1SemiBold)
                .copyWith(color: t.text.primary),
          ),
        ),
      ],
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(
        pad.left,
        math.max(t.spacing.s0, pad.top - inset),
        math.max(t.spacing.s0, pad.right - inset),
        math.max(t.spacing.s0, pad.bottom - inset),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (center && showCloseAction) ...[
            SizedBox(width: closeSize),
            SizedBox(width: gap),
          ],
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: inset),
              child: heading,
            ),
          ),
          if (showCloseAction) ...[
            SizedBox(width: math.max(t.spacing.s0, gap - inset)),
            _ModalCloseAction(
              size: closeSize,
              onPressed: onClose,
              semanticLabel: closeSemanticLabel,
              statesController: closeStatesController,
            ),
          ],
        ],
      ),
    );
  }
}

/// Icon-only close chip of ModalHeader (seed: Button text/sm/primary +
/// x-outline). Painted at [size], hit area >= 48.
class _ModalCloseAction extends StatefulWidget {
  const _ModalCloseAction({
    required this.size,
    required this.onPressed,
    required this.semanticLabel,
    this.statesController,
  });

  final double size;
  final VoidCallback? onPressed;
  final String semanticLabel;
  final WidgetStatesController? statesController;

  @override
  State<_ModalCloseAction> createState() => _ModalCloseActionState();
}

class _ModalCloseActionState extends State<_ModalCloseAction> {
  WidgetStatesController? _internal;
  WidgetStatesController get _states => widget.statesController ?? (_internal ??= WidgetStatesController());
  bool _focusHighlight = false;

  bool get _enabled => widget.onPressed != null;

  @override
  void initState() {
    super.initState();
    _states.addListener(_onStates);
  }

  @override
  void didUpdateWidget(_ModalCloseAction oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.statesController != widget.statesController) {
      (oldWidget.statesController ?? _internal)?.removeListener(_onStates);
      _states.addListener(_onStates);
    }
  }

  void _onStates() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _states.removeListener(_onStates);
    _internal?.dispose();
    super.dispose();
  }

  void _setPressed(bool v) {
    if (_enabled) _states.update(WidgetState.pressed, v);
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final s = _states.value;
    final pressed = s.contains(WidgetState.pressed);
    final focused = _focusHighlight || s.contains(WidgetState.focused);
    final radius = BorderRadius.circular(t.component.modalHeader.closeActionRadius);

    final chip = DecoratedBox(
      decoration: BoxDecoration(
        color: pressed ? t.interactive.pressed : t.component.modalHeader.closeActionBackground,
        borderRadius: radius,
        border: focused ? Border.all(color: t.interactive.focus, width: t.borderWidth.s025) : null,
      ),
      child: SizedBox.square(
        dimension: widget.size,
        child: Center(child: LooviIcon(LooviIcons.xOutline, size: t.spacing.s200, color: t.text.primary)),
      ),
    );

    return Semantics(
      container: true,
      button: true,
      enabled: _enabled,
      label: widget.semanticLabel,
      onTap: widget.onPressed,
      excludeSemantics: true,
      child: FocusableActionDetector(
        enabled: _enabled,
        onShowFocusHighlight: (v) => setState(() => _focusHighlight = v),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {
            widget.onPressed?.call();
            return null;
          }),
        },
        // Listener (no gesture arena) tracks pressed; LooviTapTarget owns the tap.
        child: Listener(
          onPointerDown: (_) => _setPressed(true),
          onPointerUp: (_) => _setPressed(false),
          onPointerCancel: (_) => _setPressed(false),
          child: LooviTapTarget(onTap: widget.onPressed, enabled: _enabled, child: chip),
        ),
      ),
    );
  }
}
