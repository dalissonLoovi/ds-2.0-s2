import 'dart:math' as math;

import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

/// Seed `LoadingSpinner.size`: lg 80 · md 64 · sm 32 · xs 24.
enum LooviLoadingSpinnerSize { lg, md, sm, xs }

/// LoadingSpinner (Figma 3062:745) — non-interactive, indeterminate loading
/// indicator. Not for measurable progress (use ProgressBar / ProgressCircle).
///
/// Paint (mode app-cliente):
/// - box: lg `spacing/1000` (80) · md `spacing/800` (64) · sm `spacing/400`
///   (32) · xs `spacing/300` (24).
/// - track: full ring `color/background-surface/3`.
/// - indicator: quarter arc (12 → 3 o'clock) with round caps that stay inside
///   the quadrant, `color/border-feedback/primary`.
/// - ring thickness (Figma geometry, no token): 14 % of the box on lg|md
///   (11.2 / 8.96), 18 % on sm|xs (5.76 / 4.32).
/// - motion (Figma keyframes): the indicator turns 360° linearly in the first
///   67.066 % of a 1.2 s loop, then holds. Static under reduce-motion
///   (`MediaQuery.disableAnimations`).
///
/// Composition: Button and Avatar place a resized `size=sm` instance (Button
/// 24/20, Avatar 32/24/20/16). [dimension] reproduces that: the geometry
/// follows [size] and the box scales to [dimension].
///
/// Accessibility (seed): when the spinner is the only loading announcement it
/// is a polite live region labelled [semanticLabel] (default "Carregando");
/// with [decorative] = true it is hidden (adjacent text already announces it).
class LooviLoadingSpinner extends StatefulWidget {
  const LooviLoadingSpinner({
    super.key,
    this.size = LooviLoadingSpinnerSize.md,
    this.dimension,
    this.decorative = false,
    this.semanticLabel = 'Carregando',
    this.trackColor,
    this.indicatorColor,
  });

  /// Seed `size` (React default `md`).
  final LooviLoadingSpinnerSize size;

  /// Box override for resized instances inside other components (Button,
  /// Avatar). Null = the Figma size of [size].
  final double? dimension;

  /// Seed `decorative`: hide from assistive technologies.
  final bool decorative;

  /// Seed `label`: accessible name when not [decorative].
  final String semanticLabel;

  /// Track override for composition. Default `color/background-surface/3`.
  final Color? trackColor;

  /// Indicator override for composition (Button paints its intent fill).
  /// Default `color/border-feedback/primary`.
  final Color? indicatorColor;

  /// Figma box of [size].
  static double boxFor(LooviTokens t, LooviLoadingSpinnerSize size) => switch (size) {
        LooviLoadingSpinnerSize.lg => t.spacing.s1000,
        LooviLoadingSpinnerSize.md => t.spacing.s800,
        LooviLoadingSpinnerSize.sm => t.spacing.s400,
        LooviLoadingSpinnerSize.xs => t.spacing.s300,
      };

  /// Ring thickness as a fraction of the box (Figma geometry, no token).
  static double strokeFactorFor(LooviLoadingSpinnerSize size) => switch (size) {
        LooviLoadingSpinnerSize.lg || LooviLoadingSpinnerSize.md => 0.14,
        LooviLoadingSpinnerSize.sm || LooviLoadingSpinnerSize.xs => 0.18,
      };

  /// One loop of the Figma keyframes.
  static const Duration period = Duration(milliseconds: 1200);

  /// Fraction of [period] spent turning (then the indicator holds).
  static const double turnFraction = 0.67066;

  @override
  State<LooviLoadingSpinner> createState() => _LooviLoadingSpinnerState();
}

class _LooviLoadingSpinnerState extends State<LooviLoadingSpinner> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: LooviLoadingSpinner.period);
  late final Animation<double> _turns = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0, LooviLoadingSpinner.turnFraction),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (reduceMotion) {
      _controller.stop();
      _controller.value = 0;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final box = widget.dimension ?? LooviLoadingSpinner.boxFor(t, widget.size);
    final stroke = box * LooviLoadingSpinner.strokeFactorFor(widget.size);
    final indicator = widget.indicatorColor ?? t.color.borderFeedbackPrimary;
    final spinner = SizedBox.square(
      dimension: box,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: _RingPainter(color: widget.trackColor ?? t.color.backgroundSurface3, stroke: stroke)),
          RotationTransition(
            turns: _turns,
            child: CustomPaint(painter: _IndicatorPainter(color: indicator, stroke: stroke)),
          ),
        ],
      ),
    );
    if (widget.decorative) return ExcludeSemantics(child: spinner);
    return Semantics(
      container: true,
      liveRegion: true,
      label: widget.semanticLabel,
      child: ExcludeSemantics(child: spinner),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.color, required this.stroke});
  final Color color;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(stroke / 2);
    canvas.drawOval(
      rect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.color != color || old.stroke != stroke;
}

/// Quarter arc whose round caps end exactly on the 12 and 3 o'clock radii.
class _IndicatorPainter extends CustomPainter {
  const _IndicatorPainter({required this.color, required this.stroke});
  final Color color;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.shortestSide / 2 - stroke / 2;
    final cap = math.asin(((stroke / 2) / r).clamp(0.0, 1.0));
    final rect = Rect.fromCircle(center: size.center(Offset.zero), radius: r);
    canvas.drawArc(
      rect,
      -math.pi / 2 + cap,
      math.pi / 2 - 2 * cap,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(_IndicatorPainter old) => old.color != color || old.stroke != stroke;
}
