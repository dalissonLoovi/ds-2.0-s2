import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../generated/loovi_icon_names.g.dart';
import '../button/loovi_button.dart';

/// Seed `Toast.status` (feedback vocabulary). `system` is intentional-sparse:
/// no status icon.
enum LooviToastStatus { system, info, success, danger, warning }

/// Toast (Figma 3550:4107) — short, transient, non-blocking feedback on a
/// dark surface. Not a Modal, Banner, Alert or AlertDialog. Showing,
/// timing and stacking belong to the app (e.g. an Overlay); this widget is
/// the visual + semantics.
///
/// Paint (mode app-cliente):
/// - shell: fill `color/background-surface/inverse-3`, radius
///   `border/radius/200` (Figma + seed, aligned 2026-11-24), effect `elevation/1`; min height `spacing/600`,
///   padding-start `spacing/200`, padding-end `spacing/0`, gap `spacing/150`.
///   The message keeps `spacing/150` vertical padding so long text wraps
///   instead of overflowing the 48 frame.
/// - statusIcon 24 (`spacing/300`): info-circle-filled | circle-check-filled |
///   alert-circle-filled | alert-triangle-filled in `feedback/info | success |
///   danger | warning` (icon next to the message → feedback/*, seed
///   `feedbackColorRule`). `system` has no icon.
/// - message: `body/medium/regular` + `text/on-color`.
/// - action (seed `showAction`, default false): [LooviButton] text / md /
///   primary with `appearance: inverse` (label `text/on-color`). Figma uses the
///   same inverse Button since 2026-11-24 (was default, 1.4:1).
/// - dismiss (seed `dismissible`, default true): [LooviButton] text / md
///   icon-only `x-outline` 20, inverse (`text/on-color`), name "Fechar".
///
/// Accessibility (seed): never moves focus. The toast is a live region; the
/// announcement is "{status word}. {message}". The status icon is decorative.
class LooviToast extends StatelessWidget {
  const LooviToast({
    super.key,
    required this.message,
    this.status = LooviToastStatus.info,
    this.showAction = false,
    this.actionLabel,
    this.onAction,
    this.dismissible = true,
    this.onDismiss,
    this.dismissSemanticLabel = 'Fechar',
    this.statusSemanticLabel,
  });

  /// Seed `message` (TEXT).
  final String message;

  final LooviToastStatus status;

  /// Seed `showAction` (default false). Renders only with an [actionLabel].
  final bool showAction;

  /// Seed `actionLabel` (nested Button label).
  final String? actionLabel;

  /// Action callback. Null = action disabled.
  final VoidCallback? onAction;

  /// Seed `dismissible` (default true).
  final bool dismissible;

  /// Dismiss callback. Null = dismiss disabled.
  final VoidCallback? onDismiss;

  /// Accessible name of the dismiss control.
  final String dismissSemanticLabel;

  /// Overrides the status word announced before the message.
  final String? statusSemanticLabel;

  static String defaultStatusLabel(LooviToastStatus s) => switch (s) {
        LooviToastStatus.system => 'Aviso',
        LooviToastStatus.info => 'Informação',
        LooviToastStatus.success => 'Sucesso',
        LooviToastStatus.danger => 'Erro',
        LooviToastStatus.warning => 'Atenção',
      };

  /// Status icon name (seed `statusMap`), null on `system`.
  static String? iconFor(LooviToastStatus s) => switch (s) {
        LooviToastStatus.system => null,
        LooviToastStatus.info => LooviIcons.infoCircleFilled,
        LooviToastStatus.success => LooviIcons.circleCheckFilled,
        LooviToastStatus.danger => LooviIcons.alertCircleFilled,
        LooviToastStatus.warning => LooviIcons.alertTriangleFilled,
      };

  /// Status icon color (`feedback/*`), null on `system`.
  static Color? iconColorFor(LooviTokens t, LooviToastStatus s) => switch (s) {
        LooviToastStatus.system => null,
        LooviToastStatus.info => t.feedback.info,
        LooviToastStatus.success => t.feedback.success,
        LooviToastStatus.danger => t.feedback.danger,
        LooviToastStatus.warning => t.feedback.warning,
      };

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final icon = iconFor(status);
    final hasAction = showAction && actionLabel != null;

    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null) ...[
          LooviIcon(icon, size: t.spacing.s300, color: iconColorFor(t, status)),
          SizedBox(width: t.spacing.s150),
        ],
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: t.spacing.s150),
            child: ExcludeSemantics(
              child: Text(message, style: t.typography.bodyMediumRegular.copyWith(color: t.text.onColor)),
            ),
          ),
        ),
        if (hasAction || dismissible) SizedBox(width: t.spacing.s150),
        if (hasAction)
          LooviButton(
            label: actionLabel!,
            onPressed: onAction,
            variant: LooviButtonVariant.text,
            size: LooviButtonSize.md,
            appearance: LooviButtonAppearance.inverse,
          ),
        if (dismissible)
          LooviButton(
            label: dismissSemanticLabel,
            onPressed: onDismiss,
            variant: LooviButtonVariant.text,
            size: LooviButtonSize.md,
            appearance: LooviButtonAppearance.inverse,
            showLabel: false,
            showIcon: true,
            leadingIcon: LooviIcons.xOutline,
          ),
      ],
    );

    final shell = DecoratedBox(
      decoration: BoxDecoration(
        color: t.color.backgroundSurfaceInverse3,
        borderRadius: BorderRadius.circular(t.radius.s200),
        boxShadow: LooviEffects.box(t.effects.elevation1),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: t.spacing.s600),
        child: Padding(
          padding: EdgeInsetsDirectional.only(start: t.spacing.s200, end: t.spacing.s0),
          child: row,
        ),
      ),
    );

    final statusWord = statusSemanticLabel ?? defaultStatusLabel(status);
    return Semantics(
      container: true,
      explicitChildNodes: true,
      liveRegion: true,
      label: '$statusWord. $message',
      child: shell,
    );
  }
}
