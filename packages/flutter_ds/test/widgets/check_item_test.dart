import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _copy = 'Não use óculos, chapéu ou acessórios que atrapalhem o reconhecimento.';
const _strong = 'óculos, chapéu ou acessórios';

void main() {
  setUpAll(loadGoldenFonts);
  const t = LooviTokens.appCliente;

  for (final entry in <String, Widget Function()>{
    'ModalCheckItem': () => const LooviModalCheckItem(description: _copy, emphasis: [_strong]),
    'BottomSheetCheckItem': () => const LooviBottomSheetCheckItem(description: _copy, emphasis: [_strong]),
  }.entries) {
    group(entry.key, () {
      testWidgets('icon 20 actions/primary, top-aligned; gap spacing/100', (tester) async {
        await pumpLoovi(tester, entry.value());
        final icon = tester.widget<LooviIcon>(find.byType(LooviIcon));
        expect(icon.name, LooviIcons.circleCheckFilled);
        expect(icon.size, t.spacing.s250);
        expect(icon.color, t.color.actionsPrimary);
        final iconRect = tester.getRect(find.byType(LooviIcon));
        final textRect = tester.getRect(find.byType(RichText).last);
        expect(iconRect.top, textRect.top);
        expect(textRect.left - iconRect.right, t.spacing.s100);
      });

      testWidgets('description secondary; emphasis brand semi-bold', (tester) async {
        await pumpLoovi(tester, entry.value());
        final rich = tester.widget<RichText>(find.byType(RichText).last);
        final root = (rich.text as TextSpan).children!.single as TextSpan;
        expect(root.style!.color, t.text.secondary);
        expect(root.style!.fontSize, t.typography.bodyMediumRegular.fontSize);
        final spans = root.children!.cast<TextSpan>();
        final strong = spans.singleWhere((s) => s.text == _strong);
        expect(strong.style!.color, t.text.brand);
        expect(strong.style!.fontWeight, t.typography.bodyMediumSemiBold.fontWeight);
        expect(spans.map((s) => s.text).join(), _copy);
      });

      testWidgets('semantics: text only, icon decorative, not a checkbox', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpLoovi(tester, entry.value());
        expect(find.bySemanticsLabel(_copy), findsOneWidget);
        expect(
          tester.getSemantics(find.bySemanticsLabel(_copy)),
          isSemantics(label: _copy, hasCheckedState: false, isButton: false, hasTapAction: false),
        );
        expect(find.descendant(of: find.byType(LooviIcon), matching: find.byType(ExcludeSemantics)), findsOneWidget);
        handle.dispose();
      });
    });
  }

  testWidgets('golden: Modal and BottomSheet check items', (tester) async {
    await pumpGolden(
      tester,
      Container(
        key: const Key('golden'),
        color: t.color.backgroundSurface0,
        padding: const EdgeInsets.all(16),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LooviModalCheckItem(description: _copy, emphasis: [_strong]),
            SizedBox(height: 16),
            LooviBottomSheetCheckItem(description: 'Fique em um lugar bem iluminado.'),
          ],
        ),
      ),
      height: 140,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/check_item.png'));
  });
}
