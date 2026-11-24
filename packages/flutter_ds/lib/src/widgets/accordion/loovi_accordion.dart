import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../generated/loovi_icon_names.g.dart';
import '../button/loovi_button.dart';

/// Seed `Accordion.size`.
enum LooviAccordionSize { sm, md }

/// Seed `Accordion.padding`.
enum LooviAccordionPadding {
  /// Horizontal padding `spacing/150`.
  padded,

  /// No horizontal padding (`spacing/0`) — the row aligns with the content
  /// edge of the parent.
  flush,
}

/// Seed `Accordion` (Figma 3669:9362) — reveals or hides related content
/// under a tappable trigger. Not a card, modal, dropdown, select, tooltip,
/// permanent list or generic container.
///
/// Seed `expanded` = [expanded] (controlled) or internal state
/// ([initiallyExpanded]); seed `state=disabled` = [disabled] (always
/// collapsed — the seed only publishes disabled with expanded=false).
///
/// Anatomy (mode app-cliente):
/// * root: padding-y `spacing/150`, padding-x `spacing/150` (padded) |
///   `spacing/0` (flush), gap `spacing/150`; bottom divider `color/border/2`
///   `border/width/012` (Figma binds the stroke to the REMOTE legacy
///   `Color/Border/2` — local `color/border/2` used here).
/// * trigger row, gap `spacing/100`: label (md `body/large/medium`, sm
///   `body/medium/medium`) over subtitle (`body/small/regular`, gap md
///   `spacing/025` | sm `spacing/0`); summary (md `body/medium/medium`, sm
///   `body/small/medium`); chevron `chevron-down-outline` /
///   `chevron-up-outline` 16 (`spacing/200`) in a 24 box (`spacing/300`).
///   Ink `text/primary`; disabled `text/secondary`, chevron `text/placeholder`
///   (Figma chevron ink: REMOTE `Color/Content/Default|Ghost`).
/// * panel (expanded): [child] (seed `slot`) then the optional action
///   ([LooviButton] text/sm/primary, seed `showAction`), gap `spacing/150`.
///   The Button paints 40 (`spacing/500`) but takes its 48 dp touch box, so
///   an expanded accordion with action is 8 taller than the Figma frame.
///
/// The trigger's tap area includes the root's top padding and the gap below
/// the row, so it is ≥ 48 dp (md 65, sm 61) without changing the layout.
/// Expand/collapse animates the height (200 ms, none with reduced motion).
///
/// Accessibility: trigger = button with `expanded` state, label =
/// label, subtitle and summary; Enter/Space toggle; keyboard focus ring
/// `interactive/focus` `border/width/025` (focus not drawn in Figma).
class LooviAccordion extends StatefulWidget {
  const LooviAccordion({
    super.key,
    required this.label,
    this.child,
    this.expanded,
    this.initiallyExpanded = false,
    this.onExpandedChange,
    this.disabled = false,
    this.size = LooviAccordionSize.md,
    this.padding = LooviAccordionPadding.padded,
    this.showSubtitle = false,
    this.subtitle = '',
    this.showSummary = false,
    this.summary = '',
    this.showAction = false,
    this.actionLabel = '',
    this.onAction,
    this.focusNode,
    this.autofocus = false,
  });

  /// Seed `label` — trigger label.
  final String label;

  /// Seed `slot` — expandable content.
  final Widget? child;

  /// Seed `expanded` (controlled). Null = uncontrolled ([initiallyExpanded]).
  final bool? expanded;

  /// Initial state when [expanded] is null.
  final bool initiallyExpanded;

  /// Called with the requested state when the trigger is activated.
  final ValueChanged<bool>? onExpandedChange;

  /// Seed `state=disabled` (forces collapsed, no interaction).
  final bool disabled;

  /// Seed `size`.
  final LooviAccordionSize size;

  /// Seed `padding`.
  final LooviAccordionPadding padding;

  /// Seed `showSubtitle` / `subtitle`.
  final bool showSubtitle;
  final String subtitle;

  /// Seed `showSummary` / `summary` (shown collapsed and expanded, as Figma).
  final bool showSummary;
  final String summary;

  /// Seed `showAction` — text Button under the panel content (expanded only).
  final bool showAction;
  final String actionLabel;
  final VoidCallback? onAction;

  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<LooviAccordion> createState() => _LooviAccordionState();
}

