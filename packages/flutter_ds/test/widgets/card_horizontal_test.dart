import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

Iterable<BoxDecoration> _decos(WidgetTester tester) => tester
    .widgetList<DecoratedBox>(find.descendant(of: find.byType(LooviCardHorizontal), matching: find.byType(DecoratedBox)))
    .map((d) => d.decoration as BoxDecoration);

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('media-and-text: avatar sm, header h3 primary, subhead secondary, media 80 placeholder', (tester) async {
    await pumpLoovi(tester, const LooviCardHorizontal(headerText: 'Header', subheadText: 'Subhead', avatarInitials: 'AB'));
    final avatar = tester.widget<LooviAvatar>(find.byType(LooviAvatar));
    expect(avatar.size, LooviAvatarSize.sm);
    expect(avatar.content, LooviAvatarContent.initials);
    final header = tester.widget<Text>(find.text('Header'));
    expect(header.style!.color, _t.text.primary);
    expect(header.style!.fontSize, _t.typography.headingH3Regular.fontSize);
    expect(tester.widget<Text>(find.text('Subhead')).style!.color, _t.text.secondary);
    expect(_decos(tester).any((d) => d.color == _t.color.backgroundSurface2), isTrue);
    expect(tester.getSize(find.byType(LooviCardHorizontal)).height, greaterThanOrEqualTo(_t.spacing.s1000));
  });

  testWidgets('style maps to the Card*Item surface', (tester) async {
    for (final (style, color) in [
      (LooviCardHorizontalStyle.outlined, _t.color.backgroundSurface0),
      (LooviCardHorizontalStyle.elevated, _t.color.backgroundSurface1),
      (LooviCardHorizontalStyle.filled, _t.color.backgroundSurface2),
    ]) {
      await pumpLoovi(tester, LooviCardHorizontal(style: style, layout: LooviCardHorizontalLayout.slot, slot: const SizedBox(height: 40)));
      expect(_decos(tester).first.color, color);
    }
  });

  testWidgets('media image is drawn with BoxFit.cover', (tester) async {
    final image = MemoryImage(Uint8List(0));
    await pumpLoovi(tester, LooviCardHorizontal(media: image, mediaSemanticLabel: 'Foto'));
    final deco = _decos(tester).firstWhere((d) => d.image != null);
    expect(deco.image!.image, image);
    expect(deco.image!.fit, BoxFit.cover);
    tester.takeException(); // empty bytes cannot decode; only the wiring is under test
  });

  testWidgets('slot layout renders the custom child', (tester) async {
    await pumpLoovi(tester, const LooviCardHorizontal(layout: LooviCardHorizontalLayout.slot, slot: Text('custom')));
    expect(find.text('custom'), findsOneWidget);
    expect(find.byType(LooviAvatar), findsNothing);
  });

  testWidgets('pressable card: button named by its texts, tap fires', (tester) async {
    final handle = tester.ensureSemantics();
    var taps = 0;
    await pumpLoovi(tester, LooviCardHorizontal(key: const Key('c'), onPressed: () => taps++));
    final node = tester.getSemantics(find.byKey(const Key('c')));
    expect(node.getSemanticsData().flagsCollection.isButton, isTrue);
    expect(node.label, contains('Header'));
    await tester.tap(find.byKey(const Key('c')));
    expect(taps, 1);
    handle.dispose();
  });

  testWidgets('textScaler 2: grows, no overflow', (tester) async {
    await pumpLoovi(tester, const LooviCardHorizontal(), textScale: 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('golden: style x layout', (tester) async {
    final gap = SizedBox(height: _t.spacing.s200);
    Widget slot() => Container(
          height: _t.spacing.s800,
          decoration: BoxDecoration(color: _t.color.backgroundSurface2, borderRadius: BorderRadius.circular(_t.radius.s300)),
        );
    await pumpGolden(
      tester,
      Padding(
        key: const Key('golden'),
        padding: EdgeInsets.all(_t.spacing.s200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const LooviCardHorizontal(avatarInitials: 'AB'),
            gap,
            const LooviCardHorizontal(style: LooviCardHorizontalStyle.elevated, avatarInitials: 'AB'),
            gap,
            const LooviCardHorizontal(style: LooviCardHorizontalStyle.filled, avatarInitials: 'AB'),
            gap,
            LooviCardHorizontal(layout: LooviCardHorizontalLayout.slot, slot: slot()),
          ],
        ),
      ),
      height: 420,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/card_horizontal_variants.png'));
  });
}
