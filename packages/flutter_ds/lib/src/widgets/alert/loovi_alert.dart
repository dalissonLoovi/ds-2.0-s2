import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../foundation/loovi_tap_target.dart';
import '../../generated/loovi_icon_names.g.dart';
import '../button/loovi_button.dart';

/// Seed `Alert.appearance`. The Figma VARIANT default is still `inverse`, but
/// the seed asks product instances on light surfaces to use `default`, so the
/// widget defaults to [defaultAppearance].
enum LooviAlertAppearance { defaultAppearance, inverse }

/// Seed `Alert.status` (feedback vocabulary). `system` is intentional-sparse:
/// it has no status icon.
enum LooviAlertStatus { system, info, success, danger, warning }

/// Alert (Figma 4406:91): persistent in-flow feedback card. It is not a Toast,
/// Banner or Modal, and it is not used for inline field validation.
///
/// Paint (mode app-cliente):
/// - shell: radius `border/radius/400`; padding top `spacing/150`, sides and
///   bottom `spacing/250`; vertical gap `spacing/100` (statusIcon → content).
/// - default: fill `color/background-surface/3`; title `text/primary`;
///   description `text/secondary`.
/// - inverse: `color/elevation/inverse-3` composited over
///   `color/background-surface/brand` (Figma fill stack, black 48 % on top);
///   title `text/on-color`; description `text/on-color-disabled`.
/// - statusIcon 32 (`spacing/400`): info-circle-filled | circle-check-filled
///   | alert-circle-filled | alert-triangle-filled, colored
///   feedback/info | success | danger | warning. `feedback/info` is not
///   generated in loovi_tokens; `color/background-feedback-primary/info` (same
///   primitive aqua-gleam) is used.
/// - content: text (title `body/medium/semi-bold`, description
///   `body/small/regular`, gap `spacing/100`) then the action, gap
///   `spacing/150`.
/// - action: [LooviButton] outline / sm / primary. On `inverse` the stroke and
///   label are drawn in `text/on-color` (Figma 4406:38); LooviButton has no
///   inverse appearance, so it is recolored here while idle.
/// - close (not in the Figma set, product request): `x-outline` 24 in the title
///   color, 48 dp target in the top-end corner.
class LooviAlert extends StatelessWidget {
  const LooviAlert({
    super.key,
    required this.title,
    this.status = LooviAlertStatus.info,
    this.appearance = LooviAlertAppearance.defaultAppearance,
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

  /// Shows the close control (not published in Figma; see class doc).
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
        // feedback/info → aqua-gleam; same value as background-feedback-primary/info.
        LooviAlertStatus.info => t.color.backgroundFeedbackPrimaryInfo,
        LooviAlertStatus.success => t.feedback.success,
        LooviAlertStatus.danger => t.feedback.danger,
        LooviAlertStatus.warning => t.feedback.warning,
      };

  /// Shell fill for [appearance].
  static Color fillFor(LooviTokens t, LooviAlertAppearance a) => a == LooviAlertAppearance.inverse
      ? Color.alphaBlend(t.color.elevationInverse3, t.color.backgroundSurfaceBrand)
      : t.color.backgroundSurface3;

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

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: t.typography.bodyMediumSemiBold.copyWith(color: titleColor)),
        if (hasDescription) ...[
          SizedBox(height: t.spacing.s100),
          Text(description!, style: t.typography.bodySmallRegular.copyWith(color: descriptionColor)),
        ],
      ],
    );

    Widget? action;
    if (hasAction) {
      action = inverse
          ? _InverseAction(label: actionLabel!, onPressed: onAction)
          : LooviButton(
              label: actionLabel!,
              onPressed: onAction,
              variant: LooviButtonVariant.outline,
              size: LooviButtonSize.sm,
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

    final min = LooviTapTarget.minSize(context);
    Widget shell = DecoratedBox(
      decoration: BoxDecoration(
        color: fillFor(t, appearance),
        borderRadius: BorderRadius.circular(t.radius.s400),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          top: t.spacing.s150,
          start: t.spacing.s250,
          // Close target sits in the top-end corner: keep content clear of it.
          end: showClose ? min : t.spacing.s250,
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

/// Action of `appearance=inverse`: [LooviButton] outline/sm with the stroke and
/// label recolored to `text/on-color`. While pressed the regular button paint
/// (interactive/pressed fill + text/primary label) is shown unfiltered so the
/// label stays legible.
class _InverseAction extends StatefulWidget {
  const _InverseAction({required this.label, required this.onPressed});
  final String label;
  final VoidCallback? onPressed;

  @override
  State<_InverseAction> createState() => _InverseActionState();
}

class _InverseActionState extends State<_InverseAction> {
  final WidgetStatesController _states = WidgetStatesController();

  @override
  void initState() {
    super.initState();
    _states.addListener(_onStates);
  }

  void _onStates() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _states.removeListener(_onStates);
    _states.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final button = LooviButton(
      label: widget.label,
      onPressed: widget.onPressed,
      variant: LooviButtonVariant.outline,
      size: LooviButtonSize.sm,
      statesController: _states,
    );
    // Same tree in both states (BlendMode.dst = identity) so the button keeps
    // its gesture/state while pressed.
    final pressed = _states.value.contains(WidgetState.pressed);
    return ColorFiltered(
      colorFilter: ColorFilter.mode(t.text.onColor, pressed ? BlendMode.dst : BlendMode.srcIn),
      child: button,
    );
  }
}
