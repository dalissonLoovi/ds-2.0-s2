import 'dart:math' as math;

import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../foundation/loovi_tap_target.dart';
import '../../generated/loovi_icon_names.g.dart';

/// Seed `DashboardCardPrimary.type`.
enum LooviDashboardCardPrimaryType { web, mobile }

/// DashboardCardPrimary (Figma 4181:493) — primary dashboard metric on a dark
/// inverse surface with a donut chart accent, a hero value and two secondary
/// metrics. Static (no hover / focus / disabled states).
///
/// Paint (mode app-cliente):
/// - root `color/background-surface/inverse-4`, radius `border/radius/400`;
///   size hugs the content.
/// - web: padding `spacing/200` vertical / `spacing/400` horizontal, gap
///   `spacing/100`; titleRow ([title] body/medium/semi-bold); content gap
///   `spacing/300`: chart with [primaryValue] centered on it + metrics (gap
///   `spacing/100`); info `info-circle-outline` `spacing/200` (16) at top
///   `spacing/200` / right `spacing/300`, `text/on-color-disabled`
///   ([showInfo], web only).
/// - mobile: padding + gap `spacing/200`; mainCol = chart `spacing/500` (40)
///   with `currency-dollar-outline` `spacing/250` in `text/on-color` +
///   [primaryValue] + [title] (body/small/semi-bold); metrics gap
///   `spacing/025`.
/// - texts: [title] / [label1] / [label2] `text/on-color-disabled`;
///   [primaryValue] heading/h1/semi-bold and [description1] / [description2]
///   heading/h2/semi-bold `text/on-color`; labels body/small/regular.
/// - chart: track ring `color/background-surface/inverse-1` (web) |
///   `inverse-0` (mobile); accent arc `color/actions/secondary` from 12
///   o'clock, clockwise, sweep = [chartValue].
///
/// Chart geometry (Figma, no size tokens): web diameter 132; track diameter
/// 0.91·D, ring 0.018·D; accent ring 0.10·D (web) | 0.12·D (mobile), round
/// ends.
///
/// Semantics: one node "title: primaryValue. label1: description1. label2:
/// description2" (the chart is decorative — never the only carrier of the
/// value). The info icon is a button only when [onInfoPressed] is set.
class LooviDashboardCardPrimary extends StatelessWidget {
  const LooviDashboardCardPrimary({
    super.key,
    this.type = LooviDashboardCardPrimaryType.web,
    this.title = 'Title',
    this.primaryValue = '6.838',
    this.label1 = 'Label',
    this.label2 = 'Label',
    this.description1 = '123',
    this.description2 = '123',
    this.showInfo = true,
    this.onInfoPressed,
    this.infoSemanticLabel = 'Mais informações',
    this.chartValue = defaultChartValue,
    this.semanticLabel,
  });

  final LooviDashboardCardPrimaryType type;

  /// Seed `title`.
  final String title;

  /// Seed `primaryValue` (formatted by the product).
  final String primaryValue;

  /// Seed `label1` / `label2` — secondary metric labels.
  final String label1;
  final String label2;

  /// Seed `description1` / `description2` — secondary metric values.
  final String description1;
  final String description2;

  /// Seed `showInfo` (web only — mobile has no info slot).
  final bool showInfo;

  /// Makes the info icon a button (48 dp target). Null = decorative.
  final VoidCallback? onInfoPressed;

  /// Accessible name of the info button.
  final String infoSemanticLabel;

  /// Accent arc sweep, 0…1 (not in the seed: the Figma arc is static at
  /// ≈ 27 %, used as default). Decorative.
  final double chartValue;

  /// Overrides the composed accessible name.
  final String? semanticLabel;

  /// Figma accent arc: 96.8° of 360°.
  static const double defaultChartValue = 0.269;

  /// Figma web chart diameter (frame not tokenized).
  static const double webChartDiameter = 132;

  bool get _web => type == LooviDashboardCardPrimaryType.web;

  String get _label =>
      semanticLabel ?? '$title: $primaryValue. $label1: $description1. $label2: $description2';

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final muted = TextStyle(color: t.text.onColorDisabled);
    final strong = TextStyle(color: t.text.onColor);

