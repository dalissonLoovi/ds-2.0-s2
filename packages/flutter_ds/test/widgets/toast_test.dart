import 'package:loovi_ds/loovi_ds.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

/// Example copy per status (brand voice; no invented dates or claims).
const _toastCopy = <LooviToastStatus, String>{
  LooviToastStatus.system: 'Seus dados foram atualizados',
  LooviToastStatus.info: 'Vistoria enviada para análise',
  LooviToastStatus.success: 'Pagamento confirmado',
  LooviToastStatus.danger: 'Não foi possível enviar as fotos',
  LooviToastStatus.warning: 'Sua conexão está instável',
};

/// Story "Status": every status (dismissible) + one with action. Same as the
/// Widgetbook story.
class ToastStatusMatrix extends StatelessWidget {
  const ToastStatusMatrix({super.key});

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
            for (final s in LooviToastStatus.values) ...[
              LooviToast(status: s, message: _toastCopy[s]!, onDismiss: () {}),
              SizedBox(height: t.spacing.s200),
            ],
            LooviToast(
              status: LooviToastStatus.danger,
              message: 'Pagamento não aprovado',
              showAction: true,
              actionLabel: 'Tentar',
              onAction: () {},
              onDismiss: () {},
            ),
            SizedBox(height: t.spacing.s200),
            const LooviToast(status: LooviToastStatus.success, message: 'Foto enviada', dismissible: false),
          ],
        ),
      ),
    );
  }
}

BoxDecoration _shell(WidgetTester tester) => tester
    .widgetList<DecoratedBox>(find.descendant(of: find.byType(LooviToast), matching: find.byType(DecoratedBox)))
    .first
    .decoration as BoxDecoration;

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('shell: inverse-3, radius/200, elevation/1, min height 48, padding', (tester) async {
    await pumpLoovi(tester, LooviToast(message: 'Mensagem', onDismiss: () {}));
    final d = _shell(tester);
    expect(d.color, _t.color.backgroundSurfaceInverse3);
    expect(d.borderRadius, BorderRadius.circular(_t.radius.s200));
    expect(d.boxShadow, LooviEffects.box(_t.effects.elevation1));
    final root = tester.getRect(find.byType(LooviToast));
    expect(root.height, _t.spacing.s600);
    final icon = tester.getRect(find.byType(LooviIcon).first);
    expect(icon.left - root.left, _t.spacing.s200);
    // Dismiss target ends flush with the shell (padding-end spacing/0).
    expect(tester.getRect(find.byType(LooviButton)).right, root.right);
  });

  for (final s in LooviToastStatus.values) {
    testWidgets('status=${s.name}: icon name/color/size', (tester) async {
      await pumpLoovi(tester, LooviToast(status: s, message: 'M', dismissible: false));
      final icons = tester.widgetList<LooviIcon>(find.byType(LooviIcon)).toList();
      if (s == LooviToastStatus.system) {
        expect(icons, isEmpty);
        return;
      }
      expect(icons.single.name, LooviToast.iconFor(s));
      expect(icons.single.size, _t.spacing.s300);
      expect(icons.single.color, switch (s) {
        LooviToastStatus.info => _t.feedback.info,
        LooviToastStatus.success => _t.feedback.success,
        LooviToastStatus.danger => _t.feedback.danger,
        LooviToastStatus.warning => _t.feedback.warning,
        LooviToastStatus.system => null,
      });
    });
  }

  testWidgets('message: body/medium/regular text/on-color; icon gap spacing/150', (tester) async {
    await pumpLoovi(tester, const LooviToast(message: 'Pagamento confirmado', status: LooviToastStatus.success));
    final txt = tester.widget<Text>(find.text('Pagamento confirmado'));
    expect(txt.style!.color, _t.text.onColor);
    expect(txt.style!.fontSize, _t.typography.bodyMediumRegular.fontSize);
    expect(txt.style!.fontWeight, _t.typography.bodyMediumRegular.fontWeight);
    final icon = tester.getRect(find.byType(LooviIcon).first);
    expect(tester.getRect(find.text('Pagamento confirmado')).left - icon.right, _t.spacing.s150);
  });

  testWidgets('dismiss: inverse text Button, x-outline, "Fechar", calls onDismiss', (tester) async {
    var dismissed = 0;
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, LooviToast(message: 'M', onDismiss: () => dismissed++));
    final b = tester.widget<LooviButton>(find.byType(LooviButton));
    expect(b.variant, LooviButtonVariant.text);
    expect(b.isInverse, isTrue);
    expect(b.showLabel, isFalse);
    expect(b.leadingIcon, LooviIcons.xOutline);
    expect(
      tester.getSemantics(find.byType(LooviButton)),
      isSemantics(label: 'Fechar', isButton: true, hasTapAction: true),
    );
    await tester.tap(find.byType(LooviButton));
    expect(dismissed, 1);
    handle.dispose();
  });

  testWidgets('action: hidden by default; inverse text md Button with label', (tester) async {
    var taps = 0;
    await pumpLoovi(
      tester,
      Column(children: [
        const LooviToast(message: 'A', actionLabel: 'Desfazer', dismissible: false),
        LooviToast(message: 'B', showAction: true, actionLabel: 'Ver', onAction: () => taps++, dismissible: false),
      ]),
    );
    expect(find.text('Desfazer'), findsNothing);
    final b = tester.widget<LooviButton>(find.byType(LooviButton));
    expect(b.size, LooviButtonSize.md);
    expect(b.isInverse, isTrue);
    expect(tester.widget<Text>(find.text('Ver')).style!.color, _t.text.onColor);
    await tester.tap(find.text('Ver'));
    expect(taps, 1);
  });

  testWidgets('dismissible=false hides the dismiss', (tester) async {
    await pumpLoovi(tester, const LooviToast(message: 'M', dismissible: false));
    expect(find.byType(LooviButton), findsNothing);
  });

  testWidgets('semantics: live region "{status}. {message}"; no focus move', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const LooviToast(status: LooviToastStatus.danger, message: 'Falha no envio', dismissible: false));
    final s = tester.getSemantics(find.byType(LooviToast));
    expect(s.label, 'Erro. Falha no envio');
    expect(s.flagsCollection.isLiveRegion, isTrue);
    expect(FocusManager.instance.primaryFocus?.context?.widget, isNot(isA<LooviButton>()));
    handle.dispose();
  });

  testWidgets('textScaler 2: long message wraps, no overflow', (tester) async {
    await pumpLoovi(
      tester,
      LooviToast(
        status: LooviToastStatus.warning,
        message: 'Sua conexão está instável. Tente de novo em alguns instantes.',
        showAction: true,
        actionLabel: 'Tentar',
        onAction: () {},
        onDismiss: () {},
      ),
      textScale: 2,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('golden: status matrix', (tester) async {
    await pumpGolden(tester, const ToastStatusMatrix(), height: 500);
    await expectLater(find.byType(ToastStatusMatrix), matchesGoldenFile('../goldens/toast_status.png'));
  });
}
