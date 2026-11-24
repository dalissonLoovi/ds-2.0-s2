import 'package:loovi_ds/loovi_ds.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

/// Example copy per status (brand voice; verb + complement actions).
const _bannerCopy = <LooviBannerStatus, (String, String)>{
  LooviBannerStatus.success: ('Pagamento confirmado', 'Ver recibo'),
  LooviBannerStatus.warning: ('Fatura vence amanhã', 'Ver fatura'),
  LooviBannerStatus.info: ('Vistoria em análise', 'Ver detalhes'),
  LooviBannerStatus.danger: ('Cartão recusado', 'Corrigir dados'),
};

/// Story "Status": emphasis × status, with action. Same as the Widgetbook story.
class BannerStatusMatrix extends StatelessWidget {
  const BannerStatusMatrix({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: Padding(
        padding: EdgeInsets.all(t.spacing.s200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final e in LooviBannerEmphasis.values)
              for (final s in LooviBannerStatus.values) ...[
                LooviBanner(
                  status: s,
                  emphasis: e,
                  message: _bannerCopy[s]!.$1,
                  showAction: true,
                  actionLabel: _bannerCopy[s]!.$2,
                  onAction: () {},
                ),
                SizedBox(height: t.spacing.s100),
              ],
            const LooviBanner(message: 'Sem ícone e sem ação', showIcon: false),
          ],
        ),
      ),
    );
  }
}

BoxDecoration _shell(WidgetTester tester, Finder banner) => tester
    .widgetList<DecoratedBox>(find.descendant(of: banner, matching: find.byType(DecoratedBox)))
    .first
    .decoration as BoxDecoration;

