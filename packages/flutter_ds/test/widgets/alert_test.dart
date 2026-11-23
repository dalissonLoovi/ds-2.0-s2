import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

/// Story "Status": appearance × status. Same as the Widgetbook story.
class AlertStatusMatrix extends StatelessWidget {
  const AlertStatusMatrix({super.key});

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
            for (final a in LooviAlertAppearance.values)
              for (final s in LooviAlertStatus.values) ...[
                LooviAlert(
                  appearance: a,
                  status: s,
                  title: 'Pagamento confirmado',
                  description: 'Seu plano segue ativo. O comprovante está no seu e-mail.',
                  actionLabel: 'Ver comprovante',
                  onAction: () {},
                ),
                SizedBox(height: t.spacing.s100),
              ],
          ],
        ),
      ),
    );
  }
}

BoxDecoration _shell(WidgetTester tester) => tester
    .widgetList<DecoratedBox>(find.descendant(of: find.byType(LooviAlert), matching: find.byType(DecoratedBox)))
    .first
    .decoration as BoxDecoration;

void main() {
  setUpAll(loadGoldenFonts);

  for (final s in LooviAlertStatus.values) {
    testWidgets('status=${s.name}: fill, radius, icon name/color/size == token', (tester) async {
      await pumpLoovi(tester, LooviAlert(status: s, title: 'T', description: 'D'));
      final d = _shell(tester);
      expect(d.color, _t.color.backgroundSurface3);
      expect(d.borderRadius, BorderRadius.circular(_t.radius.s400));
      expect(d.border, isNull); // Figma: no stroke on the shell.
      final icons = tester.widgetList<LooviIcon>(find.byType(LooviIcon)).toList();
      if (s == LooviAlertStatus.system) {
        expect(icons, isEmpty);
      } else {
        expect(icons.single.name, LooviAlert.iconFor(s));
        expect(icons.single.size, _t.spacing.s400);
        expect(icons.single.color, switch (s) {
          LooviAlertStatus.info => _t.color.backgroundFeedbackPrimaryInfo,
          LooviAlertStatus.success => _t.feedback.success,
          LooviAlertStatus.danger => _t.feedback.danger,
          LooviAlertStatus.warning => _t.feedback.warning,
          LooviAlertStatus.system => null,
        });
      }
    });
  }

  testWidgets('text styles + colors, default and inverse', (tester) async {
    await pumpLoovi(
      tester,
      Column(children: const [
        LooviAlert(title: 'A', description: 'a'),
        LooviAlert(title: 'B', description: 'b', appearance: LooviAlertAppearance.inverse),
      ]),
    );
    Text txt(String s) => tester.widget<Text>(find.text(s));
    expect(txt('A').style!.color, _t.text.primary);
    expect(txt('A').style!.fontWeight, _t.typography.bodyMediumSemiBold.fontWeight);
    expect(txt('A').style!.fontSize, _t.typography.bodyMediumSemiBold.fontSize);
    expect(txt('a').style!.color, _t.text.secondary);
    expect(txt('a').style!.fontSize, _t.typography.bodySmallRegular.fontSize);
    expect(txt('B').style!.color, _t.text.onColor);
    expect(txt('b').style!.color, _t.text.onColorDisabled);
    final inverseFill = tester
        .widgetList<DecoratedBox>(find.descendant(of: find.byType(LooviAlert).last, matching: find.byType(DecoratedBox)))
        .first
        .decoration as BoxDecoration;
    expect(inverseFill.color, Color.alphaBlend(_t.color.elevationInverse3, _t.color.backgroundSurfaceBrand));
  });

  testWidgets('padding and gaps follow spacing tokens', (tester) async {
    await pumpLoovi(tester, const LooviAlert(title: 'Title', description: 'Desc', status: LooviAlertStatus.success));
    final root = tester.getRect(find.byType(LooviAlert));
    final icon = tester.getRect(find.byType(LooviIcon));
    final title = tester.getRect(find.text('Title'));
    final desc = tester.getRect(find.text('Desc'));
    expect(icon.top - root.top, _t.spacing.s150);
    expect(icon.left - root.left, _t.spacing.s250);
    expect(title.top - icon.bottom, _t.spacing.s100);
    expect(desc.top - title.bottom, _t.spacing.s100);
    expect(root.bottom - desc.bottom, _t.spacing.s250);
  });

  testWidgets('action: LooviButton outline/sm calls onAction; hidden without label or showAction', (tester) async {
    var taps = 0;
    await pumpLoovi(
      tester,
      Column(children: [
        LooviAlert(title: 'T', actionLabel: 'Ver comprovante', onAction: () => taps++),
        const LooviAlert(title: 'U', actionLabel: 'X', showAction: false),
        const LooviAlert(title: 'V'),
      ]),
    );
    final b = tester.widget<LooviButton>(find.byType(LooviButton));
    expect(b.variant, LooviButtonVariant.outline);
    expect(b.size, LooviButtonSize.sm);
    expect(b.intent, LooviButtonIntent.primary);
    await tester.tap(find.text('Ver comprovante'));
    expect(taps, 1);
    expect(find.byType(LooviButton), findsOneWidget);
  });

  testWidgets('inverse action still calls back (recolored button)', (tester) async {
    var taps = 0;
    await pumpLoovi(
      tester,
      LooviAlert(title: 'T', appearance: LooviAlertAppearance.inverse, actionLabel: 'Ok', onAction: () => taps++),
    );
    expect(find.byType(ColorFiltered), findsOneWidget);
    await tester.tap(find.text('Ok'));
    expect(taps, 1);
  });

  testWidgets('showDescription=false hides the description', (tester) async {
    await pumpLoovi(tester, const LooviAlert(title: 'T', description: 'D', showDescription: false));
    expect(find.text('D'), findsNothing);
  });

  testWidgets('close: calls onClose, label "Fechar alerta", target >= 48', (tester) async {
    var closed = 0;
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, LooviAlert(title: 'T', showClose: true, onClose: () => closed++));
    final close = find.bySemanticsLabel('Fechar alerta');
    expect(close, findsOneWidget);
    expect(tester.getSemantics(close), isSemantics(label: 'Fechar alerta', isButton: true, hasTapAction: true));
    final target = tester.getSize(find.byType(LooviTapTarget));
    expect(target.width, greaterThanOrEqualTo(48));
    expect(target.height, greaterThanOrEqualTo(48));
    final icon = tester.widgetList<LooviIcon>(find.byType(LooviIcon)).last;
    expect(icon.name, LooviIcons.xOutline);
    expect(icon.size, _t.spacing.s300);
    await tester.tap(find.byType(LooviTapTarget));
    expect(closed, 1);
    handle.dispose();
  });

  testWidgets('no close by default', (tester) async {
    await pumpLoovi(tester, const LooviAlert(title: 'T'));
    expect(find.byType(LooviTapTarget), findsNothing);
  });

  testWidgets('semantics: combined label; liveRegion only for danger|warning', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(
      tester,
      Column(children: const [
        LooviAlert(key: Key('s'), title: 'Pagamento confirmado', description: 'Comprovante no e-mail.', status: LooviAlertStatus.success),
        LooviAlert(key: Key('d'), title: 'Pagamento recusado', status: LooviAlertStatus.danger),
        LooviAlert(key: Key('w'), title: 'Vence em 3 dias', status: LooviAlertStatus.warning),
      ]),
    );
    final s = tester.getSemantics(find.byKey(const Key('s')));
    expect(s.label, 'Sucesso. Pagamento confirmado. Comprovante no e-mail.');
    expect(s.flagsCollection.isLiveRegion, isFalse);
    final d = tester.getSemantics(find.byKey(const Key('d')));
    expect(d.label, 'Erro. Pagamento recusado');
    expect(d.flagsCollection.isLiveRegion, isTrue);
    expect(tester.getSemantics(find.byKey(const Key('w'))).flagsCollection.isLiveRegion, isTrue);
    handle.dispose();
  });

  testWidgets('action keeps its own accessible button node', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, LooviAlert(title: 'T', actionLabel: 'Ver comprovante', onAction: () {}));
    expect(
      tester.getSemantics(find.byType(LooviButton)),
      isSemantics(label: 'Ver comprovante', isButton: true, hasTapAction: true),
    );
    handle.dispose();
  });

  testWidgets('action touch target >= 48', (tester) async {
    await pumpLoovi(tester, LooviAlert(title: 'T', actionLabel: 'Ok', onAction: () {}));
    expect(tester.getSize(find.byType(LooviButton)).height, greaterThanOrEqualTo(48));
  });

  testWidgets('textScaler 2: no overflow', (tester) async {
    await pumpLoovi(
      tester,
      LooviAlert(
        status: LooviAlertStatus.warning,
        title: 'Sua fatura vence em 3 dias, no dia 25',
        description: 'Pague até o dia 25 para manter a proteção do seu carro ativa.',
        actionLabel: 'Pagar agora',
        onAction: () {},
        showClose: true,
        onClose: () {},
      ),
      textScale: 2,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('golden: status matrix', (tester) async {
    await pumpGolden(tester, const AlertStatusMatrix(), height: 1990);
    await expectLater(find.byType(AlertStatusMatrix), matchesGoldenFile('../goldens/alert_status.png'));
  });
}
