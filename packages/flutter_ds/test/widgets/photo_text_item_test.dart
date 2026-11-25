import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

void main() {
  setUpAll(loadGoldenFonts);

  final t = LooviTokens.appCliente;

  Widget box(Widget child) => Align(alignment: Alignment.topLeft, child: SizedBox(width: 240, height: 200, child: child));

  testWidgets('label body/medium/medium on-color; supporting body/small/regular', (tester) async {
    await pumpLoovi(tester, box(const LooviPhotoTextItem(label: 'Label', supportingText: 'Supporting text')));
    final label = tester.widget<Text>(find.text('Label'));
    expect(label.style!.color, t.text.onColor);
    expect(label.style!.fontSize, t.typography.bodyMediumMedium.fontSize);
    expect(label.style!.fontWeight, t.typography.bodyMediumMedium.fontWeight);
    final supporting = tester.widget<Text>(find.text('Supporting text'));
    expect(supporting.style!.color, t.text.onColor);
    expect(supporting.style!.fontWeight, t.typography.bodySmallRegular.fontWeight);
    // Full bleed + bottom-aligned content with spacing/200 padding.
    expect(tester.getSize(find.byType(LooviPhotoTextItem)), const Size(240, 200));
    final labelRect = tester.getRect(find.text('Label'));
    expect(labelRect.left, t.spacing.s200);
    expect(tester.getRect(find.text('Supporting text')).bottom, 200 - t.spacing.s200);
  });

  testWidgets('showSupportingText=false hides the second line', (tester) async {
    await pumpLoovi(tester, box(const LooviPhotoTextItem(label: 'Label')));
    expect(find.byType(Text), findsOneWidget);
    expect(tester.getRect(find.text('Label')).bottom, 200 - t.spacing.s200);
  });

  test('backing scrim keeps white text AA over a white photo', () {
    final band = t.interactive.overlay.withValues(alpha: LooviPhotoTextScrim.backing);
    final composite = Color.alphaBlend(band, const Color(0xFFFFFFFF));
    final l1 = t.text.onColor.computeLuminance();
    final l2 = composite.computeLuminance();
    expect((l1 + 0.05) / (l2 + 0.05), greaterThanOrEqualTo(4.5));
  });

  testWidgets('text respects the system textScaler', (tester) async {
    await pumpLoovi(tester, box(const LooviPhotoTextItem(label: 'Label')), textScale: 2);
    expect(tester.getSize(find.text('Label')).height, greaterThan(t.typography.bodyMediumMedium.fontSize! * 2));
  });

  testWidgets('golden: with and without supporting text', (tester) async {
    await pumpGolden(
      tester,
      Builder(
        builder: (context) {
          final t = LooviTokens.of(context);
          return Padding(
            key: const Key('golden'),
            padding: EdgeInsets.all(t.spacing.s200),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 180,
                    child: ColoredBox(color: t.color.backgroundSurface1, child: const LooviPhotoTextItem(label: 'Label')),
                  ),
                ),
                SizedBox(width: t.spacing.s200),
                Expanded(
                  child: SizedBox(
                    height: 180,
                    child: ColoredBox(
                      color: t.color.backgroundSurface1,
                      child: const LooviPhotoTextItem(label: 'Label', supportingText: 'Supporting text'),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      height: 220,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/photo_text_item.png'));
  });
}
