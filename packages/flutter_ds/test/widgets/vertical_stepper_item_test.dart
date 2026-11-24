import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

/// Story "Status": one item per status. Same as the Widgetbook story.
class VerticalStepperItemStatuses extends StatelessWidget {
  const VerticalStepperItemStatuses({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LooviVerticalStepperItem(headline: 'Dados pessoais', supportingText: 'Concluído'),
          LooviVerticalStepperItem(
            headline: 'Fotos do veículo',
            supportingText: 'Envie 6 fotos',
            status: LooviVerticalStepperItemStatus.current,
          ),
          LooviVerticalStepperItem(
            headline: 'Documento',
            supportingText: 'A foto ficou ilegível',
            status: LooviVerticalStepperItemStatus.error,
          ),
          LooviVerticalStepperItem(
            headline: 'Pagamento',
            supportingText: 'Escolha a forma',
            status: LooviVerticalStepperItemStatus.pending,
            showConnector: false,
          ),
        ],
      ),
    );
  }
}

void main() {
  setUpAll(loadGoldenFonts);

  for (final s in LooviVerticalStepperItemStatus.values) {
    testWidgets('status=${s.name}: icon + colors; connector color', (tester) async {
      await pumpLoovi(tester, LooviVerticalStepperItem(headline: 'H', supportingText: 'S', status: s));
      final icon = tester.widget<LooviIcon>(find.byType(LooviIcon));
      expect(icon.name, switch (s) {
        LooviVerticalStepperItemStatus.completed => LooviIcons.circleCheckFilled,
        LooviVerticalStepperItemStatus.current => LooviIcons.circleDotFilled,
        LooviVerticalStepperItemStatus.pending => LooviIcons.circleOutline,
        LooviVerticalStepperItemStatus.error => LooviIcons.circleXFilled,
      });
      expect(icon.size, _t.spacing.s300);
      expect(icon.color, switch (s) {
        LooviVerticalStepperItemStatus.completed || LooviVerticalStepperItemStatus.current => _t.color.actionsPrimary,
        LooviVerticalStepperItemStatus.pending => _t.text.secondary,
        LooviVerticalStepperItemStatus.error => _t.feedback.danger,
      });
      final connector = tester.widget<ColoredBox>(
        find.descendant(of: find.byKey(const ValueKey('connector')), matching: find.byType(ColoredBox)),
      );
      expect(connector.color, s == LooviVerticalStepperItemStatus.completed ? _t.color.actionsPrimary : _t.color.border2);
    });
  }

  testWidgets('layout: padding spacing/050, indicator 24 wide, icon top spacing/100, connector fills to bottom', (tester) async {
    await pumpLoovi(tester, const LooviVerticalStepperItem(headline: 'Dados pessoais', supportingText: 'Concluído'));
    final root = tester.getRect(find.byType(LooviVerticalStepperItem));
    final icon = tester.getRect(find.byType(LooviIcon));
    final connector = tester.getRect(find.byKey(const ValueKey('connector')));
    final listItem = tester.getRect(find.byType(LooviListItem));
    expect(icon.top - root.top, _t.spacing.s050 + _t.spacing.s100);
    expect(icon.left, root.left);
    expect(listItem.left - root.left, _t.spacing.s300);
    expect(connector.width, _t.borderWidth.s025);
    expect(connector.top - icon.bottom, _t.spacing.s050);
    expect(root.bottom - connector.bottom, _t.spacing.s050);
    // Default nested ListItem: 2-line, no divider.
    final li = tester.widget<LooviListItem>(find.byType(LooviListItem));
    expect(li.condition, LooviListItemCondition.twoLine);
    expect(li.showDivider, isFalse);
  });

  testWidgets('showConnector=false hides the connector', (tester) async {
    await pumpLoovi(tester, const LooviVerticalStepperItem(headline: 'H', showConnector: false));
    expect(find.byKey(const ValueKey('connector')), findsNothing);
  });

  testWidgets('semantics: status word first; non-interactive by default; onTap makes it a button', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(
      tester,
      const LooviVerticalStepperItem(
        headline: 'Fotos do veículo',
        supportingText: 'Envie 6 fotos',
        status: LooviVerticalStepperItemStatus.current,
      ),
    );
    final s = tester.getSemantics(find.byType(LooviListItem));
    expect(s.label, 'Etapa atual. Fotos do veículo, Envie 6 fotos');
    expect(s.flagsCollection.isButton, isFalse);

    var taps = 0;
    await pumpLoovi(tester, LooviVerticalStepperItem(headline: 'H', onTap: () => taps++));
    expect(tester.getSemantics(find.byType(LooviListItem)), isSemantics(isButton: true, hasTapAction: true));
    await tester.tap(find.byType(LooviListItem));
    expect(taps, 1);
    handle.dispose();
  });

  testWidgets('textScaler 2: no overflow', (tester) async {
    await pumpLoovi(
      tester,
      const LooviVerticalStepperItem(headline: 'Fotos do veículo', supportingText: 'Envie 6 fotos do carro'),
      textScale: 2,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('golden: statuses', (tester) async {
    await pumpGolden(tester, const VerticalStepperItemStatuses(), height: 360);
    await expectLater(
      find.byType(VerticalStepperItemStatuses),
      matchesGoldenFile('../goldens/vertical_stepper_item_status.png'),
    );
  });
}
