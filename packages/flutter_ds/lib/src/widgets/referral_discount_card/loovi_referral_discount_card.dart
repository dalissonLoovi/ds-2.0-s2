import 'dart:math' as math;

import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../generated/loovi_icon_names.g.dart';
import '../button/loovi_button.dart';

/// Seed `ReferralDiscountCard.mode`.
enum LooviReferralDiscountCardMode {
  /// Meter (referral count + discount) + 10-step track + savings + CTA.
  status,

  /// Promo header + simulator meta/track/projection + CTA; decorative blurs.
  simulator,

  /// Multi-vehicle / frotista: title + how-it-works + CTA only; blurs.
  fleet,
}

/// ReferralDiscountCard (Figma 4594:995) — Home/Painel referral discount card.
///
/// Rule (seed): 10 referrals = 100 % discount, 10 % per referral. The track
/// has 10 steps; [referrals] (0–10) drives it: steps before the current one
/// are `circle-filled`, the current one is `circle-dot-filled` (2×), the rest
/// `circle-outline`. The visible texts ([referralCount], [discountPercent],
/// [projectedDiscount]…) are formatted by the product — the track is
/// decorative next to them (seed: "expose progress in text").
///
/// Paint (mode app-cliente):
/// - surface `color/background-surface/2`, radius `border/radius/400`,
///   padding `spacing/250`, section gap `spacing/150`.
/// - titles ([title] / [promoTitle] / [fleetTitle]) body/large/semi-bold
///   `text/primary`; [description] / [fleetDescription] body/small/regular
///   `text/secondary` (header gap `spacing/100`).
/// - status metaRow: [referralCount] body/small/semi-bold `text/primary`,
///   [discountPercent] body/small/medium `text/primary` (AA; was
///   actions/primary 3.9:1 on surface/2 until 2026-11-24); min gap
///   `spacing/100` (Figma 8, unbound).
/// - simulator metaRow: [simulatorTitle] body/small/semi-bold (plain text,
///   not a Link) + [referralCount] body/small/regular, `text/primary`; min
///   gap `spacing/200` (Figma 16, unbound).
/// - track: completed/current markers + progressFill `color/actions/primary`;
///   pending rails and `circle-outline` `color/background-surface/0`; rail
///   `spacing/025` thick. Markers 14 / 28 in Figma have no token → drawn at
///   `spacing/150` / `spacing/300` (keeps the 1:2 ratio).
/// - ticks (gap `spacing/025` under the track): only the current step
///   (`text/primary`, AA since 2026-11-24) and 100 % (`text/secondary`) are visible
///   (Figma: other ticks opacity 0), body/small/semi-bold. Figma ticks use an
///   unbound 10 gap (22×, no token) inside a space-between row; here each
///   tick is centered under its marker instead.
/// - status footer (gap `spacing/150`, Figma 12 unbound): [savingsAmount]
///   heading/h2/semi-bold `text/primary` + [savingsCaption] body/small/regular
///   `text/secondary`; CTA.
/// - simulator footer: space-between (the Figma itemSpacing 95 is the value
///   Figma stores for an auto/space-between gap, not a spacer) —
///   [projectedDiscount] body/small/semi-bold + [discountAmount]
///   body/small/regular `text/primary`; CTA.
/// - CTA: [LooviButton] solid/md/intent=secondary ([ctaLabel], default
///   "Convidar"); fleet footer end-aligned.
/// - blurs (simulator, fleet): decorative ellipses in
///   `color/actions/tertiary|secondary|primary` (72 %) and `text/on-color`
///   (80 %), layer blur 64/70. Geometry is illustration (not layout) — kept
///   as the Figma values relative to the 342-wide frame.
class LooviReferralDiscountCard extends StatelessWidget {
  const LooviReferralDiscountCard({
    super.key,
    this.mode = LooviReferralDiscountCardMode.status,
    this.title = 'Descontômetro',
    this.promoTitle = '',
    this.fleetTitle = 'Indique amigos e ganhe desconto',
    this.fleetDescription = '',
    this.description = '',
    this.referrals = 0,
    this.referralCount = '',
    this.discountPercent = '',
    this.savingsAmount = '',
    this.savingsCaption = '',
    this.simulatorTitle = '',
    this.projectedDiscount = '',
    this.discountAmount = '',
    this.ctaLabel = 'Convidar',
    required this.onInvite,
  }) : assert(referrals >= 0 && referrals <= stepCount, 'referrals vai de 0 a 10.');

  /// Track steps (seed: 10 referrals = 100 %).
  static const int stepCount = 10;

  final LooviReferralDiscountCardMode mode;

  /// Seed `title` (status heading, default "Descontômetro").
  final String title;

  /// Seed `promoTitle` (simulator heading).
  final String promoTitle;

