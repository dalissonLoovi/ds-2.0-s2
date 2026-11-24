import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

/// Covers seed ListItemLeadingIllustration (5038:10) and
/// ListItemTrailingIllustration (5038:79) — same anatomy.
void main() {
  setUpAll(loadGoldenFonts);

  final t = LooviTokens.appCliente;

  testWidgets('every catalog asset is bundled', (tester) async {
    for (final i in LooviListItemIllustration.values) {
      final data = await rootBundle.load('packages/loovi_ds/${i.asset}');
      expect(data.lengthInBytes, greaterThan(0), reason: i.asset);
    }
  });

  testWidgets('leading: 56 slot, 52 artwork (inset spacing/025), default sedan', (tester) async {
    await pumpLoovi(tester, const Align(alignment: Alignment.topLeft, child: LooviListItemLeadingIllustration()));
    expect(tester.getSize(find.byType(LooviListItemLeadingIllustration)), Size(t.spacing.s700, t.spacing.s700));
    final svg = find.byType(SvgPicture);
    final art = t.spacing.s700 - 2 * t.spacing.s025;
    expect(tester.getSize(svg), Size(art, art));
    expect(tester.getCenter(svg), tester.getCenter(find.byType(LooviListItemLeadingIllustration)));
    expect(LooviListItemIllustration.sedan.asset, 'assets/illustrations/vehicle/sedan.svg');
  });

  testWidgets('trailing: same 56 slot', (tester) async {
    await pumpLoovi(
      tester,
      const Align(alignment: Alignment.topLeft, child: LooviListItemTrailingIllustration(illustration: LooviListItemIllustration.theft)),
    );
    expect(tester.getSize(find.byType(LooviListItemTrailingIllustration)), Size(t.spacing.s700, t.spacing.s700));
  });

  testWidgets('custom artwork is fitted into the slot', (tester) async {
    await pumpLoovi(
      tester,
      const Align(
        alignment: Alignment.topLeft,
        child: LooviListItemLeadingIllustration(artwork: SizedBox(key: Key('art'), width: 200, height: 100)),
      ),
    );
    expect(tester.getSize(find.byType(LooviListItemLeadingIllustration)), Size(t.spacing.s700, t.spacing.s700));
    expect(find.byType(SvgPicture), findsNothing);
    expect(find.byKey(const Key('art')), findsOneWidget);
  });

  testWidgets('semantics: decorative by default, image with label', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(
      tester,
      const LooviListItem(
        key: Key('row'),
        headline: 'Roubo ou furto',
        leading: LooviListItemLeadingIllustration(illustration: LooviListItemIllustration.theft),
      ),
    );
    expect(tester.getSemantics(find.byKey(const Key('row'))).label, 'Roubo ou furto');
    await pumpLoovi(tester, const Align(alignment: Alignment.topLeft, child: LooviListItemTrailingIllustration(semanticLabel: 'Sedã')));
    expect(tester.getSemantics(find.bySemanticsLabel('Sedã')).getSemanticsData().flagsCollection.isImage, isTrue);
    handle.dispose();
  });

  testWidgets('golden: catalog in ListItem', (tester) async {
    await pumpGolden(
      tester,
      Column(
        key: const Key('golden'),
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final i in LooviListItemIllustration.values)
            LooviListItem(
              condition: LooviListItemCondition.oneLine,
              headline: i.name,
              leading: i.index.isEven ? LooviListItemLeadingIllustration(illustration: i) : null,
              trailing: i.index.isOdd ? LooviListItemTrailingIllustration(illustration: i) : null,
              showDivider: true,
            ),
        ],
      ),
      height: 540,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/list_item_illustrations.png'));
  });
}
