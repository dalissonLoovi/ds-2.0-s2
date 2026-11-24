import 'dart:ui' show SemanticsRole;

import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../feature_steps_item/loovi_feature_steps_item.dart';

/// FeatureSteps (Figma 4344:224) — vertical illustrative steps container
/// (tasks, benefits, onboarding actions). NOT progress: use VerticalStepper,
/// StepperPrimary or StepProgressIndicator for real step status.
///
/// Seed `items` SLOT takes [LooviFeatureStepsItem] only. The container does
/// not change its items: connector and icon live on each item, so set
/// `showConnector: false` on the final item (seed default composition).
///
/// Paint (mode app-cliente):
/// - root + items: vertical, gap `spacing/0`, padding `spacing/0`, radius
///   `border/radius/0` (nothing painted); width Fill (Figma demo 342), height
///   Hug. Vertical rhythm comes from each item's content padding-bottom
///   `spacing/300` and its stretching connector.
///
/// Semantics: list (`SemanticsRole.list`, named by [semanticLabel]); each item
/// is a list item.
class LooviFeatureSteps extends StatelessWidget {
  const LooviFeatureSteps({super.key, required this.items, this.semanticLabel});

  /// Seed `items` (FeatureStepsItem instances only).
  final List<LooviFeatureStepsItem> items;

  /// Optional accessible name of the list.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return Semantics(
      container: true,
      role: SemanticsRole.list,
      label: semanticLabel,
      explicitChildNodes: true,
      child: Padding(
        padding: EdgeInsets.all(t.spacing.s0),
        child: LooviFeatureStepsScope(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) SizedBox(height: t.spacing.s0),
                items[i],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
