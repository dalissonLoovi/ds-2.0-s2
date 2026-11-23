import 'dart:math' as math;

import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../foundation/loovi_tap_target.dart';
import '../../generated/loovi_icon_names.g.dart';

/// Seed `BottomSheetHeader.appearance` — single value (`default`; Dart
/// keyword → [standard]). No inverse for sheets.
enum LooviBottomSheetHeaderAppearance { standard }

/// BottomSheetHeader (Figma 4307:3760) — compact header used only inside
/// [LooviBottomSheet] (`header=sheet-header`).
///
/// Anatomy: leadingActions (fixed slot) + headingContent (fill, centered
/// title) + trailingActions (fixed slot). The slots stay in layout when their
/// action is hidden, so the title never recenters.
///
/// Paint (mode app-cliente):
/// - root: padding `spacing/0`, gap `spacing/150`; fill
///   `color/background-surface/0`.
/// - title `body/medium/medium` + `text/primary`, centered.
/// - actions = Button text/sm/primary icon-only: paint `spacing/500` (40)
///   square, radius `component/button/container/radius/sm` (full), icon 16
///   (`spacing/200`) `text/primary`; pressed → `interactive/pressed`.
///   options `dots-vertical-outline`, leading `arrow-left-outline`,
///   close `x-outline`.
///
/// Height: the frame is 40 (`spacing/500`). Each slot is a 48 touch target
/// (`spacing/600`) with the 40 paint aligned to the outer edge, so this widget
/// lays out 48 tall; [LooviBottomSheet] takes the 4 px growth out of its top
/// padding and header gap, keeping painted positions equal to the frame.
///
/// In the frame optionsAction and leadingAction share the same leading slot
/// (absolute, overlapping). When both are on, [showLeadingAction] wins.
class LooviBottomSheetHeader extends StatelessWidget {
  const LooviBottomSheetHeader({
    super.key,
    this.title = 'Label',
    this.appearance = LooviBottomSheetHeaderAppearance.standard,
    this.showLabel = true,
    this.showOptionsAction = false,
    this.showLeadingAction = false,
    this.showCloseAction = true,
    this.onOptions,
    this.onLeadingAction,
    this.onClose,
    this.optionsSemanticLabel = 'Opções',
    this.leadingSemanticLabel = 'Ação',
    this.closeSemanticLabel = 'Fechar',
  });

  /// Seed `title` (default "Label").
  final String title;

  final LooviBottomSheetHeaderAppearance appearance;

  /// Seed `showLabel` — toggles the title; the fill slot stays.
  final bool showLabel;

  /// Seed `showOptionsAction` (dots-vertical-outline).
  final bool showOptionsAction;

  /// Seed `showLeadingAction` (arrow-left-outline).
  final bool showLeadingAction;

  /// Seed `showCloseAction` (x-outline).
  final bool showCloseAction;

  final VoidCallback? onOptions;
  final VoidCallback? onLeadingAction;
  final VoidCallback? onClose;

  /// Accessible names of the icon-only actions (seed: Opções / Ação / Fechar).
  final String optionsSemanticLabel;
  final String leadingSemanticLabel;
  final String closeSemanticLabel;

  /// Vertical growth (each side) of the header over the 40 frame height,
  /// caused by the 48 touch target. Used by [LooviBottomSheet].
  static double touchInset(BuildContext context) {
    final t = LooviTokens.of(context);
    return math.max(t.spacing.s0, (LooviTapTarget.minSize(context) - t.spacing.s500) / 2);
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final slot = math.max(LooviTapTarget.minSize(context), t.spacing.s500);
    final inset = touchInset(context);

    Widget? leading;
    if (showLeadingAction) {
      leading = _SheetIconAction(
        icon: LooviIcons.arrowLeftOutline,
        semanticLabel: leadingSemanticLabel,
        onPressed: onLeadingAction,
        alignment: Alignment.centerLeft,
      );
    } else if (showOptionsAction) {
      leading = _SheetIconAction(
        icon: LooviIcons.dotsVerticalOutline,
        semanticLabel: optionsSemanticLabel,
        onPressed: onOptions,
        alignment: Alignment.centerLeft,
      );
    }

    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: slot),
        child: Row(
          children: [
            SizedBox(width: slot, child: leading),
            SizedBox(width: math.max(t.spacing.s0, t.spacing.s150 - inset)),
            Expanded(
              child: showLabel
                  ? Semantics(
                      container: true,
                      header: true,
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: t.typography.bodyMediumMedium.copyWith(color: t.text.primary),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            SizedBox(width: math.max(t.spacing.s0, t.spacing.s150 - inset)),
            SizedBox(
              width: slot,
              child: showCloseAction
                  ? _SheetIconAction(
                      icon: LooviIcons.xOutline,
                      semanticLabel: closeSemanticLabel,
                      onPressed: onClose,
                      alignment: Alignment.centerRight,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

/// Button text/sm/primary icon-only of the sheet header: 40 paint inside a
/// 48 hit area, paint aligned to the header's outer edge.
class _SheetIconAction extends StatefulWidget {
  const _SheetIconAction({
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    required this.alignment,
  });

  final String icon;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final Alignment alignment;

  @override
  State<_SheetIconAction> createState() => _SheetIconActionState();
}

class _SheetIconActionState extends State<_SheetIconAction> {
  bool _pressed = false;
  bool _focus = false;

  bool get _enabled => widget.onPressed != null;

  void _setPressed(bool v) {
    if (_enabled && _pressed != v) setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final min = LooviTapTarget.minSize(context);
    final radius = BorderRadius.circular(t.component.button.containerRadiusSm);

    final paint = DecoratedBox(
      decoration: BoxDecoration(
        color: _pressed ? t.interactive.pressed : null,
        borderRadius: radius,
        border: _focus ? Border.all(color: t.interactive.focus, width: t.borderWidth.s025) : null,
      ),
      child: SizedBox.square(
        dimension: t.spacing.s500,
        child: Center(child: LooviIcon(widget.icon, size: t.spacing.s200, color: t.text.primary)),
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
        onShowFocusHighlight: (v) => setState(() => _focus = v),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {
            widget.onPressed?.call();
            return null;
          }),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onPressed,
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: min, minHeight: min),
            child: Align(alignment: widget.alignment, widthFactor: 1, heightFactor: 1, child: paint),
          ),
        ),
      ),
    );
  }
}
