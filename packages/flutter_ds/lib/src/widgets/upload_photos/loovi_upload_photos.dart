import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../generated/loovi_icon_names.g.dart';
import '../button/loovi_button.dart';
import '../chip_tag/loovi_chip_tag.dart';

/// Seed `UploadPhotos.status` (business lifecycle, not interaction state).
/// `in-review` → [inReview].
enum LooviUploadPhotosStatus { pending, inReview, approved, rejected }

/// UploadPhotos (Figma 3581:7597) — one required photo / visual document and
/// its lifecycle status. The app captures and uploads the photo: the action
/// calls [onSelectPhoto] (pending) or [onRetakePhoto] (rejected).
///
/// Paint (mode app-cliente):
/// - root: min height `spacing/800` (64), padding-left `spacing/200`,
///   padding-right `spacing/100`, gap `spacing/150`, radius
///   `border/radius/300`; fill `color/background-surface/2` (pending |
///   rejected) or `color/background-surface/1` (in-review | approved) —
///   intentional by status.
/// - leading [icon] (`camera-outline`) 24 (`spacing/300`) `text/primary`.
/// - content: padding-y `spacing/200`, gap `spacing/050`; label
///   `body/medium/medium` `text/primary`; description `body/small/regular`
///   `text/secondary`.
/// - status tag: `LooviChipTag` sm / hug / emphasis primary — in-review
///   `system` (no icon) "Em análise"; approved `success` + circle-check
///   "Aprovada"; rejected "Reprovada" + `alert-circle-outline` painted with
///   `color/background-feedback-primary/warning` (Figma: intent danger with a
///   warning fill override → [LooviChipTagIntent.warning], identical paint).
/// - action (pending | rejected): `LooviButton` text / sm / primary,
///   showLabel=false + trailing `chevron-right-outline`; the hidden label
///   ("Adicionar foto" / "Refazer foto") is the accessible name.
///
/// Accessibility: label, description and status tag are exposed as text; the
/// action is the only focusable element (in-review / approved are
/// informational).
class LooviUploadPhotos extends StatelessWidget {
  const LooviUploadPhotos({
    super.key,
    required this.label,
    this.status = LooviUploadPhotosStatus.pending,
    this.description = '',
    this.showDescription = false,
    this.onSelectPhoto,
    this.onRetakePhoto,
    this.icon = LooviIcons.cameraOutline,
    this.selectPhotoLabel = 'Adicionar foto',
    this.retakePhotoLabel = 'Refazer foto',
    this.inReviewLabel = 'Em análise',
    this.approvedLabel = 'Aprovada',
    this.rejectedLabel = 'Reprovada',
  });

  /// Seed `label`: required photo / task name.
  final String label;

  final LooviUploadPhotosStatus status;

  /// Seed `description` (shown when [showDescription]).
  final String description;

  /// Seed `showDescription` (default false).
  final bool showDescription;

  /// Action on status=pending (the app opens camera / gallery).
  final VoidCallback? onSelectPhoto;

  /// Action on status=rejected.
  final VoidCallback? onRetakePhoto;

  /// Leading icon (Figma `camera-outline`).
  final String icon;

  /// Accessible name of the pending action (Button label prop).
  final String selectPhotoLabel;

  /// Accessible name of the rejected action (Button label prop).
  final String retakePhotoLabel;

  final String inReviewLabel;
  final String approvedLabel;
  final String rejectedLabel;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final surface2 = status == LooviUploadPhotosStatus.pending || status == LooviUploadPhotosStatus.rejected;

    Widget chip(String text, LooviChipTagIntent intent, {String? leadingIcon}) => LooviChipTag(
          label: text,
          size: LooviChipTagSize.sm,
          intent: intent,
          emphasis: LooviChipTagEmphasis.primary,
          showLeadingIcon: leadingIcon != null,
          leadingIcon: leadingIcon ?? LooviIcons.circleCheckFilled,
        );

    Widget action(String a11yLabel, VoidCallback? onPressed) => LooviButton(
          label: a11yLabel,
          onPressed: onPressed,
          variant: LooviButtonVariant.text,
          size: LooviButtonSize.sm,
          showLabel: false,
          showTrailingIcon: true,
        );

    final trailing = <Widget>[
      switch (status) {
        LooviUploadPhotosStatus.pending => action(selectPhotoLabel, onSelectPhoto),
        LooviUploadPhotosStatus.inReview => chip(inReviewLabel, LooviChipTagIntent.system),
        // Figma circle-check-outline is not in the icon package yet.
        LooviUploadPhotosStatus.approved =>
          chip(approvedLabel, LooviChipTagIntent.success, leadingIcon: LooviIcons.circleCheckFilled),
        LooviUploadPhotosStatus.rejected =>
          chip(rejectedLabel, LooviChipTagIntent.warning, leadingIcon: LooviIcons.alertCircleOutline),
      },
      if (status == LooviUploadPhotosStatus.rejected) action(retakePhotoLabel, onRetakePhoto),
    ];

    final content = Padding(
      padding: EdgeInsets.symmetric(vertical: t.spacing.s200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: t.typography.bodyMediumMedium.copyWith(color: t.text.primary)),
          if (showDescription && description.isNotEmpty) ...[
            SizedBox(height: t.spacing.s050),
            Text(description, style: t.typography.bodySmallRegular.copyWith(color: t.text.secondary)),
          ],
        ],
      ),
    );

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: surface2 ? t.color.backgroundSurface2 : t.color.backgroundSurface1,
          borderRadius: BorderRadius.circular(t.radius.s300),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: t.spacing.s800),
          child: Padding(
            padding: EdgeInsets.only(left: t.spacing.s200, right: t.spacing.s100),
            child: Row(
              children: [
                LooviIcon(icon, size: t.spacing.s300, color: t.text.primary),
                SizedBox(width: t.spacing.s150),
                Expanded(child: content),
                for (final w in trailing) ...[SizedBox(width: t.spacing.s150), w],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
