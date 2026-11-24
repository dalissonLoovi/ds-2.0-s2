import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

void main() {
  setUpAll(loadGoldenFonts);

  final t = LooviTokens.appCliente;

  testWidgets('64 dp tall at 16:9, radius/100, surface/2, play icon 20 text/on-color', (tester) async {
    await pumpLoovi(tester, const Align(alignment: Alignment.topLeft, child: LooviListItemVideoThumbnail()));
    final size = tester.getSize(find.byType(LooviListItemVideoThumbnail));
    expect(size.height, t.spacing.s800);
    expect(size.width, closeTo(t.spacing.s800 * 16 / 9, 0.01));
    final deco = tester
        .widget<Container>(find.descendant(of: find.byType(LooviListItemVideoThumbnail), matching: find.byType(Container)))
        .decoration! as BoxDecoration;
    expect(deco.color, t.color.backgroundSurface2);
    expect(deco.borderRadius, BorderRadius.circular(t.radius.s100));
    final icon = tester.widget<LooviIcon>(find.byType(LooviIcon));
    expect(icon.name, LooviIcons.playerPlayOutline);
    expect(icon.size, t.spacing.s250);
    expect(icon.color, t.text.onColor);
    expect(tester.getCenter(find.byType(LooviIcon)), tester.getCenter(find.byType(LooviListItemVideoThumbnail)));
  });

  testWidgets('without onPlay: decorative, no button', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const Align(alignment: Alignment.topLeft, child: LooviListItemVideoThumbnail()));
    expect(find.bySemanticsLabel('Reproduzir vídeo'), findsNothing);
    handle.dispose();
  });

  testWidgets('with onPlay: button "Reproduzir vídeo", tap fires, target >= 48', (tester) async {
    final handle = tester.ensureSemantics();
    var plays = 0;
    await pumpLoovi(tester, Align(alignment: Alignment.topLeft, child: LooviListItemVideoThumbnail(onPlay: () => plays++)));
    final node = tester.getSemantics(find.bySemanticsLabel('Reproduzir vídeo'));
    expect(node.getSemanticsData().flagsCollection.isButton, isTrue);
    final size = tester.getSize(find.byType(LooviListItemVideoThumbnail));
    expect(size.height, greaterThanOrEqualTo(48));
    expect(size.width, greaterThanOrEqualTo(48));
    await tester.tap(find.byType(LooviListItemVideoThumbnail));
    expect(plays, 1);
    handle.dispose();
  });

  testWidgets('golden: in ListItem', (tester) async {
    await pumpGolden(
      tester,
      const LooviListItem(
        key: Key('golden'),
        headline: 'Como acionar a assistência',
        supportingText: 'Vídeo · 2 min',
        leading: LooviListItemVideoThumbnail(),
        trailingIcon: LooviIcons.chevronRightOutline,
      ),
      height: 100,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/list_item_video_thumbnail.png'));
  });
}
