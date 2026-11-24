import 'dart:convert';

import 'package:loovi_ds/loovi_ds.dart';
// ignore: implementation_imports — direct import until loovi_ds.dart exports the widget.
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// 8×8 gradient PNG standing in for a profile photo (no network in the catalog).
final _photo = MemoryImage(
  base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAYAAADED76LAAAAk0lEQVR4nBXKoZUFIRAAwYvzZ0AGozEY9GgMBj0ag+ms+t6Wrr9fYAuMwBGYgTuwAl/g369j6xgdR8fsuDtWx9e/MLFNjIljYk7cE2vim19IbImROBIzcSdW4ssvLGwLY+FYmAv3wlr41hcOtoNxcBzMg/tgHXznC4WtMApHYRbuwip89YWL7WJcHBfz4r5YF9/Ff9davCGiPj5VAAAAAElFTkSuQmCC',
  ),
);

const _states = ['default', 'hover', 'focus', 'disabled', 'loading'];

/// Avatar (seed node 3669:8605): Playground + Matrix + Sizes.
/// Seed `state`: hover/focus are runtime (forced here for the catalog);
/// disabled and loading are knobs. Hover only on pointer devices.
WidgetbookComponent looviAvatarComponent() => WidgetbookComponent(
  name: 'Avatar',
  useCases: [
    WidgetbookUseCase(
      name: 'Playground',
      builder: (context) {
        final k = context.knobs;
        final interactive = k.boolean(label: 'interactive (AvatarButton / AvatarUpload)');
        return SeedStory(
          component: 'Avatar',
          child: Align(
            alignment: Alignment.centerLeft,
            child: LooviAvatar(
              content: k.object.dropdown<LooviAvatarContent>(
                label: 'content',
                options: LooviAvatarContent.values,
                initialOption: LooviAvatarContent.initials,
                labelBuilder: (v) => v.name,
              ),
              size: k.object.dropdown<LooviAvatarSize>(
                label: 'size',
                options: LooviAvatarSize.values,
                initialOption: LooviAvatarSize.md,
                labelBuilder: (v) => v.name,
              ),
              image: _photo,
              initials: k.string(label: 'initials', initialValue: 'SO'),
              disabled: k.boolean(label: 'disabled'),
              loading: k.boolean(label: 'loading'),
              onPressed: interactive ? () {} : null,
              semanticLabel: interactive ? 'Alterar foto de perfil' : null,
            ),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Matrix',
      builder: (context) => const SeedStory(component: 'Avatar', showDescription: false, child: _AvatarMatrix()),
    ),
    WidgetbookUseCase(
      name: 'Sizes',
      builder: (context) {
        final t = LooviTokens.of(context);
        return SeedStory(
          component: 'Avatar',
          showDescription: false,
          child: Row(
            children: [
              for (final s in LooviAvatarSize.values.reversed) ...[
                LooviAvatar(content: LooviAvatarContent.initials, initials: 'SO', size: s),
                SizedBox(width: t.spacing.s050),
              ],
            ],
          ),
        );
      },
    ),
  ],
);

/// content × size (md, sm, micro) × state. Same as the golden `avatar_matrix.png`.
class _AvatarMatrix extends StatelessWidget {
  const _AvatarMatrix();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget cell(LooviAvatarContent c, LooviAvatarSize s, String state) => LooviAvatar(
      content: c,
      size: s,
      image: _photo,
      initials: 'SO',
      disabled: state == 'disabled',
      loading: state == 'loading',
      onPressed: state == 'hover' || state == 'focus' ? () {} : null,
      statesController: switch (state) {
        'hover' => WidgetStatesController({WidgetState.hovered}),
        'focus' => WidgetStatesController({WidgetState.focused}),
        _ => null,
      },
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final c in LooviAvatarContent.values) ...[
          for (final s in [LooviAvatarSize.md, LooviAvatarSize.sm, LooviAvatarSize.micro])
            Padding(
              padding: EdgeInsets.only(bottom: t.spacing.s050),
              child: Row(
                children: [
                  for (final st in _states)
                    SizedBox(width: t.spacing.s900, child: Center(child: cell(c, s, st))),
                ],
              ),
            ),
          SizedBox(height: t.spacing.s100),
        ],
      ],
    );
  }
}
