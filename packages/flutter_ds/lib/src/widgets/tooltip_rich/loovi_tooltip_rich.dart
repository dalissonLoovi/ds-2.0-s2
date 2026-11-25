import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../button/loovi_button.dart';
import '../tooltip/loovi_tooltip_anchor.dart';

/// Seed `TooltipRich.placement` — same axis and geometry as Tooltip.
typedef LooviTooltipRichPlacement = LooviTooltipPlacement;

/// TooltipRich (Figma 3566:10477) — rich contextual tooltip / light popover
/// with optional title, description and up to two actions. Not a Modal,
/// Toast, Dropdown, Select, Menu or persistent help panel.
///
/// Two uses, like [LooviTooltip]: with [child] (trigger) it opens in the
/// Overlay on tap/long-press and closes on tap outside, Escape, or after an
/// action; without [child] it renders the static surface (fills the width).
///
/// Paint (mode app-cliente): [LooviTooltipSurface] (`color/background-surface/
/// inverse-3`, radius `border/radius/300`, shadow `color/elevation/6`, arrow
/// `spacing/200`×`spacing/150`); padding top/sides `spacing/150`, bottom
/// `spacing/200`; gap content → actions `spacing/200`.
/// - content: gap `spacing/050`; title `body/medium/semi-bold`, description
///   `body/small/regular`, both `text/on-color`.
/// - actions: row, gap `spacing/100`, start-aligned, Figma order primary →
///   secondary. primaryAction = [LooviButton] solid / sm / primary;
///   secondaryAction = [LooviButton] text / sm / primary with `appearance:
///   inverse` (label `text/on-color`, the seed's intentional override).
///   Buttons own their 48 dp touch target.
///
/// Accessibility (seed): informative (no actions) → the trigger carries the
/// text as its semantic tooltip and the bubble is excluded. Actionable → the
/// trigger reports expanded/collapsed, the surface is a named route scope so
/// focus/reading can enter it in order; Escape or an action closes it and
/// returns focus to the trigger. Nothing is auto-focused on open.
class LooviTooltipRich extends StatelessWidget {
  const LooviTooltipRich({
    super.key,
    this.placement = LooviTooltipPlacement.topCenter,
    this.title,
    this.showTitle = true,
    this.description,
    this.showDescription = true,
    this.showActions = true,
    this.showPrimaryAction = true,
    this.showSecondaryAction = true,
    this.primaryActionLabel,
    this.secondaryActionLabel,
    this.onPrimaryAction,
    this.onSecondaryAction,
    this.child,
    this.onOpenChange,
    this.initiallyOpen = false,
  });

  /// Shows the surface right after the first frame (default false — mobile opens on tap).
  final bool initiallyOpen;

  final LooviTooltipRichPlacement placement;

  /// Seed `title` (shown with [showTitle]).
  final String? title;
  final bool showTitle;

  /// Seed `description` (shown with [showDescription]).
  final String? description;
  final bool showDescription;

  /// Seed `showActions` / `showPrimaryAction` / `showSecondaryAction`. An
  /// action renders only with its label.
  final bool showActions;
  final bool showPrimaryAction;
  final bool showSecondaryAction;

  /// Nested Button labels (seed React mapping).
  final String? primaryActionLabel;
  final String? secondaryActionLabel;

  final VoidCallback? onPrimaryAction;
  final VoidCallback? onSecondaryAction;

  /// Trigger. Null = static surface only.
  final Widget? child;

  final ValueChanged<bool>? onOpenChange;

  bool get _hasPrimary => showActions && showPrimaryAction && primaryActionLabel != null;
  bool get _hasSecondary => showActions && showSecondaryAction && secondaryActionLabel != null;

  /// True when the surface has at least one action (popover behavior).
  bool get isActionable => _hasPrimary || _hasSecondary;

  String get _text => [if (showTitle) title, if (showDescription) description].whereType<String>().join('. ');

  Widget _surface(BuildContext context, VoidCallback? close) {
    final t = LooviTokens.of(context);
    final hasTitle = showTitle && title != null;
    final hasDescription = showDescription && description != null;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasTitle) Text(title!, style: t.typography.bodyMediumSemiBold.copyWith(color: t.text.onColor)),
        if (hasTitle && hasDescription) SizedBox(height: t.spacing.s050),
        if (hasDescription) Text(description!, style: t.typography.bodySmallRegular.copyWith(color: t.text.onColor)),
      ],
    );

    VoidCallback? wrap(VoidCallback? action) => action == null
        ? null
        : () {
            action();
            close?.call();
          };

    final actions = Wrap(
      spacing: t.spacing.s100,
      runSpacing: t.spacing.s100,
      children: [
        if (_hasPrimary)
          LooviButton(
            label: primaryActionLabel!,
            onPressed: wrap(onPrimaryAction),
            variant: LooviButtonVariant.solid,
            size: LooviButtonSize.sm,
          ),
        if (_hasSecondary)
          LooviButton(
            label: secondaryActionLabel!,
            onPressed: wrap(onSecondaryAction),
            variant: LooviButtonVariant.text,
            size: LooviButtonSize.sm,
            appearance: LooviButtonAppearance.inverse,
          ),
      ],
    );

    return LooviTooltipSurface(
      placement: placement,
      padding: EdgeInsets.fromLTRB(t.spacing.s150, t.spacing.s150, t.spacing.s150, t.spacing.s200),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (hasTitle || hasDescription) content,
          if ((hasTitle || hasDescription) && isActionable) SizedBox(height: t.spacing.s200),
          if (isActionable) actions,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trigger = child;
    if (trigger == null) {
      return Semantics(container: true, explicitChildNodes: true, child: _surface(context, null));
    }
    if (!isActionable) {
      return Semantics(
        tooltip: _text,
        child: LooviTooltipAnchor(
          placement: placement,
          onOpenChange: onOpenChange,
          initiallyOpen: initiallyOpen,
          overlayBuilder: (context, close) => ExcludeSemantics(child: _surface(context, close)),
          child: trigger,
        ),
      );
    }
    return _ActionableAnchor(
      placement: placement,
      onOpenChange: onOpenChange,
      initiallyOpen: initiallyOpen,
      label: showTitle ? title : null,
      surfaceBuilder: _surface,
      child: trigger,
    );
  }
}

/// Tracks open state so the trigger can report expanded/collapsed.
class _ActionableAnchor extends StatefulWidget {
  const _ActionableAnchor({
    required this.placement,
    required this.onOpenChange,
    required this.initiallyOpen,
    required this.label,
    required this.surfaceBuilder,
    required this.child,
  });

  final LooviTooltipPlacement placement;
  final ValueChanged<bool>? onOpenChange;
  final bool initiallyOpen;
  final String? label;
  final Widget Function(BuildContext context, VoidCallback? close) surfaceBuilder;
  final Widget child;

  @override
  State<_ActionableAnchor> createState() => _ActionableAnchorState();
}

class _ActionableAnchorState extends State<_ActionableAnchor> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      expanded: _open,
      child: LooviTooltipAnchor(
        placement: widget.placement,
        showOnKeyboardFocus: false,
        initiallyOpen: widget.initiallyOpen,
        onOpenChange: (open) {
          setState(() => _open = open);
          widget.onOpenChange?.call(open);
        },
        overlayBuilder: (context, close) => Semantics(
          scopesRoute: true,
          namesRoute: true,
          explicitChildNodes: true,
          label: widget.label,
          child: FocusTraversalGroup(child: widget.surfaceBuilder(context, close)),
        ),
        child: widget.child,
      ),
    );
  }
}
