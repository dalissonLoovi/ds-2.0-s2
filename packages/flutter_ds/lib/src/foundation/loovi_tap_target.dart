import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

/// Guarantees a 48 dp touch target (WCAG 2.2 / Material) around [child]
/// without changing its paint: when the Figma frame is smaller than 48,
/// the painted widget keeps the Figma size and the hit area grows outside it.
///
/// Note: the extra area is part of layout (Flutter can only hit-test inside a
/// widget's bounds), so the widget occupies at least 48 × 48.
class LooviTapTarget extends StatelessWidget {
  const LooviTapTarget({super.key, required this.child, this.onTap, this.enabled = true});

  final Widget child;
  final VoidCallback? onTap;
  final bool enabled;

  /// Minimum touch target in logical px (= spacing/600).
  static double minSize(BuildContext context) => LooviTokens.of(context).spacing.s600;

  @override
  Widget build(BuildContext context) {
    final min = minSize(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enabled ? onTap : null,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: min, minHeight: min),
        child: Center(widthFactor: 1, heightFactor: 1, child: child),
      ),
    );
  }
}
