import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../generated/loovi_icon_names.g.dart';
import '../button/loovi_button.dart';

/// Seed `Banner.status`.
enum LooviBannerStatus { success, warning, info, danger }

/// Seed `Banner.emphasis` (`meta.governance.feedbackColorRule`): `primary` =
/// saturated `background-feedback-primary/*`, `secondary` = soft
/// `background-feedback-secondary/*`. Default [primary] (Figma and React
/// default).
enum LooviBannerEmphasis { primary, secondary }

/// Banner (Figma 3098:2629) — inline contextual feedback at page, section,
/// card, form or flow level. Short, one-line message; optional secondary
/// action. Not a Toast, Modal, blocking dialog, promo hero, tag or CTA.
///
/// Paint (mode app-cliente):
/// - shell: fill `color/background-feedback-primary/{status}` (emphasis
///   primary) or `color/background-feedback-secondary/{status}` (secondary);
///   info primary = `background-feedback-primary/info`. Radius
///   `border/radius/300`, padding-x `spacing/200`, gap messageContent →
///   action `spacing/100` (Figma itemSpacing 8 unbound — reported).
/// - messageContent: min height `spacing/400`, padding-y `spacing/100` (the
///   root's), gap `spacing/100`; icon 18 (`spacing/200` + `spacing/025`, no
///   18 token) check-outline | alert-triangle-outline | info-circle-outline |
///   alert-circle-outline in `text/primary` (on a saturated feedback fill a
///   feedback/* icon would vanish — Figma binds text/primary).
/// - message: `body/small/regular` + `text/primary` on both emphases.
/// - action (seed `showAction`): [LooviButton] text / sm / primary (label
///   `text/primary`). The Figma instance is a compact 28-tall text button;
///   the widget keeps the DS Button (40 paint, 48 dp target), whose target
///   exactly fills the 48-tall banner row.
///
/// Accessibility (seed): the announcement is "{status word}. {message}";
/// live region (role=alert) only for warning | danger; the icon is
/// decorative; the action keeps its own button node.
class LooviBanner extends StatelessWidget {
  const LooviBanner({
    super.key,
    required this.message,
    this.status = LooviBannerStatus.info,
    this.emphasis = LooviBannerEmphasis.primary,
    this.showIcon = true,
    this.showAction = false,
    this.actionLabel,
    this.onAction,
    this.statusSemanticLabel,
    this.liveRegion,
  });

  /// Seed `message`.
  final String message;
  final LooviBannerStatus status;
  final LooviBannerEmphasis emphasis;

  /// Seed `showIcon`.
  final bool showIcon;

  /// Seed `showAction`. Renders only with an [actionLabel].
  final bool showAction;

  /// Seed `action` label (verb + complement, e.g. "Ver detalhes").
  final String? actionLabel;

  /// Action callback. Null = action disabled.
  final VoidCallback? onAction;

  /// Overrides the status word announced before the message.
  final String? statusSemanticLabel;

  /// Live region. Null = automatic: on for warning | danger.
  final bool? liveRegion;

  static String defaultStatusLabel(LooviBannerStatus s) => switch (s) {
        LooviBannerStatus.success => 'Sucesso',
        LooviBannerStatus.warning => 'Atenção',
        LooviBannerStatus.info => 'Informação',
        LooviBannerStatus.danger => 'Erro',
      };

  /// Status icon (seed `statusMap`).
  static String iconFor(LooviBannerStatus s) => switch (s) {
        LooviBannerStatus.success => LooviIcons.checkOutline,
        LooviBannerStatus.warning => LooviIcons.alertTriangleOutline,
        LooviBannerStatus.info => LooviIcons.infoCircleOutline,
        LooviBannerStatus.danger => LooviIcons.alertCircleOutline,
      };

  /// Shell fill for [status] × [emphasis].
  static Color fillFor(LooviTokens t, LooviBannerStatus s, LooviBannerEmphasis e) {
    final c = t.color;
    if (e == LooviBannerEmphasis.secondary) {
      return switch (s) {
        LooviBannerStatus.success => c.backgroundFeedbackSecondarySuccess,
        LooviBannerStatus.warning => c.backgroundFeedbackSecondaryWarning,
        LooviBannerStatus.info => c.backgroundFeedbackSecondaryInfo,
        LooviBannerStatus.danger => c.backgroundFeedbackSecondaryDanger,
      };
    }
    return switch (s) {
      LooviBannerStatus.success => c.backgroundFeedbackPrimarySuccess,
      LooviBannerStatus.warning => c.backgroundFeedbackPrimaryWarning,
      LooviBannerStatus.info => c.backgroundFeedbackPrimaryInfo,
      LooviBannerStatus.danger => c.backgroundFeedbackPrimaryDanger,
    };
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final hasAction = showAction && actionLabel != null;
    final urgent = liveRegion ?? (status == LooviBannerStatus.warning || status == LooviBannerStatus.danger);

    final messageContent = Padding(
      padding: EdgeInsets.symmetric(vertical: t.spacing.s100),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: t.spacing.s400),
        child: Row(
          children: [
            if (showIcon) ...[
              // Figma 18 × 18: no spacing token of that value.
              LooviIcon(iconFor(status), size: t.spacing.s200 + t.spacing.s025, color: t.text.primary),
              SizedBox(width: t.spacing.s100),
            ],
            Expanded(
              child: ExcludeSemantics(
                child: Text(message, style: t.typography.bodySmallRegular.copyWith(color: t.text.primary)),
              ),
            ),
          ],
        ),
      ),
    );

    final shell = DecoratedBox(
      decoration: BoxDecoration(
        color: fillFor(t, status, emphasis),
        borderRadius: BorderRadius.circular(t.radius.s300),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: t.spacing.s200),
        child: Row(
          children: [
            Expanded(child: messageContent),
            if (hasAction) ...[
              SizedBox(width: t.spacing.s100),
              LooviButton(
                label: actionLabel!,
                onPressed: onAction,
                variant: LooviButtonVariant.text,
                size: LooviButtonSize.sm,
              ),
            ],
          ],
        ),
      ),
    );

    final statusWord = statusSemanticLabel ?? defaultStatusLabel(status);
    return Semantics(
      container: true,
      explicitChildNodes: true,
      liveRegion: urgent,
      label: '$statusWord. $message',
      child: shell,
    );
  }
}
