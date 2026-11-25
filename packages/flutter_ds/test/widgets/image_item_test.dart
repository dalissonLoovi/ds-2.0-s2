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

  Widget sized(Widget child, {double width = 240}) => Align(alignment: Alignment.topLeft, child: SizedBox(width: width, child: child));

  BoxDecoration surface(WidgetTester tester) => tester
      .widget<DecoratedBox>(find.descendant(of: find.byType(LooviImageItem), matching: find.byType(DecoratedBox)).first)
      .decoration as BoxDecoration;

  group('size (verticalResize=false locks width)', () {
    for (final (ratio, orientation, expected) in [
      (LooviImageItemAspectRatio.ratio1x1, LooviImageItemOrientation.landscape, const Size(240, 240)),
      (LooviImageItemAspectRatio.ratio4x3, LooviImageItemOrientation.landscape, const Size(240, 180)),
      (LooviImageItemAspectRatio.ratio3x2, LooviImageItemOrientation.portrait, const Size(240, 360)),
      (LooviImageItemAspectRatio.ratio16x9, LooviImageItemOrientation.landscape, const Size(240, 135)),
      (LooviImageItemAspectRatio.ratio2x1, LooviImageItemOrientation.portrait, const Size(240, 480)),
    ]) {
      testWidgets('$ratio $orientation', (tester) async {
        await pumpLoovi(tester, sized(LooviImageItem(aspectRatio: ratio, orientation: orientation)));
        expect(tester.getSize(find.byType(LooviImageItem)), expected);
      });
    }
  });

  testWidgets('verticalResize=true locks height and hugs width', (tester) async {
    await pumpLoovi(
      tester,
      const Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          height: 120,
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              height: 120,
              child: LooviImageItem(aspectRatio: LooviImageItemAspectRatio.ratio16x9, verticalResize: true),
            ),
          ),
        ),
      ),
    );
    final size = tester.getSize(find.byType(LooviImageItem));
    expect(size.height, 120);
    expect(size.width, closeTo(120 * 16 / 9, 0.01));
  });

  testWidgets('placeholder surface/1, image cover, radius/200', (tester) async {
    await pumpLoovi(tester, sized(const LooviImageItem()));
    expect(surface(tester).color, t.color.backgroundSurface1);
    expect(surface(tester).image, isNull);
    final clip = tester.widget<ClipRRect>(find.descendant(of: find.byType(LooviImageItem), matching: find.byType(ClipRRect)));
    expect(clip.borderRadius, BorderRadius.circular(t.radius.s200));

    await pumpLoovi(tester, sized(LooviImageItem(image: _pixel)));
    expect(surface(tester).image!.image, _pixel);
    expect(surface(tester).image!.fit, BoxFit.cover);
  });

  testWidgets('overlays toggle', (tester) async {
    await pumpLoovi(tester, sized(const LooviImageItem()));
    expect(find.byType(LooviPhotoTextItem), findsNothing);
    expect(find.text('Horizontal'), findsNothing);

    await pumpLoovi(
      tester,
      sized(const LooviImageItem(
        aspectRatio: LooviImageItemAspectRatio.ratio3x2,
        orientation: LooviImageItemOrientation.portrait,
        showOrientationItem: true,
        showPhotoTextItem: true,
        photoTextLabel: 'Seguro auto',
        photoTextSupportingText: 'Proteção completa',
      )),
    );
    expect(find.byType(LooviPhotoTextItem), findsOneWidget);
    expect(find.text('Seguro auto'), findsOneWidget);
    expect(find.text('2:3'), findsOneWidget);
    expect(find.text('Vertical'), findsOneWidget);
    // Photo text fills the whole surface (STRETCH/STRETCH).
    expect(tester.getSize(find.byType(LooviPhotoTextItem)), tester.getSize(find.byType(LooviImageItem)));
  });

  testWidgets('semantics: decorative without alt; image with alt; photo text read', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, sized(const LooviImageItem(showOrientationItem: true)));
    expect(find.bySemanticsLabel(RegExp('Horizontal')), findsNothing);

    await pumpLoovi(tester, sized(const LooviImageItem(semanticLabel: 'Carro na estrada')));
    expect(tester.getSemantics(find.bySemanticsLabel('Carro na estrada')).getSemanticsData().flagsCollection.isImage, isTrue);

    await pumpLoovi(tester, sized(const LooviImageItem(showPhotoTextItem: true, photoTextLabel: 'Seguro auto')));
    expect(find.bySemanticsLabel('Seguro auto'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('golden: aspect ratios + overlays', (tester) async {
    await pumpGolden(
      tester,
      Builder(
        builder: (context) {
          final t = LooviTokens.of(context);
          return Padding(
            key: const Key('golden'),
            padding: EdgeInsets.all(t.spacing.s200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: LooviImageItem(aspectRatio: LooviImageItemAspectRatio.ratio3x2, showOrientationItem: true),
                    ),
                    SizedBox(width: t.spacing.s200),
                    const Expanded(
                      child: LooviImageItem(
                        aspectRatio: LooviImageItemAspectRatio.ratio3x2,
                        orientation: LooviImageItemOrientation.portrait,
                        showOrientationItem: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: t.spacing.s200),
                const LooviImageItem(
                  aspectRatio: LooviImageItemAspectRatio.ratio16x9,
                  showPhotoTextItem: true,
                  photoTextLabel: 'Seguro auto',
                  photoTextSupportingText: 'Proteção completa para o seu carro',
                ),
              ],
            ),
          );
        },
      ),
      height: 520,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/image_item.png'));
  });
}
