import 'package:loovi_ds/loovi_ds.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

LooviReferralDiscountCard _status({int referrals = 2, VoidCallback? onInvite}) => LooviReferralDiscountCard(
      referrals: referrals,
      referralCount: '$referrals indicações',
      discountPercent: '${referrals * 10}% de desconto',
      savingsAmount: 'R\$ 0,00',
      savingsCaption: 'economizados até agora.',
      onInvite: onInvite ?? () {},
    );

LooviReferralDiscountCard _simulator() => LooviReferralDiscountCard(
      mode: LooviReferralDiscountCardMode.simulator,
      promoTitle: 'Zere sua mensalidade',
      description: 'Para cada indicação você ganha 10% de desconto. Com 10 indicações você zera sua mensalidade.',
      simulatorTitle: 'Simulador de indicação',
      referrals: 2,
      referralCount: '2 indicações',
      projectedDiscount: '20% de desconto',
      discountAmount: '- R\$ 0,00/mês',
      onInvite: () {},
    );

LooviReferralDiscountCard _fleet() => LooviReferralDiscountCard(
      mode: LooviReferralDiscountCardMode.fleet,
      fleetDescription: 'A cada amigo que contratar pela sua indicação, você ganha 10% de desconto na mensalidade.',
      onInvite: () {},
    );

Iterable<String> _markers(WidgetTester tester) => tester.widgetList<LooviIcon>(find.byType(LooviIcon)).map((i) => i.name);

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('status: texts, CTA secondary md "Convidar"', (tester) async {
    var taps = 0;
    await pumpLoovi(tester, _status(onInvite: () => taps++));
    expect(find.text('Descontômetro'), findsOneWidget);
    expect(find.text('2 indicações'), findsOneWidget);
    expect(tester.widget<Text>(find.text('20% de desconto')).style!.color, _t.text.primary);
    final btn = tester.widget<LooviButton>(find.byType(LooviButton));
    expect(btn.intent, LooviButtonIntent.secondary);
    expect(btn.size, LooviButtonSize.md);
    await tester.tap(find.text('Convidar'));
    expect(taps, 1);
  });

  testWidgets('track: 10 markers — filled before current, dot at current, outline after', (tester) async {
    await pumpLoovi(tester, _status(referrals: 3));
    final names = _markers(tester).toList();
    expect(names.length, 10);
    expect(names.where((n) => n == LooviIcons.circleFilled).length, 2);
    expect(names.where((n) => n == LooviIcons.circleDotFilled).length, 1);
    expect(names.where((n) => n == LooviIcons.circleOutline).length, 7);
    // current tick (30%) + 100% are the only visible ticks
    expect(find.text('30%'), findsOneWidget);
    expect(find.text('100%'), findsNWidgets(2)); // visible + invisible line-box sizer
    expect(tester.widget<Text>(find.text('30%')).style!.color, _t.text.primary);
  });

  testWidgets('track edges: 0 referrals = all outline; 10 = 100% current', (tester) async {
    await pumpLoovi(tester, _status(referrals: 0));
    expect(_markers(tester).every((n) => n == LooviIcons.circleOutline), isTrue);
    await pumpLoovi(tester, _status(referrals: 10));
    final names = _markers(tester).toList();
    expect(names.last, LooviIcons.circleDotFilled);
    expect(names.where((n) => n == LooviIcons.circleFilled).length, 9);
    expect(tester.takeException(), isNull);
  });

  testWidgets('simulator: header, simulatorTitle is plain text, track + projection', (tester) async {
    await pumpLoovi(tester, _simulator());
    expect(find.text('Zere sua mensalidade'), findsOneWidget);
    expect(find.text('Simulador de indicação'), findsOneWidget);
    expect(find.byType(LooviLink), findsNothing);
    expect(_markers(tester).length, 10);
    expect(find.text('- R\$ 0,00/mês'), findsOneWidget);
  });

  testWidgets('fleet: title + description + CTA only (no track, no counts)', (tester) async {
    await pumpLoovi(tester, _fleet());
    expect(find.text('Indique amigos e ganhe desconto'), findsOneWidget);
    expect(find.byType(LooviIcon), findsNothing);
    expect(find.byType(LooviButton), findsOneWidget);
  });

  testWidgets('semantics: track excluded, progress exposed by text, title is header', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, _status());
    expect(find.bySemanticsLabel('20%'), findsNothing);
    expect(find.bySemanticsLabel(RegExp(r'2 indicações\n20% de desconto')), findsOneWidget);
    final title = tester.getSemantics(find.text('Descontômetro'));
    expect(title.getSemanticsData().flagsCollection.isHeader, isTrue);
    handle.dispose();
  });

  testWidgets('golden: modes', (tester) async {
    await pumpGolden(
      tester,
      Padding(
        key: const Key('golden'),
        padding: EdgeInsets.all(_t.spacing.s200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _status(),
            SizedBox(height: _t.spacing.s200),
            _simulator(),
            SizedBox(height: _t.spacing.s200),
            _fleet(),
          ],
        ),
      ),
      height: 720,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/referral_discount_card_modes.png'));
  });
}