  /// Seed `fleetTitle` (fleet heading, default "Indique amigos e ganhe desconto").
  final String fleetTitle;

  /// Seed `fleetDescription` (fleet body; no meter / counts / currency).
  final String fleetDescription;

  /// Seed `description` (simulator body).
  final String description;

  /// Runtime (not a Figma prop): referrals that drive the track, 0–10.
  /// Figma demo = 2 (current marker at 20 %). Ignored on fleet.
  final int referrals;

  /// Seed `referralCount` (status, simulator) — e.g. "2 indicações".
  final String referralCount;

  /// Seed `discountPercent` (status meta).
  final String discountPercent;

  /// Seed `savingsAmount` (status savings hero).
  final String savingsAmount;

  /// Seed `savingsCaption` (status).
  final String savingsCaption;

  /// Seed `simulatorTitle` (simulator, non-interactive).
  final String simulatorTitle;

  /// Seed `projectedDiscount` (simulator).
  final String projectedDiscount;

  /// Seed `discountAmount` (simulator).
  final String discountAmount;

  /// Nested Button label (seed "Convidar").
  final String ctaLabel;

  /// CTA callback (runtime only). Null = CTA disabled.
  final VoidCallback? onInvite;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final cta = LooviButton(label: ctaLabel, onPressed: onInvite, intent: LooviButtonIntent.secondary);
    final titleStyle = t.typography.bodyLargeSemiBold.copyWith(color: t.text.primary);
    final bodyStyle = t.typography.bodySmallRegular.copyWith(color: t.text.secondary);
    final gap = SizedBox(height: t.spacing.s150);

    Widget header(String heading, String body) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(header: true, child: Text(heading, style: titleStyle)),
            if (body.isNotEmpty) ...[SizedBox(height: t.spacing.s100), Text(body, style: bodyStyle)],
          ],
        );

    Widget metaRow(Widget a, Widget b, double minGap) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Expanded(child: a), SizedBox(width: minGap), b],
        );

    final List<Widget> children;
    switch (mode) {
      case LooviReferralDiscountCardMode.status:
        children = [
          Semantics(header: true, child: Text(title, style: titleStyle)),
          gap,
          metaRow(
            Text(referralCount, style: t.typography.bodySmallSemiBold.copyWith(color: t.text.primary)),
            Text(discountPercent, style: t.typography.bodySmallMedium.copyWith(color: t.text.primary)),
            t.spacing.s100,
          ),
          gap,
          _ReferralTrack(referrals: referrals),
          gap,
          Row(
            children: [
              Expanded(
                child: MergeSemantics(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(savingsAmount, style: t.typography.headingH2SemiBold.copyWith(color: t.text.primary)),
                      Text(savingsCaption, style: bodyStyle),
                    ],
                  ),
                ),
              ),
              SizedBox(width: t.spacing.s150),
              cta,
            ],
          ),
        ];
      case LooviReferralDiscountCardMode.simulator:
        final primary = t.text.primary;
        children = [
          header(promoTitle, description),
          gap,
          metaRow(
            Text(simulatorTitle, style: t.typography.bodySmallSemiBold.copyWith(color: primary)),
            Text(referralCount, style: t.typography.bodySmallRegular.copyWith(color: primary)),
            t.spacing.s200,
          ),
          gap,
          _ReferralTrack(referrals: referrals),
          gap,
          Row(
            children: [
              Expanded(
                child: MergeSemantics(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(projectedDiscount, style: t.typography.bodySmallSemiBold.copyWith(color: primary)),
                      Text(discountAmount, style: t.typography.bodySmallRegular.copyWith(color: primary)),
                    ],
                  ),
                ),
              ),
              SizedBox(width: t.spacing.s150),
              cta,
            ],
          ),
        ];
      case LooviReferralDiscountCardMode.fleet:
        children = [
          header(fleetTitle, fleetDescription),
          gap,
          Align(alignment: AlignmentDirectional.centerEnd, child: cta),
        ];
    }

    final radius = BorderRadius.circular(t.radius.s400);
    final content = Padding(
      padding: EdgeInsets.all(t.spacing.s250),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
    );

    return Semantics(
      container: true,
      child: ClipRRect(
        borderRadius: radius,
        child: DecoratedBox(
          decoration: BoxDecoration(color: t.color.backgroundSurface2),
          child: mode == LooviReferralDiscountCardMode.status
              ? content
              : Stack(
                  children: [
                    const Positioned.fill(child: ExcludeSemantics(child: _ReferralBlurs())),
                    content,
                  ],
                ),
        ),
      ),
    );
  }
}

/// 10-step referral track + current / 100 % tick labels. Decorative for
/// assistive tech (the meta texts carry the progress).
class _ReferralTrack extends StatelessWidget {
  const _ReferralTrack({required this.referrals});

