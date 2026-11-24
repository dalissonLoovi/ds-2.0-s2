import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../foundation/loovi_tap_target.dart';
import '../../generated/loovi_icon_names.g.dart';

/// Seed `DashboardCardSecondary.type`.
enum LooviDashboardCardSecondaryType { web, mobile }

/// Seed `DashboardCardSecondary.growth`.
enum LooviDashboardCardSecondaryGrowth { up, down }

/// DashboardCardSecondary (Figma 4181:528) — secondary dashboard metric with
/// optional leading icon, a value and a growth indicator. Static (no hover /
/// focus / disabled states).
///
/// Paint (mode app-cliente):
/// - root radius `border/radius/400`; web `color/background-surface/0` +
///   padding `spacing/300`, card gap `spacing/100`; mobile
///   `color/background-surface/1` + padding `spacing/150`, gap `spacing/050`.
///   Width comes from the parent (Figma demos 210 / 116); height hugs.
/// - web titleRow (gap `spacing/050`): icon chip `spacing/400` circle in
///   `text/brand` with [icon] `spacing/250` in `text/on-color` ([showIcon],
///   web only) + [title].
/// - [title] caption/large/regular `text/primary`; [value]
///   display/large/bold `text/primary`.
/// - growth: [percentage] body/small/regular in `text/success` (up) |
///   `text/danger` (down) — AA text tokens (Figma binds
///   `color/actions/success|danger`, same value); growthIcon
///   `circle-arrow-up-right-filled` | `circle-arrow-down-right-filled` in
///   `color/actions/success|danger`, `spacing/300` (web) | `spacing/200`
///   (mobile); [percentageDescription] body/small/regular `text/secondary`
///   ([showDescription]). Gaps: valuesRow `spacing/025` (web) | `spacing/0`
///   (mobile), percentual `spacing/050`.
/// - info `info-circle-outline` `spacing/200` at top `spacing/200` / right
///   `spacing/300` (web) | top/right `spacing/150` (mobile), in
///   `text/secondary` (Figma `text/placeholder` is 2.3:1 — below the 3:1
///   non-text minimum).
///
/// Semantics: one node "title: value, growth label + percentage,
/// percentageDescription" — the direction is spoken ([growthUpLabel] /
/// [growthDownLabel]), never color only. Info is a button only when
/// [onInfoPressed] is set.
class LooviDashboardCardSecondary extends StatelessWidget {
  const LooviDashboardCardSecondary({
    super.key,
    this.type = LooviDashboardCardSecondaryType.web,
    this.growth = LooviDashboardCardSecondaryGrowth.up,
    this.icon = LooviIcons.fileDescriptionOutline,
    this.showIcon = true,
    this.title = 'Title',
    this.value = '25',
    this.showInfo = true,
    this.showDescription = true,
    this.percentage = '100%',
    this.percentageDescription = '12 no mês anterior',
    this.onInfoPressed,
    this.infoSemanticLabel = 'Mais informações',
    this.growthUpLabel = 'Alta de',
    this.growthDownLabel = 'Queda de',
    this.semanticLabel,
  });

  final LooviDashboardCardSecondaryType type;
  final LooviDashboardCardSecondaryGrowth growth;

  /// Seed `icon` (INSTANCE_SWAP, web) — DS contract name.
  final String icon;

  /// Seed `showIcon` (web only).
  final bool showIcon;

  /// Seed `title`.
  final String title;

  /// Seed `value`.
  final String value;

  /// Seed `showInfo`.
  final bool showInfo;

  /// Seed `showDescription`.
  final bool showDescription;

  /// Seed `percentage`.
  final String percentage;

  /// Seed `percentageDescription`.
  final String percentageDescription;

  /// Makes the info icon a button (48 dp target). Null = decorative.
  final VoidCallback? onInfoPressed;

  /// Accessible name of the info button.
  final String infoSemanticLabel;

  /// Spoken before [percentage] for growth=up / down.
  final String growthUpLabel;
  final String growthDownLabel;

