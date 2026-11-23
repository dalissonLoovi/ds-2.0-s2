import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../foundation/loovi_tap_target.dart';
import '../../generated/loovi_icon_names.g.dart';
import '../button/loovi_button.dart';

/// Seed `Alert.appearance` (`default` is a Dart keyword → [standard]). The
/// Figma VARIANT default is still `inverse`, but the seed asks product
/// instances on light surfaces to use `default`, so the widget defaults to
/// [standard].
enum LooviAlertAppearance { standard, inverse }

/// Seed `Alert.status` (feedback vocabulary). `system` is intentional-sparse:
/// it has no status icon.
enum LooviAlertStatus { system, info, success, danger, warning }

/// Alert (Figma 4406:91): persistent in-flow feedback card. It is not a Toast,
/// Banner or Modal, and it is not used for inline field validation.
///
/// Paint (mode app-cliente):
/// - shell: radius `border/radius/400`; padding top `spacing/150`, right,
///   bottom and left `spacing/250`; root gap `spacing/100` (statusIcon →
///   content).
/// - default: fill `color/background-surface/3`; title `text/primary`;
///   description `text/secondary`.
/// - inverse: `color/background-surface/brand-strong` with
///   `color/elevation/inverse-3` on top at 48 % paint opacity, composited into
///   one opaque fill (≈ #3E53B2); title `text/on-color`; description
///   `text/on-color-disabled`.
/// - statusIcon 32 (`spacing/400`) in both appearances: info-circle-filled |
///   circle-check-filled | alert-circle-filled | alert-triangle-filled, colored
///   feedback/info | success | danger | warning. `system` has no icon.
/// - content: text (title `body/medium/semi-bold`, description
///   `body/small/regular`, gap `spacing/100`) then the action, gap
///   `spacing/150`.
/// - action: [LooviButton] outline / sm / primary; on `inverse` it uses
///   `appearance: LooviButtonAppearance.inverse` (stroke/label `text/on-color`,
///   Figma 4406:38 — seed rule `closeAction`).
/// - close (seed `showClose`, default false): `x-outline` 24 in the title
///   color, absolute in the top-end corner with a 48 dp target; the shell
///   padding is unchanged. When the title is the first row (status=system, no
///   icon) it is inset so it never runs under the close action.
class LooviAlert extends StatelessWidget {
  const LooviAlert({
    super.key,
    required this.title,
    this.status = LooviAlertStatus.info,
    this.appearance = LooviAlertAppearance.standard,
    this.description,
    this.showDescription = true,
    this.showAction = true,
    this.actionLabel,
    this.onAction,
    this.showClose = false,
    this.onClose,
    this.closeSemanticLabel = 'Fechar alerta',
    this.statusSemanticLabel,
    this.liveRegion,
  });

  /// Seed `title` (TEXT).
  final String title;

  final LooviAlertStatus status;
  final LooviAlertAppearance appearance;

  /// Seed `description` (TEXT). Hidden when null or [showDescription] = false.
  final String? description;

  /// Seed `showDescription`.
  final bool showDescription;

  /// Seed `showAction`. The action renders only with an [actionLabel].
  final bool showAction;

  /// Seed `actionLabel` (nested Button.label in Figma).
  final String? actionLabel;

  /// Action callback. Null = the action button is disabled.
  final VoidCallback? onAction;

  /// Seed `showClose` (default false): close action in the top-end corner.
  final bool showClose;

  /// Close callback.
  final VoidCallback? onClose;

  /// Accessible name of the close control.
  final String closeSemanticLabel;

  /// Overrides the status word announced before the title.
  final String? statusSemanticLabel;

  /// Live region (seed `role=alert`). Null = automatic: on for `danger` and
  /// `warning`, off for `system | info | success` (`role=status`).
  final bool? liveRegion;

  static String defaultStatusLabel(LooviAlertStatus s) => switch (s) {
        LooviAlertStatus.system => 'Aviso',
        LooviAlertStatus.info => 'Informação',
        LooviAlertStatus.success => 'Sucesso',
        LooviAlertStatus.danger => 'Erro',
        LooviAlertStatus.warning => 'Atenção',
      };

  /// Status icon name (seed `statusMap`), null on `system`.
  static String? iconFor(LooviAlertStatus s) => switch (s) {
        LooviAlertStatus.system => null,
        LooviAlertStatus.info => LooviIcons.infoCircleFilled,
        LooviAlertStatus.success => LooviIcons.circleCheckFilled,
        LooviAlertStatus.danger => LooviIcons.alertCircleFilled,
        LooviAlertStatus.warning => LooviIcons.alertTriangleFilled,
      };

