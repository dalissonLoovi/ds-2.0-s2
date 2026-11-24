import 'dart:ui' show SemanticsRole;

import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../generated/loovi_icon_names.g.dart';
import '../list_item/loovi_list_item.dart';

/// Seed `VerticalStepperItem.status`.
enum LooviVerticalStepperItemStatus { completed, current, pending, error }

/// VerticalStepperItem (Figma 3437:531) — one row of [LooviVerticalStepper]:
/// a structural status indicator column + a nested [LooviListItem] with the
/// step text. Not StepperPrimary, StepProgressIndicator, ProgressBar,
/// TimelineItem, Button or standalone navigation.
///
/// Paint (mode app-cliente):
/// - root: row, padding top/bottom `spacing/050`, gap `spacing/0`, fills the
///   width; the indicator column stretches to the row height.
/// - indicatorColumn: width 24 (`spacing/300`), padding-top `spacing/100`,
///   gap `spacing/050`.
///   - statusIcon 24: circle-check-filled | circle-dot-filled
///     (`color/actions/primary`) · circle-outline (`text/placeholder`) ·
///     circle-x-filled (`feedback/danger` — icon next to text).
///   - connector ([showConnector], default true): width `border/width/025`,
///     fills the remaining height; completed `color/actions/primary`, others
///     `color/border/2` (future connectors are never danger).
/// - content: [LooviListItem] (leading/trailing none by default, divider off,
///   default condition `2-line`); ListItem owns its tokens.
///
/// Interaction (seed): non-interactive by default. Pass [onTap] only when the
/// step is intentionally actionable and progress is safely persisted.
///
/// Accessibility (seed): announced as "{status word}. {headline}, {supporting}"
/// ("Concluída" | "Etapa atual" | "Pendente" | "Com erro"), so color is never
/// the only cue; icon and connector are decorative. Inside
/// [LooviVerticalStepperScope] the row is a list item of the ordered list.
class LooviVerticalStepperItem extends StatelessWidget {
  const LooviVerticalStepperItem({
    super.key,
    required this.headline,
    this.status = LooviVerticalStepperItemStatus.completed,
    this.showConnector = true,
    this.supportingText,
    this.overline,
    this.trailingSupportingText,
    this.condition = LooviListItemCondition.twoLine,
    this.leading,
    this.trailing,
    this.showDivider = false,
    this.onTap,
    this.statusSemanticLabel,
  });

  /// Seed `headline` (ListItem).
  final String headline;
  final LooviVerticalStepperItemStatus status;

  /// Seed `showConnector` (default true; false on the last item).
  final bool showConnector;

  /// Seed `supportingText` (shown when non-null = `showSupportingText`).
  final String? supportingText;

  /// Seed `overline` (shown when non-null = `showOverline`).
  final String? overline;

  /// Seed `trailingSupportingText` (shown when non-null).
  final String? trailingSupportingText;

  /// Seed `condition` (default 2-line).
  final LooviListItemCondition condition;

  /// Seed `leading` (default none — status lives in the indicator column).
  final Widget? leading;

  /// Seed `trailing` (default none).
  final Widget? trailing;

  /// Seed `showDivider` (default false).
  final bool showDivider;

  /// Makes the nested ListItem actionable (seed `stateLayer` states).
  final VoidCallback? onTap;

  /// Overrides the announced status word.
  final String? statusSemanticLabel;

  static String defaultStatusLabel(LooviVerticalStepperItemStatus s) => switch (s) {
        LooviVerticalStepperItemStatus.completed => 'Concluída',
        LooviVerticalStepperItemStatus.current => 'Etapa atual',
        LooviVerticalStepperItemStatus.pending => 'Pendente',
        LooviVerticalStepperItemStatus.error => 'Com erro',
      };

  static String iconFor(LooviVerticalStepperItemStatus s) => switch (s) {
        LooviVerticalStepperItemStatus.completed => LooviIcons.circleCheckFilled,
        LooviVerticalStepperItemStatus.current => LooviIcons.circleDotFilled,
        LooviVerticalStepperItemStatus.pending => LooviIcons.circleOutline,
        LooviVerticalStepperItemStatus.error => LooviIcons.circleXFilled,
      };

  static Color iconColorFor(LooviTokens t, LooviVerticalStepperItemStatus s) => switch (s) {
        LooviVerticalStepperItemStatus.completed || LooviVerticalStepperItemStatus.current => t.color.actionsPrimary,
        // Figma + seed 2026-11-24: text/secondary (placeholder was 2.4:1, below 3:1).
        LooviVerticalStepperItemStatus.pending => t.text.secondary,
        LooviVerticalStepperItemStatus.error => t.feedback.danger,
      };

  static Color connectorColorFor(LooviTokens t, LooviVerticalStepperItemStatus s) =>
      s == LooviVerticalStepperItemStatus.completed ? t.color.actionsPrimary : t.color.border2;

  String get _contentLabel => [
        overline,
        headline,
        if (condition != LooviListItemCondition.oneLine) supportingText,
        trailingSupportingText,
      ].whereType<String>().join(', ');

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final statusWord = statusSemanticLabel ?? defaultStatusLabel(status);

    final indicator = SizedBox(
      width: t.spacing.s300,
      child: Padding(
        padding: EdgeInsets.only(top: t.spacing.s100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LooviIcon(iconFor(status), size: t.spacing.s300, color: iconColorFor(t, status)),
            if (showConnector) ...[
              SizedBox(height: t.spacing.s050),
              Expanded(
                child: SizedBox(
                  key: const ValueKey('connector'),
                  width: t.borderWidth.s025,
                  child: ColoredBox(color: connectorColorFor(t, status)),
                ),
              ),
            ],
          ],
        ),
      ),
    );

    final row = Padding(
      padding: EdgeInsets.symmetric(vertical: t.spacing.s050),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ExcludeSemantics(child: indicator),
            Expanded(
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: LooviListItem(
                  headline: headline,
                  condition: condition,
                  overline: overline,
                  supportingText: supportingText,
                  trailingSupportingText: trailingSupportingText,
                  leading: leading,
                  trailing: trailing,
                  showDivider: showDivider,
                  onTap: onTap,
                  semanticLabel: '$statusWord. $_contentLabel',
                ),
              ),
            ),
          ],
        ),
      ),
    );

    final inStepper = LooviVerticalStepperScope.maybeOf(context);
    return Semantics(
      container: true,
      explicitChildNodes: true,
      role: inStepper ? SemanticsRole.listItem : null,
      child: row,
    );
  }
}

/// Marks descendants as items of a [LooviVerticalStepper] ordered list, so a
/// [LooviVerticalStepperItem] takes `SemanticsRole.listItem` (Flutter only
/// allows it under a list node).
class LooviVerticalStepperScope extends InheritedWidget {
  const LooviVerticalStepperScope({super.key, required super.child});

  static bool maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LooviVerticalStepperScope>() != null;

  @override
  bool updateShouldNotify(LooviVerticalStepperScope oldWidget) => false;
}
