import 'dart:ui' show SemanticsAction;

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

/// 8x8 gradient PNG standing in for a profile photo.
final _photo = MemoryImage(base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAYAAADED76LAAAAk0lEQVR4nBXKoZUFIRAAwYvzZ0AGozEY9GgMBj0ag+ms+t6Wrr9fYAuMwBGYgTuwAl/g369j6xgdR8fsuDtWx9e/MLFNjIljYk7cE2vim19IbImROBIzcSdW4ssvLGwLY+FYmAv3wlr41hcOtoNxcBzMg/tgHXznC4WtMApHYRbuwip89YWL7WJcHBfz4r5YF9/Ff9davCGiPj5VAAAAAElFTkSuQmCC',
));

/// Figma composition: initials, photo, initials, photo, placeholder + overflow.
List<LooviAvatarGroupMember> avatarGroupDemoMembers(ImageProvider photo) => [
  const LooviAvatarGroupMember(initials: 'AL'),
  LooviAvatarGroupMember(image: photo),
  const LooviAvatarGroupMember(initials: 'BR'),
  LooviAvatarGroupMember(image: photo),
  const LooviAvatarGroupMember(),
  const LooviAvatarGroupMember(initials: 'CM'),
  const LooviAvatarGroupMember(initials: 'DS'),
];

/// Story "Sizes": every size, 5 visible + overflow. Same as the Widgetbook story.
class AvatarGroupSizes extends StatelessWidget {
  const AvatarGroupSizes({super.key, required this.photo});
  final ImageProvider photo;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: Padding(
        padding: EdgeInsets.all(t.spacing.s200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final s in LooviAvatarGroupSize.values.reversed) ...[
              LooviAvatarGroup(members: avatarGroupDemoMembers(photo), size: s),
              SizedBox(height: t.spacing.s200),
            ],
          ],
        ),
      ),
    );
  }
}

Future<void> _precache(WidgetTester tester) async {
  await tester.runAsync(() async {
    await precacheImage(_photo, tester.element(find.byType(Scaffold)));
  });
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('md: 5 avatars + indicator, overlap spacing/300, ring border/width/050 surface/0', (tester) async {
    await pumpLoovi(tester, Align(alignment: Alignment.centerLeft, child: LooviAvatarGroup(members: avatarGroupDemoMembers(_photo))));
    expect(find.byType(LooviAvatar), findsNWidgets(5));
    final avatars = find.byType(LooviAvatar);
    final box = _t.spacing.s800;
    expect(tester.getSize(avatars.first), Size.square(box));
    expect(tester.getRect(avatars.at(1)).left - tester.getRect(avatars.first).left, box - _t.spacing.s300);
    // 5 avatars + indicator: 64 + 5 * 40.
    expect(tester.getSize(find.byType(LooviAvatarGroup)).width, box + 5 * (box - _t.spacing.s300));
    final ring = tester
        .widgetList<DecoratedBox>(find.descendant(of: find.byType(LooviAvatarGroup), matching: find.byType(DecoratedBox)))
        .map((d) => d.decoration as BoxDecoration)
        .firstWhere((d) => d.border != null);
    final side = (ring.border! as Border).top;
    expect(side.color, _t.color.backgroundSurface0);
    expect(side.width, _t.borderWidth.s050);
    expect(side.strokeAlign, BorderSide.strokeAlignInside);
  });

  testWidgets('indicator: on-color-disabled fill, plus-outline on-color; sized per size', (tester) async {
    await pumpLoovi(tester, LooviAvatarGroup(members: avatarGroupDemoMembers(_photo), size: LooviAvatarGroupSize.xl));
    final icon = tester.widget<LooviIcon>(find.byType(LooviIcon).last);
    expect(icon.name, LooviIcons.plusOutline);
    expect(icon.color, _t.text.secondary);
    expect(icon.size, _t.spacing.s600);
    final fill = tester
        .widgetList<DecoratedBox>(find.descendant(of: find.byType(LooviAvatarGroup), matching: find.byType(DecoratedBox)))
        .map((d) => d.decoration as BoxDecoration)
        .where((d) => d.color == _t.color.backgroundSurface3);
    expect(fill, isNotEmpty);
  });

  testWidgets('per-size overlap and ring', (tester) async {
    expect(LooviAvatarGroup.overlapFor(_t, LooviAvatarGroupSize.micro), _t.spacing.s100);
    expect(LooviAvatarGroup.overlapFor(_t, LooviAvatarGroupSize.sm), _t.spacing.s200);
    expect(LooviAvatarGroup.overlapFor(_t, LooviAvatarGroupSize.xl), _t.spacing.s300);
    expect(LooviAvatarGroup.ringFor(_t, LooviAvatarGroupSize.micro), _t.borderWidth.s025);
    expect(LooviAvatarGroup.ringFor(_t, LooviAvatarGroupSize.lg), 8);
  });

  testWidgets('no overflow indicator when everyone fits; totalCount adds hidden people', (tester) async {
    await pumpLoovi(tester, const LooviAvatarGroup(members: [LooviAvatarGroupMember(initials: 'AL'), LooviAvatarGroupMember(initials: 'BR')]));
    expect(find.byType(LooviIcon), findsNothing);
    await pumpLoovi(tester, const LooviAvatarGroup(members: [LooviAvatarGroupMember(initials: 'AL')], totalCount: 4));
    expect(find.byType(LooviIcon), findsOneWidget);
    expect(const LooviAvatarGroup(members: [LooviAvatarGroupMember(initials: 'AL')], totalCount: 4).hiddenCount, 3);
  });

  testWidgets('semantics: group label + overflow value; not focusable; decorative without label', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, LooviAvatarGroup(members: avatarGroupDemoMembers(_photo), semanticLabel: 'Motoristas'));
    final node = tester.getSemantics(find.bySemanticsLabel('Motoristas'));
    expect(node.value, 'mais 2 pessoas');
    expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
    await pumpLoovi(tester, LooviAvatarGroup(members: avatarGroupDemoMembers(_photo)));
    expect(find.bySemanticsLabel('Motoristas'), findsNothing);
    handle.dispose();
  });

  testWidgets('golden: sizes', (tester) async {
    await pumpGolden(tester, AvatarGroupSizes(photo: _photo), height: 480);
    await _precache(tester);
    await expectLater(find.byType(AvatarGroupSizes), matchesGoldenFile('../goldens/avatar_group_sizes.png'));
  });
}