void main() {
  setUpAll(loadGoldenFonts);

  test('defaults match React: status=info, emphasis=primary, icon on, action off', () {
    const b = LooviBanner(message: 'M');
    expect(b.status, LooviBannerStatus.info);
    expect(b.emphasis, LooviBannerEmphasis.primary);
    expect(b.showIcon, isTrue);
    expect(b.showAction, isFalse);
  });

  for (final e in LooviBannerEmphasis.values) {
    for (final s in LooviBannerStatus.values) {
      testWidgets('${e.name}/${s.name}: fill, radius, icon', (tester) async {
        await pumpLoovi(tester, LooviBanner(status: s, emphasis: e, message: 'M'));
        final d = _shell(tester, find.byType(LooviBanner));
        final c = _t.color;
        final expected = e == LooviBannerEmphasis.primary
            ? switch (s) {
                LooviBannerStatus.success => c.backgroundFeedbackPrimarySuccess,
                LooviBannerStatus.warning => c.backgroundFeedbackPrimaryWarning,
                LooviBannerStatus.info => c.backgroundFeedbackPrimaryInfo,
                LooviBannerStatus.danger => c.backgroundFeedbackPrimaryDanger,
              }
            : switch (s) {
                LooviBannerStatus.success => c.backgroundFeedbackSecondarySuccess,
                LooviBannerStatus.warning => c.backgroundFeedbackSecondaryWarning,
                LooviBannerStatus.info => c.backgroundFeedbackSecondaryInfo,
                LooviBannerStatus.danger => c.backgroundFeedbackSecondaryDanger,
              };
        expect(d.color, expected);
        expect(d.borderRadius, BorderRadius.circular(_t.radius.s300));
        final icon = tester.widget<LooviIcon>(find.byType(LooviIcon));
        expect(icon.name, switch (s) {
          LooviBannerStatus.success => LooviIcons.checkOutline,
          LooviBannerStatus.warning => LooviIcons.alertTriangleOutline,
          LooviBannerStatus.info => LooviIcons.infoCircleOutline,
          LooviBannerStatus.danger => LooviIcons.alertCircleOutline,
        });
        expect(icon.color, _t.text.primary);
        expect(icon.size, 18);
      });
    }
  }

  testWidgets('layout: height 48, padding-x spacing/200, gaps spacing/100', (tester) async {
    await pumpLoovi(
      tester,
      LooviBanner(message: 'Pagamento confirmado', showAction: true, actionLabel: 'Ver recibo', onAction: () {}),
    );
    final root = tester.getRect(find.byType(LooviBanner));
    expect(root.height, _t.spacing.s600);
    final icon = tester.getRect(find.byType(LooviIcon));
    expect(icon.left - root.left, _t.spacing.s200);
    expect(tester.getRect(find.text('Pagamento confirmado')).left - icon.right, _t.spacing.s100);
    final action = tester.getRect(find.byType(LooviButton));
    expect(root.right - action.right, _t.spacing.s200);
  });

  testWidgets('message: body/small/regular text/primary', (tester) async {
    await pumpLoovi(tester, const LooviBanner(message: 'M', emphasis: LooviBannerEmphasis.secondary));
    final txt = tester.widget<Text>(find.text('M'));
    expect(txt.style!.color, _t.text.primary);
    expect(txt.style!.fontSize, _t.typography.bodySmallRegular.fontSize);
    expect(txt.style!.fontWeight, _t.typography.bodySmallRegular.fontWeight);
  });

  testWidgets('action: text sm primary Button, calls back; hidden without showAction', (tester) async {
    var taps = 0;
    await pumpLoovi(
      tester,
      Column(children: [
        LooviBanner(message: 'A', showAction: true, actionLabel: 'Ver detalhes', onAction: () => taps++),
        const LooviBanner(message: 'B', actionLabel: 'Oculta'),
      ]),
    );
    final b = tester.widget<LooviButton>(find.byType(LooviButton));
    expect(b.variant, LooviButtonVariant.text);
    expect(b.size, LooviButtonSize.sm);
    expect(b.intent, LooviButtonIntent.primary);
    expect(tester.widget<Text>(find.text('Ver detalhes')).style!.color, _t.text.primary);
    expect(find.text('Oculta'), findsNothing);
    await tester.tap(find.text('Ver detalhes'));
    expect(taps, 1);
  });

  testWidgets('showIcon=false hides the icon', (tester) async {
    await pumpLoovi(tester, const LooviBanner(message: 'M', showIcon: false));
    expect(find.byType(LooviIcon), findsNothing);
  });

  testWidgets('semantics: "{status}. {message}"; live region only warning|danger; action own node', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(
      tester,
      Column(children: [
        const LooviBanner(key: Key('s'), status: LooviBannerStatus.success, message: 'Pagamento confirmado'),
        const LooviBanner(key: Key('d'), status: LooviBannerStatus.danger, message: 'Cartão recusado'),
        LooviBanner(message: 'X', showAction: true, actionLabel: 'Corrigir dados', onAction: () {}),
      ]),
    );
    final s = tester.getSemantics(find.byKey(const Key('s')));
    expect(s.label, 'Sucesso. Pagamento confirmado');
    expect(s.flagsCollection.isLiveRegion, isFalse);
    final d = tester.getSemantics(find.byKey(const Key('d')));
    expect(d.label, 'Erro. Cartão recusado');
    expect(d.flagsCollection.isLiveRegion, isTrue);
    expect(
      tester.getSemantics(find.byType(LooviButton)),
      isSemantics(label: 'Corrigir dados', isButton: true, hasTapAction: true),
    );
    handle.dispose();
  });

  testWidgets('textScaler 2: no overflow', (tester) async {
    await pumpLoovi(
      tester,
      LooviBanner(
        status: LooviBannerStatus.warning,
        message: 'Sua fatura vence amanhã. Pague para manter a proteção ativa.',
        showAction: true,
        actionLabel: 'Ver fatura',
        onAction: () {},
      ),
      textScale: 2,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('golden: status matrix', (tester) async {
    await pumpGolden(tester, const BannerStatusMatrix(), height: 530);
    await expectLater(find.byType(BannerStatusMatrix), matchesGoldenFile('../goldens/banner_status.png'));
  });
}
