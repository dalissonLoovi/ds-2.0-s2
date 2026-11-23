import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/pump.dart';

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('every LooviIcons name renders (alias assets present)', (tester) async {
    await pumpGolden(
      tester,
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [for (final n in LooviIcons.all) LooviIcon(n)],
      ),
      height: 120,
    );
    expect(find.byType(LooviIcon), findsNWidgets(LooviIcons.all.length));
    await expectLater(find.byType(Wrap), matchesGoldenFile('goldens/foundation_icons.png'));
  });

  testWidgets('LooviIcon semantics: decorative by default, labelled when asked', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const Row(children: [
      LooviIcon(LooviIcons.bellOutline),
      LooviIcon(LooviIcons.searchOutline, semanticLabel: 'Buscar'),
    ]));
    expect(find.bySemanticsLabel('Buscar'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('LooviTapTarget grows hit area to 48 without resizing paint', (tester) async {
    var taps = 0;
    await pumpLoovi(tester, Align(
      alignment: Alignment.topLeft,
      child: LooviTapTarget(onTap: () => taps++, child: const SizedBox(key: Key('paint'), width: 32, height: 32)),
    ));
    expect(tester.getSize(find.byKey(const Key('paint'))), const Size(32, 32));
    expect(tester.getSize(find.byType(LooviTapTarget)), const Size(48, 48));
    await tester.tapAt(tester.getTopLeft(find.byType(LooviTapTarget)) + const Offset(2, 2));
    expect(taps, 1);
  });

  test('seed catalog has every component', () {
    expect(LooviSeedCatalog.components.length, 130);
    expect(LooviSeedCatalog.of('Button').nodeId, '3104:3723');
  });
}