  /// Overrides the composed accessible name.
  final String? semanticLabel;

  bool get _web => type == LooviDashboardCardSecondaryType.web;
  bool get _up => growth == LooviDashboardCardSecondaryGrowth.up;

  String get _label {
    if (semanticLabel != null) return semanticLabel!;
    final dir = _up ? growthUpLabel : growthDownLabel;
    return [
      '$title: $value',
      '$dir $percentage',
      if (showDescription) percentageDescription,
    ].join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final web = _web;
    final primary = TextStyle(color: t.text.primary);
    final statusText = _up ? t.text.success : t.text.danger;
    final statusIcon = _up ? t.color.actionsSuccess : t.color.actionsDanger;

    final titleText = Text(title, style: t.typography.captionLargeRegular.merge(primary));
    final valueText = Text(value, style: t.typography.displayLargeBold.merge(primary));
    final percentageText = Text(percentage, style: t.typography.bodySmallRegular.copyWith(color: statusText));
    final growthIcon = LooviIcon(
      _up ? LooviIcons.circleArrowUpRightFilled : LooviIcons.circleArrowDownRightFilled,
      size: web ? t.spacing.s300 : t.spacing.s200,
      color: statusIcon,
    );
    final description = Text(percentageDescription, style: t.typography.bodySmallRegular.copyWith(color: t.text.secondary));

    final Widget body;
    if (web) {
      body = Padding(
        padding: EdgeInsets.all(t.spacing.s300),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showIcon) ...[
              Container(
                width: t.spacing.s400,
                height: t.spacing.s400,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: t.text.brand, borderRadius: BorderRadius.circular(t.radius.full)),
                child: LooviIcon(icon, size: t.spacing.s250, color: t.text.onColor),
              ),
              SizedBox(height: t.spacing.s050),
            ],
            titleText,
            SizedBox(height: t.spacing.s100),
            valueText,
            SizedBox(height: t.spacing.s025),
            Row(
              children: [
                percentageText,
                SizedBox(width: t.spacing.s050),
                growthIcon,
                if (showDescription) ...[
                  SizedBox(width: t.spacing.s050),
                  Flexible(child: description),
                ],
              ],
            ),
          ],
        ),
      );
    } else {
      body = Padding(
        padding: EdgeInsets.all(t.spacing.s150),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Keeps the title clear of the info icon (16 + spacing/050).
            Padding(
              padding: EdgeInsets.only(right: showInfo ? t.spacing.s250 : t.spacing.s0),
              child: titleText,
            ),
            SizedBox(height: t.spacing.s050),
            valueText,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [percentageText, SizedBox(width: t.spacing.s050), growthIcon],
            ),
            if (showDescription) ...[
              SizedBox(height: t.spacing.s050),
              description,
            ],
          ],
        ),
      );
    }

    final card = DecoratedBox(
      decoration: BoxDecoration(
        color: web ? t.color.backgroundSurface0 : t.color.backgroundSurface1,
        borderRadius: BorderRadius.circular(t.radius.s400),
      ),
      child: Semantics(container: true, label: _label, child: ExcludeSemantics(child: body)),
    );

    if (!showInfo) return card;

    final infoIcon = LooviIcon(LooviIcons.infoCircleOutline, size: t.spacing.s200, color: t.text.secondary);
    final min = LooviTapTarget.minSize(context);
    // 48 dp target centered on the 16 icon at the Figma position.
    final half = (min - t.spacing.s200) / 2;
    final top = (web ? t.spacing.s200 : t.spacing.s150) - half;
    final right = (web ? t.spacing.s300 : t.spacing.s150) - half;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        card,
        Positioned(
          top: top,
          right: right,
          child: onInfoPressed == null
              ? Padding(padding: EdgeInsets.all(half), child: infoIcon)
              : Semantics(
                  button: true,
                  label: infoSemanticLabel,
                  child: LooviTapTarget(onTap: onInfoPressed, child: infoIcon),
                ),
        ),
      ],
    );
  }
}