  final int referrals;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    const n = LooviReferralDiscountCard.stepCount;
    final current = referrals - 1; // -1 = no referral yet
    final small = t.spacing.s150;
    final big = t.spacing.s300;
    final tickStyle = t.typography.bodySmallSemiBold;

    return ExcludeSemantics(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          // Marker centers evenly spaced between the first and last small marker.
          double cx(int i) => small / 2 + i * (w - small) / (n - 1);
          final cy = big / 2;
          final rail = t.spacing.s025;

          Widget marker(int i) {
            final String icon;
            final double size;
            final Color color;
            if (i < current) {
              (icon, size, color) = (LooviIcons.circleFilled, small, t.color.actionsPrimary);
            } else if (i == current) {
              (icon, size, color) = (LooviIcons.circleDotFilled, big, t.color.actionsPrimary);
            } else {
              (icon, size, color) = (LooviIcons.circleOutline, small, t.color.backgroundSurface0);
            }
            return Positioned(
              left: cx(i) - size / 2,
              top: cy - size / 2,
              child: LooviIcon(icon, size: size, color: color),
            );
          }

          final fillEnd = current >= 0 ? cx(current) : cx(0);
          final track = SizedBox(
            height: big,
            width: w,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: cx(0),
                  right: w - cx(n - 1),
                  top: cy - rail / 2,
                  height: rail,
                  child: ColoredBox(color: t.color.backgroundSurface0),
                ),
                if (current > 0)
                  Positioned(
                    left: cx(0),
                    width: fillEnd - cx(0),
                    top: cy - rail / 2,
                    height: rail,
                    child: ColoredBox(color: t.color.actionsPrimary),
                  ),
                for (var i = 0; i < n; i++) marker(i),
              ],
            ),
          );

          Widget tick(int i, Color color) {
            final label = Text('${(i + 1) * 10}%', maxLines: 1, softWrap: false, style: tickStyle.copyWith(color: color));
            if (i == n - 1) return Positioned.fill(child: Align(alignment: AlignmentDirectional.centerEnd, child: label));
            // Centered under the marker in a marker-wide box (like Figma
            // tick-20), clamped inside the track.
            final left = math.max(0.0, math.min(w - big, cx(i) - big / 2));
            return Positioned(
              left: left,
              width: big,
              top: 0,
              bottom: 0,
              child: OverflowBox(maxWidth: double.infinity, child: Center(child: label)),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              track,
              SizedBox(height: t.spacing.s025),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Line box height of the tick style keeps the row stable.
                  SizedBox(width: w, child: Opacity(opacity: 0, child: Text('100%', style: tickStyle))),
                  if (current != n - 1) tick(n - 1, t.text.secondary),
                  if (current >= 0) tick(current, t.text.primary),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Decorative blur ellipses (simulator / fleet). Values are the Figma frame
/// geometry (342-wide card): center x as a fraction of the width, center y
/// from the top, ellipse size, rotation (clockwise degrees), opacity and
/// layer-blur radius (Figma radius ≈ 2 σ).
class _ReferralBlurs extends StatelessWidget {
  const _ReferralBlurs();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return CustomPaint(
      painter: _BlurPainter([
        _Blob(t.color.actionsTertiary, 0.72, 8.88 / 342, 32.8, 71.38, 54.37, 25.25, 64),
        _Blob(t.text.onColor, 0.8, 180.07 / 342, 57.58, 201, 164.9, -15.71, 70),
        _Blob(t.text.onColor, 0.8, 144.51 / 342, 243.17, 116.17, 115.18, -15.71, 70),
        _Blob(t.color.actionsSecondary, 0.72, 266.5 / 342, 187.0, 137, 120, 161.24, 64),
        _Blob(t.color.actionsPrimary, 0.72, 301.28 / 342, 50.18, 93.18, 117.87, 25.25, 64),
      ]),
    );
  }
}

class _Blob {
  const _Blob(this.color, this.opacity, this.fx, this.cy, this.w, this.h, this.deg, this.blur);
  final Color color;
  final double opacity, fx, cy, w, h, deg, blur;
}

class _BlurPainter extends CustomPainter {
  _BlurPainter(this.blobs);

  final List<_Blob> blobs;

  @override
  void paint(Canvas canvas, Size size) {
    for (final b in blobs) {
      final paint = Paint()
        ..color = b.color.withValues(alpha: b.opacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, b.blur / 2);
      canvas
        ..save()
        ..translate(b.fx * size.width, b.cy)
        ..rotate(b.deg * math.pi / 180)
        ..drawOval(Rect.fromCenter(center: Offset.zero, width: b.w, height: b.h), paint)
        ..restore();
    }
  }

  @override
  bool shouldRepaint(_BlurPainter oldDelegate) => oldDelegate.blobs != blobs;
}