  /// Status icon color (seed `statusMap.iconFillToken`), null on `system`.
  static Color? iconColorFor(LooviTokens t, LooviAlertStatus s) => switch (s) {
        LooviAlertStatus.system => null,
        // The icon always sits next to the title/text → feedback/{status}.
        LooviAlertStatus.info => t.feedback.info,
        LooviAlertStatus.success => t.feedback.success,
        LooviAlertStatus.danger => t.feedback.danger,
        LooviAlertStatus.warning => t.feedback.warning,
      };

  /// Figma paint opacity of the `color/elevation/inverse-3` overlay on the
  /// inverse shell (no opacity token exists).
  static const double inverseOverlayOpacity = 0.48;

  /// Shell fill for [appearance].
  static Color fillFor(LooviTokens t, LooviAlertAppearance a) {
    if (a != LooviAlertAppearance.inverse) return t.color.backgroundSurface3;
    final overlay = t.color.elevationInverse3;
    return Color.alphaBlend(
      overlay.withValues(alpha: overlay.a * inverseOverlayOpacity),
      t.color.backgroundSurfaceBrandStrong,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final inverse = appearance == LooviAlertAppearance.inverse;
    final titleColor = inverse ? t.text.onColor : t.text.primary;
    final descriptionColor = inverse ? t.text.onColorDisabled : t.text.secondary;
    final icon = iconFor(status);
    final hasDescription = showDescription && description != null;
    final hasAction = showAction && actionLabel != null;
    final urgent = liveRegion ?? (status == LooviAlertStatus.danger || status == LooviAlertStatus.warning);

    final min = LooviTapTarget.minSize(context);
    // Title as first row (no status icon) would run under the close target:
    // inset it by the part of the target that overlaps the content box.
    final titleEndInset = showClose && icon == null ? min - t.spacing.s250 : 0.0;

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(end: titleEndInset),
          child: Text(title, style: t.typography.bodyMediumSemiBold.copyWith(color: titleColor)),
        ),
        if (hasDescription) ...[
          SizedBox(height: t.spacing.s100),
          Text(description!, style: t.typography.bodySmallRegular.copyWith(color: descriptionColor)),
        ],
      ],
    );

    Widget? action;
    if (hasAction) {
      action = LooviButton(
        label: actionLabel!,
        onPressed: onAction,
        variant: LooviButtonVariant.outline,
        size: LooviButtonSize.sm,
        appearance: inverse ? LooviButtonAppearance.inverse : LooviButtonAppearance.standard,
      );
    }

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          LooviIcon(icon, size: t.spacing.s400, color: iconColorFor(t, status)),
          SizedBox(height: t.spacing.s100),
        ],
        ExcludeSemantics(child: text),
        if (action != null) ...[
          SizedBox(height: t.spacing.s150),
          action,
        ],
      ],
    );

    Widget shell = DecoratedBox(
      decoration: BoxDecoration(
        color: fillFor(t, appearance),
        borderRadius: BorderRadius.circular(t.radius.s400),
      ),
      child: Padding(
        // Seed: padding unchanged with showClose (the close is absolute).
        padding: EdgeInsetsDirectional.only(
          top: t.spacing.s150,
          start: t.spacing.s250,
          end: t.spacing.s250,
          bottom: t.spacing.s250,
        ),
        child: SizedBox(width: double.infinity, child: body),
      ),
    );

    if (showClose) {
      shell = Stack(
        children: [
          shell,
          PositionedDirectional(
            top: 0,
            end: 0,
            child: Semantics(
              button: true,
              enabled: onClose != null,
              label: closeSemanticLabel,
              onTap: onClose,
              excludeSemantics: true,
              child: LooviTapTarget(
                onTap: onClose,
                enabled: onClose != null,
                child: LooviIcon(LooviIcons.xOutline, size: t.spacing.s300, color: titleColor),
              ),
            ),
          ),
        ],
      );
    }

    final statusWord = statusSemanticLabel ?? defaultStatusLabel(status);
    return Semantics(
      container: true,
      explicitChildNodes: true,
      liveRegion: urgent,
      label: [statusWord, title, if (hasDescription) description!].join('. '),
      child: shell,
    );
  }
}
