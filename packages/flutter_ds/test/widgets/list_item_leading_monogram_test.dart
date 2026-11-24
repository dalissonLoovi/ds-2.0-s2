import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

void main() {
  setUpAll(loadGoldenFonts);

  final t = LooviTokens.appCliente;

  testWidgets('40 dp surface/2 circle with initial in body/large/medium text/primary', (tester) async {
    await pumpLoovi(tester, const Align(alignment: Alignment.topLeft, child: LooviListItemLeadingMonogram('A')));
    expect(tester.getSize(find.byType(LooviListItemLeadingMonogram)), Size(t.spacing.s500, t.spacing.s500));
    final box = tester.widget<Container>(find.descendant(of: find.byType(LooviListItemLeadingMonogram), matching: find.byType(Container)));
    final deco = box.decoration! as BoxDecoration;
    expect(deco.color, t.color.backgroundSurface2);
    expect(deco.borderRadius, BorderRadius.circular(t.radius.full));
    final text = tester.widget<Text>(find.text('A'));
    expect(text.style!.color, t.text.primary);
    expect(text.style!.fontSize, t.typography.bodyLargeMedium.fontSize);
    expect(text.style!.fontWeight, t.typography.bodyLargeMedium.fontWeight);
  });

  testWidgets('decorative: row label names the entity', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const LooviListItem(key: Key('row'), headline: 'Ana Souza', leading: LooviListItemLeadingMonogram('A')));
    expect(tester.getSemantics(find.byKey(const Key('row'))).label, 'Ana Souza');
    expect(find.bySemanticsLabel('A'), findsNothing);
    handle.dispose();
  });

  testWidgets('large text scale stays inside the 40 dp circle', (tester) async {
    await pumpLoovi(tester, const Align(alignment: Alignment.topLeft, child: LooviListItemLeadingMonogram('W')), textScale: 3);
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(LooviListItemLeadingMonogram)).height, t.spacing.s500);
  });

  testWidgets('LooviListItemMonogram stays as an alias', (tester) async {
    await pumpLoovi(tester, const Align(alignment: Alignment.topLeft, child: LooviListItemMonogram('C')));
    expect(find.byType(LooviListItemLeadingMonogram), findsOneWidget);
  });

  testWidgets('golden: in ListItem', (tester) async {
    await pumpGolden(
      tester,
      const Column(
        key: Key('golden'),
        mainAxisSize: MainAxisSize.min,
        children: [
          LooviListItem(condition: LooviListItemCondition.oneLine, headline: 'Ana Souza', leading: LooviListItemLeadingMonogram('A'), showDivider: true),
          LooviListItem(condition: LooviListItemCondition.twoLine, headline: 'Carlos Lima', supportingText: 'Dependente', leading: LooviListItemLeadingMonogram('C')),
        ],
      ),
      height: 140,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/list_item_leading_monogram.png'));
  });
}
