// Direct src imports until the wave export lands in lib/loovi_ds.dart.

import 'dart:convert';

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// 8x8 gradient PNG standing in for a profile photo (no network in the catalog).
final _photo = MemoryImage(
  base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAYAAADED76LAAAAk0lEQVR4nBXKoZUFIRAAwYvzZ0AGozEY9GgMBj0ag+ms+t6Wrr9fYAuMwBGYgTuwAl/g369j6xgdR8fsuDtWx9e/MLFNjIljYk7cE2vim19IbImROBIzcSdW4ssvLGwLY+FYmAv3wlr41hcOtoNxcBzMg/tgHXznC4WtMApHYRbuwip89YWL7WJcHBfz4r5YF9/Ff9davCGiPj5VAAAAAElFTkSuQmCC',
  ),
);

/// Figma composition: initials, photo, initials, photo, placeholder + overflow.
final _members = [
  const LooviAvatarGroupMember(initials: 'AL'),
  LooviAvatarGroupMember(image: _photo),
  const LooviAvatarGroupMember(initials: 'BR'),
  LooviAvatarGroupMember(image: _photo),
  const LooviAvatarGroupMember(),
  const LooviAvatarGroupMember(initials: 'CM'),
  const LooviAvatarGroupMember(initials: 'DS'),
];

/// AvatarGroup (seed node 3669:8404): Playground + Sizes (same as the golden
/// `avatar_group_sizes.png`).
WidgetbookComponent looviAvatarGroupComponent() => WidgetbookComponent(
  name: 'AvatarGroup',
  useCases: [
    WidgetbookUseCase(
      name: 'Playground',
      builder: (context) {
        final k = context.knobs;
        final count = k.int.slider(label: 'members', initialValue: 7, min: 2, max: _members.length);
        return SeedStory(
          component: 'AvatarGroup',
          child: Align(
            alignment: Alignment.centerLeft,
            child: LooviAvatarGroup(
              members: _members.take(count).toList(),
              size: k.object.dropdown<LooviAvatarGroupSize>(
                label: 'size',
                options: LooviAvatarGroupSize.values,
                initialOption: LooviAvatarGroupSize.md,
                labelBuilder: (v) => v.name,
              ),
              maxVisible: k.int.slider(label: 'maxVisible', initialValue: 5, min: 1, max: 7),
              semanticLabel: k.string(label: 'accessible label', initialValue: 'Motoristas da conta'),
            ),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Sizes',
      builder: (context) => const SeedStory(component: 'AvatarGroup', showDescription: false, child: _Sizes()),
    ),
  ],
);

class _Sizes extends StatelessWidget {
  const _Sizes();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final s in LooviAvatarGroupSize.values.reversed) ...[
          LooviAvatarGroup(members: _members, size: s),
          SizedBox(height: t.spacing.s200),
        ],
      ],
    );
  }
}
