import 'dart:ui' show SemanticsRole;

import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../generated/loovi_icon_names.g.dart';

/// FeatureStepsItem (Figma 4343:222) — illustrative step row (task, benefit,
/// onboarding action) with a thematic icon. NOT progress feedback: there is no
/// completed/current/pending/error status (use VerticalStepperItem for that).
/// Compose inside [LooviFeatureSteps].
///
/// Paint (mode app-cliente):
/// - root: horizontal, gap `spacing/200` badge to content, cross axis center.
/// - indicatorColumn: gap `spacing/0`, fills the row height.
///   - iconBadge: `spacing/600` (48) circle, padding `spacing/150`, fill
///     `color/background-surface/2`, radius `border/radius/full`;
///     [leadingIcon] 24 (`spacing/300`) in `text/primary`.
///   - connector: width `spacing/100`, fill `color/background-surface/2`,
///     stretches to the row bottom so it meets the next badge
///     ([showConnector]; hide it on the last item).
/// - content: gap `spacing/0`, padding-bottom `spacing/300` (vertical rhythm,
///   the parent gap is `spacing/0`).
///   - headline `body/large/semi-bold` + `text/primary`.
///   - supportingText `body/medium/regular` + `text/secondary`, wraps
///     ([showSupportingText]).
///
/// The row is never shorter than the 48 badge (the frame clips the badge when
/// showSupportingText=false: content 46 < 48).
///
/// Semantics: one node with headline + supporting text; icon and connector are
/// decorative. Inside [LooviFeatureSteps] it is a list item.
class LooviFeatureStepsItem extends StatelessWidget {
  const LooviFeatureStepsItem({
    super.key,
    this.leadingIcon = LooviIcons.squareCheckOutline,
    this.headline = 'Label',
    this.supportingText = 'Description',
    this.showSupportingText = true,
    this.showConnector = true,
  });

  /// Seed `leadingIcon` (INSTANCE_SWAP). Seed preferred values:
  /// square-check-outline, car-outline, trophy-outline, camera-outline,
  /// file-outline, checkbox-outline (only the first two are in the package).
  final String leadingIcon;

  /// Seed `headline` (TEXT).
  final String headline;

  /// Seed `supportingText` (TEXT).
  final String supportingText;

  /// Seed `showSupportingText` (default true).
  final bool showSupportingText;

  /// Seed `showConnector` (default true; false on the final item).
  final bool showConnector;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final surface = t.color.backgroundSurface2;
    final badge = t.spacing.s600;
    final inList = LooviFeatureStepsScope.maybeOf(context);
    final hasSupporting = showSupportingText && supportingText.isNotEmpty;

    final indicator = ExcludeSemantics(
      child: SizedBox(
        width: badge,
        child: Column(
          children: [
            Container(
              width: badge,
              height: badge,
              padding: EdgeInsets.all(t.spacing.s150),
              decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(t.radius.full)),
              child: LooviIcon(leadingIcon, size: t.spacing.s300, color: t.text.primary),
            ),
            SizedBox(height: t.spacing.s0),
            Expanded(
              child: showConnector ? SizedBox(width: t.spacing.s100, child: ColoredBox(color: surface)) : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );

    final content = Padding(
      padding: EdgeInsets.only(bottom: t.spacing.s300),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(headline, style: t.typography.bodyLargeSemiBold.copyWith(color: t.text.primary)),
          if (hasSupporting) ...[
            SizedBox(height: t.spacing.s0),
            Text(supportingText, style: t.typography.bodyMediumRegular.copyWith(color: t.text.secondary)),
          ],
        ],
      ),
    );

    return Semantics(
      container: true,
      role: inList ? SemanticsRole.listItem : null,
      label: hasSupporting ? '$headline\n$supportingText' : headline,
      excludeSemantics: true,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            indicator,
            SizedBox(width: t.spacing.s200),
            Expanded(child: content),
          ],
        ),
      ),
    );
  }
}

/// Marks the items slot of [LooviFeatureSteps] so [LooviFeatureStepsItem] can
/// take `SemanticsRole.listItem` (Flutter only allows it under a list node).
/// Internal helper; not part of the public API.
class LooviFeatureStepsScope extends InheritedWidget {
  const LooviFeatureStepsScope({super.key, required super.child});

  static bool maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LooviFeatureStepsScope>() != null;

  @override
  bool updateShouldNotify(LooviFeatureStepsScope oldWidget) => false;
}