class _LooviAccordionState extends State<LooviAccordion> {
  late bool _internal = widget.initiallyExpanded;
  bool _focusHighlight = false;

  bool get _expanded => !widget.disabled && (widget.expanded ?? _internal);

  void _toggle() {
    if (widget.disabled) return;
    final next = !_expanded;
    if (widget.expanded == null) setState(() => _internal = next);
    widget.onExpandedChange?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final md = widget.size == LooviAccordionSize.md;
    final disabled = widget.disabled;
    final expanded = _expanded;
    final ink = disabled ? t.text.secondary : t.text.primary;
    final padX = widget.padding == LooviAccordionPadding.padded ? t.spacing.s150 : t.spacing.s0;
    final reduced = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    const duration = Duration(milliseconds: 200);

    final heading = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(widget.label, style: (md ? t.typography.bodyLargeMedium : t.typography.bodyMediumMedium).copyWith(color: ink)),
        if (widget.showSubtitle) ...[
          SizedBox(height: md ? t.spacing.s025 : t.spacing.s0),
          Text(widget.subtitle, style: t.typography.bodySmallRegular.copyWith(color: ink)),
        ],
      ],
    );

    final row = Row(
      children: [
        Expanded(child: heading),
        if (widget.showSummary) ...[
          SizedBox(width: t.spacing.s100),
          Text(
            widget.summary,
            maxLines: 1,
            softWrap: false,
            style: (md ? t.typography.bodyMediumMedium : t.typography.bodySmallMedium).copyWith(color: ink),
          ),
        ],
        SizedBox(width: t.spacing.s100),
        SizedBox.square(
          dimension: t.spacing.s300,
          child: Center(
            child: LooviIcon(
              expanded ? LooviIcons.chevronUpOutline : LooviIcons.chevronDownOutline,
              size: t.spacing.s200,
              color: disabled ? t.text.placeholder : t.text.primary,
            ),
          ),
        ),
      ],
    );

    // Trigger block = top padding + row + gap/bottom padding (≥ 48 dp).
    Widget trigger = Padding(
      padding: EdgeInsets.fromLTRB(padX, t.spacing.s150, padX, t.spacing.s150),
      child: row,
    );
    if (_focusHighlight && !disabled) {
      trigger = DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(t.radius.s200),
          border: Border.all(color: t.interactive.focus, width: t.borderWidth.s025),
        ),
        child: trigger,
      );
    }

    final semanticsLabel = [
      widget.label,
      if (widget.showSubtitle && widget.subtitle.isNotEmpty) widget.subtitle,
      if (widget.showSummary && widget.summary.isNotEmpty) widget.summary,
    ].join(', ');

    trigger = Semantics(
      container: true,
      button: true,
      expanded: expanded,
      enabled: !disabled,
      focusable: !disabled,
      label: semanticsLabel,
      onTap: disabled ? null : _toggle,
      child: FocusableActionDetector(
        enabled: !disabled,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        onShowFocusHighlight: (v) => setState(() => _focusHighlight = v),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {
            _toggle();
            return null;
          }),
        },
        child: GestureDetector(
          key: const Key('loovi-accordion-trigger'),
          behavior: HitTestBehavior.opaque,
          excludeFromSemantics: true,
          onTap: disabled ? null : _toggle,
          child: ExcludeSemantics(child: trigger),
        ),
      ),
    );

    final panel = expanded
        ? Padding(
            key: const Key('loovi-accordion-panel'),
            padding: EdgeInsets.fromLTRB(padX, t.spacing.s0, padX, t.spacing.s150),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.child != null) widget.child!,
                if (widget.child != null && widget.showAction) SizedBox(height: t.spacing.s150),
                if (widget.showAction)
                  LooviButton(
                    label: widget.actionLabel,
                    onPressed: widget.onAction,
                    variant: LooviButtonVariant.text,
                    size: LooviButtonSize.sm,
                    intent: LooviButtonIntent.primary,
                  ),
              ],
            ),
          )
        : const SizedBox(width: double.infinity);

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: t.color.border2, width: t.borderWidth.s012)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          trigger,
          // Reduced motion: no AnimatedSize at all (a zero-duration
          // AnimatedSize re-dirties itself during layout).
          if (reduced)
            panel
          else
            ClipRect(
              child: AnimatedSize(
                duration: duration,
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: panel,
              ),
            ),
        ],
      ),
    );
  }
}
