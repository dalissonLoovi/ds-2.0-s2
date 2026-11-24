import 'package:loovi_ds/loovi_ds.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

Widget _card({VoidCallback? onCta, Key? key}) => LooviOfferProductCard(
      key: key,
      title: 'Proteção extra',
      description: 'Descrição do produto adicional.',
      price: 'R\$ 0,00',
      ctaLabel: 'Adicionar',
      onCtaPressed: onCta,
    );

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('renders texts, package-outline icon in a surface/3 circle and sm CTA', (tester) async {
    await pumpLoovi(tester, _card(onCta: () {}));
    expect(find.text('Adicionar'), findsOneWidget);
    final icon = tester.widget<LooviIcon>(find.byType(LooviIcon));
    expect(icon.name, LooviIcons.packageOutline);
    expect(icon.color, _t.text.brand);
    expect(icon.size, _t.spacing.s250);
    final btn = tester.widget<LooviButton>(find.byType(LooviButton));
    expect(btn.size, LooviButtonSize.sm);
    expect(btn.variant, LooviButtonVariant.solid);
    expect(btn.intent, LooviButtonIntent.primary);
    expect(btn.fullWidth, isTrue);
    final container = find.ancestor(of: find.byType(LooviIcon), matching: find.byType(Container)).first;
    expect(tester.getSize(container), Size.square(_t.spacing.s400));
    final root = tester.widget<DecoratedBox>(find.descendant(of: find.byType(LooviOfferProductCard), matching: find.byType(DecoratedBox)).first);
    expect((root.decoration as BoxDecoration).color, _t.color.backgroundSurface2);
    expect((root.decoration as BoxDecoration).borderRadius, BorderRadius.circular(_t.radius.s500));
  });

  testWidgets('CTA fires the callback; null disables it', (tester) async {
    var taps = 0;
    await pumpLoovi(tester, _card(onCta: () => taps++));
    await tester.tap(find.text('Adicionar'));
    expect(taps, 1);
    await pumpLoovi(tester, _card());
    await tester.tap(find.text('Adicionar'), warnIfMissed: false);
    expect(taps, 1);
  });

  testWidgets('semantics: offer texts merged (title first) + separate CTA button', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, _card(onCta: () {}));
    expect(find.bySemanticsLabel(RegExp(r'^Proteção extra\nDescrição do produto adicional\.\nR\$ 0,00/mês$')), findsOneWidget);
    expect(find.bySemanticsLabel('Adicionar'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('golden: default', (tester) async {
    await pumpGolden(
      tester,
      Padding(
        key: const Key('golden'),
        padding: EdgeInsets.all(_t.spacing.s200),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _card(onCta: () {})),
            SizedBox(width: _t.spacing.s200),
            Expanded(
              child: LooviOfferProductCard(
                title: 'Title',
                description: 'Description',
                price: 'R\$ 0,00',
                icon: LooviIcons.shieldCheckOutline,
                ctaLabel: 'Label',
                onCtaPressed: () {},
              ),
            ),
          ],
        ),
      ),
      height: 290,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/offer_product_card_default.png'));
  });
}