    Widget metric(String label, String value) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: t.typography.bodySmallRegular.merge(muted)),
            Text(value, style: t.typography.headingH2SemiBold.merge(strong)),
          ],
        );

    final Widget body;
    if (_web) {
      body = Padding(
        padding: EdgeInsets.symmetric(vertical: t.spacing.s200, horizontal: t.spacing.s400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: t.typography.bodyMediumSemiBold.merge(muted)),
            SizedBox(height: t.spacing.s100),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox.square(
                  dimension: webChartDiameter,
                  child: CustomPaint(
                    painter: _DonutPainter(
                      track: t.color.backgroundSurfaceInverse1,
                      accent: t.color.actionsSecondary,
                      value: chartValue,
                      accentWidthFactor: 0.10,
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(t.spacing.s200),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(primaryValue,
                              textAlign: TextAlign.center, style: t.typography.headingH1SemiBold.merge(strong)),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: t.spacing.s300),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    metric(label1, description1),
                    SizedBox(height: t.spacing.s100),
                    metric(label2, description2),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      body = Padding(
        padding: EdgeInsets.all(t.spacing.s200),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox.square(
                  dimension: t.spacing.s500,
                  child: CustomPaint(
                    painter: _DonutPainter(
                      track: t.color.backgroundSurfaceInverse0,
                      accent: t.color.actionsSecondary,
                      value: chartValue,
                      accentWidthFactor: 0.12,
                    ),
                    child: Center(
                      child: LooviIcon(LooviIcons.currencyDollarOutline, size: t.spacing.s250, color: t.text.onColor),
                    ),
                  ),
                ),
                Text(primaryValue, style: t.typography.headingH1SemiBold.merge(strong)),
                Text(title, style: t.typography.bodySmallSemiBold.merge(muted)),
              ],
            ),
            SizedBox(width: t.spacing.s200),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                metric(label1, description1),
                SizedBox(height: t.spacing.s025),
                metric(label2, description2),
              ],
            ),
          ],
        ),
      );
    }

    final card = DecoratedBox(
      decoration: BoxDecoration(
        color: t.color.backgroundSurfaceInverse4,
        borderRadius: BorderRadius.circular(t.radius.s400),
      ),
      child: Semantics(container: true, label: _label, child: ExcludeSemantics(child: body)),
    );

    if (!_web || !showInfo) return card;

    final icon = LooviIcon(LooviIcons.infoCircleOutline, size: t.spacing.s200, color: t.text.onColorDisabled);
    final min = LooviTapTarget.minSize(context);
    // The 48 dp target is centered on the 16 icon placed at top spacing/200,
    // right spacing/300 (Figma).
    final half = (min - t.spacing.s200) / 2;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        card,
        Positioned(
          top: t.spacing.s200 - half,
          right: t.spacing.s300 - half,
          child: onInfoPressed == null
              ? Padding(padding: EdgeInsets.all(half), child: icon)
              : Semantics(
                  button: true,
                  label: infoSemanticLabel,
                  child: LooviTapTarget(onTap: onInfoPressed, child: icon),
                ),
        ),
      ],
    );
  }
}

/// Donut: full track ring + accent arc from 12 o'clock (clockwise).
class _DonutPainter extends CustomPainter {
  const _DonutPainter({required this.track, required this.accent, required this.value, required this.accentWidthFactor});

  final Color track;
  final Color accent;
  final double value;
  final double accentWidthFactor;

  @override
  void paint(Canvas canvas, Size size) {
    final d = size.shortestSide;
    final center = size.center(Offset.zero);

    final trackWidth = d * 0.018;
    final trackRadius = d * 0.91 / 2 - trackWidth / 2;
    canvas.drawCircle(
      center,
      trackRadius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = trackWidth
        ..color = track,
    );

    final v = value.clamp(0.0, 1.0);
    if (v <= 0) return;
    final accentWidth = d * accentWidthFactor;
    final accentRadius = d / 2 - accentWidth / 2;
    // Round caps stay inside the arc's angle (Figma rounds the arc corners).
    final sweep = 2 * math.pi * v;
    final cap = math.min((accentWidth / 2) / accentRadius, sweep / 2);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: accentRadius),
      -math.pi / 2 + cap,
      sweep - 2 * cap,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = accentWidth
        ..strokeCap = StrokeCap.round
        ..color = accent,
    );
  }

  @override
  bool shouldRepaint(_DonutPainter old) =>
      old.track != track || old.accent != accent || old.value != value || old.accentWidthFactor != accentWidthFactor;
}
