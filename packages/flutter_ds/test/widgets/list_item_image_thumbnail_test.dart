import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

/// 1×1 PNG (no bundled photos in the package).
final _pixel = MemoryImage(Uint8List.fromList(const [
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, //
  0x00, 0x00, 0x00, 0x01, 0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x44, 0x41, //
  0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, 0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, //
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
]));

void main() {
  setUpAll(loadGoldenFonts);

  final t = LooviTokens.appCliente;

  BoxDecoration deco(WidgetTester tester) => tester
      .widget<Container>(find.descendant(of: find.byType(LooviListItemImageThumbnail), matching: find.byType(Container)))
      .decoration! as BoxDecoration;

  testWidgets('56 dp, radius/100, surface/2 placeholder', (tester) async {
    await pumpLoovi(tester, const Align(alignment: Alignment.topLeft, child: LooviListItemImageThumbnail()));
    expect(tester.getSize(find.byType(LooviListItemImageThumbnail)), Size(t.spacing.s700, t.spacing.s700));
    expect(deco(tester).color, t.color.backgroundSurface2);
    expect(deco(tester).borderRadius, BorderRadius.circular(t.radius.s100));
    expect(deco(tester).image, isNull);
  });

  testWidgets('app image fills with cover over the placeholder', (tester) async {
    await pumpLoovi(tester, Align(alignment: Alignment.topLeft, child: LooviListItemImageThumbnail(image: _pixel)));
    expect(deco(tester).image!.image, _pixel);
    expect(deco(tester).image!.fit, BoxFit.cover);
    expect(deco(tester).color, t.color.backgroundSurface2);
  });

  testWidgets('semantics: decorative by default, image with alt', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const Align(alignment: Alignment.topLeft, child: LooviListItemImageThumbnail()));
    expect(find.bySemanticsLabel('Foto do veículo'), findsNothing);
    await pumpLoovi(tester, const Align(alignment: Alignment.topLeft, child: LooviListItemImageThumbnail(semanticLabel: 'Foto do veículo')));
    final node = tester.getSemantics(find.bySemanticsLabel('Foto do veículo'));
    expect(node.getSemanticsData().flagsCollection.isImage, isTrue);
    handle.dispose();
  });

  testWidgets('golden: in ListItem', (tester) async {
    await pumpGolden(
      tester,
      const LooviListItem(
        key: Key('golden'),
        headline: 'Vistoria do veículo',
        supportingText: 'Envie as fotos do veículo pelo app.',
        leading: LooviListItemImageThumbnail(),
        trailingIcon: LooviIcons.chevronRightOutline,
      ),
      height: 100,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/list_item_image_thumbnail.png'));
  });
}
