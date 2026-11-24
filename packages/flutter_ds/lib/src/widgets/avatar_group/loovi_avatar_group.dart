import 'dart:math' as math;

import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../generated/loovi_icon_names.g.dart';
import '../avatar/loovi_avatar.dart';

/// Seed `AvatarGroup.size` (same scale as [LooviAvatarSize]).
enum LooviAvatarGroupSize { micro, xs, sm, md, lg, xl }

/// One identity of a [LooviAvatarGroup]: photo, initials or neither
/// (placeholder), as [LooviAvatar] resolves it.
@immutable
class LooviAvatarGroupMember {
  const LooviAvatarGroupMember({this.image, this.initials});

  final ImageProvider? image;
  final String? initials;

  LooviAvatarContent get content => image != null
      ? LooviAvatarContent.image
      : ((initials ?? '').trim().isNotEmpty ? LooviAvatarContent.initials : LooviAvatarContent.placeholder);
}

/// Builds the overflow announcement for [hidden] identities not shown.
typedef LooviAvatarGroupOverflowLabel = String Function(int hidden);

String _defaultOverflowLabel(int hidden) => hidden == 1 ? 'mais 1 pessoa' : 'mais $hidden pessoas';

/// AvatarGroup (Figma 3669:8404) — several related identities (participants,
/// members, customers, drivers) in a compact overlapping row. Not for a
/// single identity.
///
/// Each member is a [LooviAvatar] (paint, initials, placeholder from Avatar).
/// When there are more identities than [maxVisible] (or [totalCount] says so)
/// the more-users-indicator closes the row. It is informational, never a
/// button.
///
/// Paint (mode app-cliente):
/// - row: horizontal, cross axis center, later avatars over earlier ones.
///   Overlap (negative gap, frame not tokenized: token of the same value)
///   `spacing/100` (micro | xs) | `spacing/200` (sm) | `spacing/300`
///   (md | lg | xl).
/// - ring: stroke INSIDE `color/background-surface/0` on every circle, width
///   `border/width/025` (micro) | `border/width/050` (xs | sm | md) | 8
///   (lg | xl; no border-width token of 8: `spacing/100`).
/// - avatar box: Avatar size (`spacing/300|400|600|800|1000|1200`).
/// - more-users-indicator: circle of the avatar box, fill
///   `color/background-surface/3` (Figma aligned 2026-11-24; was text/on-color-disabled 1.4:1), `plus-outline` in
///   `text/secondary` at `spacing/200` (micro | xs) | `spacing/300` (sm) |
///   `spacing/400` (md) | `spacing/500` (lg) | `spacing/600` (xl).
///
/// Semantics: one group node named [semanticLabel] with the overflow count as
/// value ([overflowLabel]); without a label the group is decorative.
class LooviAvatarGroup extends StatelessWidget {
  const LooviAvatarGroup({
    super.key,
    required this.members,
    this.size = LooviAvatarGroupSize.md,
    this.maxVisible = 5,
    this.totalCount,
    this.semanticLabel,
    this.overflowLabel = _defaultOverflowLabel,
  }) : assert(maxVisible > 0, 'maxVisible must be positive'),
       assert(totalCount == null || totalCount >= 0, 'totalCount must be >= 0');

  /// Identities, in display order.
  final List<LooviAvatarGroupMember> members;

  final LooviAvatarGroupSize size;

  /// Avatars painted before the more-users-indicator (Figma: 5).
  final int maxVisible;

  /// Total identities when only part of them is in [members] (e.g. a server
  /// count). Defaults to `members.length`.
  final int? totalCount;

  /// Group accessible name (e.g. "Motoristas da conta"). Null = decorative.
  final String? semanticLabel;

  /// Overflow announcement. Default "mais N pessoas".
  final LooviAvatarGroupOverflowLabel overflowLabel;

  static LooviAvatarSize avatarSizeFor(LooviAvatarGroupSize size) => LooviAvatarSize.values[size.index];

  /// Overlap between neighbours of [size].
  static double overlapFor(LooviTokens t, LooviAvatarGroupSize size) => switch (size) {
    LooviAvatarGroupSize.micro || LooviAvatarGroupSize.xs => t.spacing.s100,
    LooviAvatarGroupSize.sm => t.spacing.s200,
    LooviAvatarGroupSize.md || LooviAvatarGroupSize.lg || LooviAvatarGroupSize.xl => t.spacing.s300,
  };

  /// Ring width of [size].
  static double ringFor(LooviTokens t, LooviAvatarGroupSize size) => switch (size) {
    LooviAvatarGroupSize.micro => t.borderWidth.s025,
    LooviAvatarGroupSize.xs || LooviAvatarGroupSize.sm || LooviAvatarGroupSize.md => t.borderWidth.s050,
    LooviAvatarGroupSize.lg || LooviAvatarGroupSize.xl => t.spacing.s100,
  };

  /// more-users-indicator icon box of [size].
  static double overflowIconFor(LooviTokens t, LooviAvatarGroupSize size) => switch (size) {
    LooviAvatarGroupSize.micro || LooviAvatarGroupSize.xs => t.spacing.s200,
    LooviAvatarGroupSize.sm => t.spacing.s300,
    LooviAvatarGroupSize.md => t.spacing.s400,
    LooviAvatarGroupSize.lg => t.spacing.s500,
    LooviAvatarGroupSize.xl => t.spacing.s600,
  };

  int get _visibleCount => math.min(members.length, maxVisible);

  /// Identities not painted (shown by the more-users-indicator).
  int get hiddenCount => math.max((totalCount ?? members.length) - _visibleCount, 0);

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final avatarSize = avatarSizeFor(size);
    final box = LooviAvatar.boxFor(t, avatarSize);
    final overlap = overlapFor(t, size);
    final ring = ringFor(t, size);
    final hidden = hiddenCount;

    Widget ringed(Widget child) => SizedBox.square(
      dimension: box,
      child: Stack(
        fit: StackFit.expand,
        children: [
          child,
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: t.color.backgroundSurface0, width: ring),
              ),
            ),
          ),
        ],
      ),
    );

    final circles = <Widget>[
      for (final m in members.take(_visibleCount))
        ringed(LooviAvatar(content: m.content, size: avatarSize, image: m.image, initials: m.initials)),
      if (hidden > 0)
        ringed(
          DecoratedBox(
            decoration: BoxDecoration(shape: BoxShape.circle, color: t.color.backgroundSurface3),
            child: Center(
              child: LooviIcon(LooviIcons.plusOutline, size: overflowIconFor(t, size), color: t.text.secondary),
            ),
          ),
        ),
    ];

    final stride = box - overlap;
    final width = circles.isEmpty ? t.spacing.s0 : box + stride * (circles.length - 1);
    final row = SizedBox(
      width: width,
      height: box,
      child: Stack(
        children: [
          for (var i = 0; i < circles.length; i++)
            PositionedDirectional(start: stride * i, top: t.spacing.s0, width: box, height: box, child: circles[i]),
        ],
      ),
    );

    if (semanticLabel == null) return ExcludeSemantics(child: row);
    return Semantics(
      container: true,
      label: semanticLabel,
      value: hidden > 0 ? overflowLabel(hidden) : null,
      excludeSemantics: true,
      child: row,
    );
  }
}
