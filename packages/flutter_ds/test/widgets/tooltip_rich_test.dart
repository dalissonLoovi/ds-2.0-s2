import 'dart:ui' show Tristate;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
// TODO(integration): drop once loovi_ds.dart exports the widgets.
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

const _title = 'Cobertura para terceiros';
const _desc = 'Cobre danos que seu carro causar a outros veículos.';

/// Story "Variants": full (top-center), no actions (bottom-left), primary
/// only (top-right). Same as the Widgetbook story.
class TooltipRichVariants extends StatelessWidget {
  const TooltipRichVariants({super.key});

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
            LooviTooltipRich(
              title: _title,
              description: _desc,
              primaryActionLabel: 'Ver mais',
              secondaryActionLabel: 'Fechar',
              onPrimaryAction: () {},
              onSecondaryAction: () {},
            ),
            SizedBox(height: t.spacing.s300),
            const LooviTooltipRich(
              placement: LooviTooltipPlacement.bottomLeft,
              title: _title,
              description: _desc,
              showActions: false,
            ),
            SizedBox(height: t.spacing.s300),
            LooviTooltipRich(
              placement: LooviTooltipPlacement.topRight,
              showTitle: false,
              description: _desc,
              showSecondaryAction: false,
              primaryActionLabel: 'Entendi',
              onPrimaryAction: () {},
            ),
          ],
        ),
      ),
    );
  }
}

Widget _trigger() => const SizedBox(
      key: Key('trigger'),
      width: 48,
      height: 48,
      child: ColoredBox(color: Color(0x00000000)),
    );

/// Places the tooltip host away from the screen edges.
Widget _host(Widget child, {double top = 120}) =>
    Padding(padding: EdgeInsets.only(top: top), child: Align(alignment: Alignment.topCenter, child: child));

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('content: title semi-bold, description regular, on-color; paddings and gaps', (tester) async {
    await pumpLoovi(
      tester,
      LooviTooltipRich(title: 'T', description: 'D', primaryActionLabel: 'P', onPrimaryAction: () {}),
    );
    final title = tester.widget<Text>(find.text('T'));
    expect(title.style!.color, _t.text.onColor);
    expect(title.style!.fontWeight, _t.typography.bodyMediumSemiBold.fontWeight);
    expect(title.style!.fontSize, _t.typography.bodyMediumSemiBold.fontSize);
    final desc = tester.widget<Text>(find.text('D'));
    expect(desc.style!.color, _t.text.onColor);
    expect(desc.style!.fontSize, _t.typography.bodySmallRegular.fontSize);
    final root = tester.getRect(find.byType(LooviTooltipRich));
    final t = tester.getRect(find.text('T'));
    final d = tester.getRect(find.text('D'));
    expect(t.top - root.top, _t.spacing.s100 + _t.spacing.s150);
    expect(t.left - root.left, _t.spacing.s150);
    expect(d.top - t.bottom, _t.spacing.s050);
    final button = tester.getRect(find.byType(LooviButton));
    expect(button.top - d.bottom, _t.spacing.s200);
    expect(root.bottom - button.bottom, _t.spacing.s200);
  });

  testWidgets('actions: primary solid/sm, secondary text/sm inverse (on-color); order primary → secondary', (tester) async {
    await pumpLoovi(
      tester,
      LooviTooltipRich(
        title: 'T',
        primaryActionLabel: 'Ver mais',
        secondaryActionLabel: 'Fechar',
        onPrimaryAction: () {},
        onSecondaryAction: () {},
      ),
    );
    final buttons = tester.widgetList<LooviButton>(find.byType(LooviButton)).toList();
    expect(buttons[0].label, 'Ver mais');
    expect(buttons[0].variant, LooviButtonVariant.solid);
    expect(buttons[0].size, LooviButtonSize.sm);
    expect(buttons[0].isInverse, isFalse);
    expect(buttons[1].variant, LooviButtonVariant.text);
    expect(buttons[1].size, LooviButtonSize.sm);
    expect(buttons[1].isInverse, isTrue);
    expect(tester.widget<Text>(find.text('Fechar')).style!.color, _t.text.onColor);
    expect(
      tester.getRect(find.byType(LooviButton).at(1)).left - tester.getRect(find.byType(LooviButton).at(0)).right,
      _t.spacing.s100,
    );
  });

  testWidgets('show* flags hide parts; action needs a label', (tester) async {
    await pumpLoovi(
      tester,
      const LooviTooltipRich(title: 'T', showTitle: false, description: 'D', showSecondaryAction: false, primaryActionLabel: null),
    );
    expect(find.text('T'), findsNothing);
    expect(find.byType(LooviButton), findsNothing);
    expect(const LooviTooltipRich(primaryActionLabel: 'P', showActions: false).isActionable, isFalse);
  });

  testWidgets('actionable trigger: tap opens, action runs and closes, focus returns, expanded state', (tester) async {
    final handle = tester.ensureSemantics();
    var primary = 0;
    await pumpLoovi(
      tester,
      _host(
        LooviTooltipRich(
          title: _title,
          description: _desc,
          primaryActionLabel: 'Ver mais',
          onPrimaryAction: () => primary++,
          child: _trigger(),
        ),
      ),
    );
    expect(tester.getSemantics(find.byKey(const Key('trigger'))).flagsCollection.isExpanded, isNot(Tristate.isTrue));
    await tester.tap(find.byKey(const Key('trigger')));
    await tester.pumpAndSettle();
    expect(find.text(_title), findsOneWidget);
    expect(find.bySemanticsLabel(_title), findsWidgets);
    expect(tester.getSemantics(find.byKey(const Key('trigger'))).flagsCollection.isExpanded, Tristate.isTrue);
    await tester.tap(find.text('Ver mais'));
    await tester.pumpAndSettle();
    expect(primary, 1);
    expect(find.text(_title), findsNothing);
    handle.dispose();
  });

  testWidgets('Escape closes the actionable surface', (tester) async {
    await pumpLoovi(
      tester,
      _host(LooviTooltipRich(title: _title, primaryActionLabel: 'Ver mais', onPrimaryAction: () {}, child: _trigger())),
    );
    await tester.tap(find.byKey(const Key('trigger')));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text(_title), findsNothing);
  });

  testWidgets('informative (no actions): trigger tooltip semantics, bubble excluded', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, _host(LooviTooltipRich(title: _title, description: _desc, showActions: false, child: _trigger())));
    expect(tester.getSemantics(find.byKey(const Key('trigger'))).tooltip, '$_title. $_desc');
    await tester.tap(find.byKey(const Key('trigger')));
    await tester.pumpAndSettle();
    expect(find.text(_title), findsOneWidget);
    expect(find.bySemanticsLabel(_title), findsNothing);
    handle.dispose();
  });

  testWidgets('textScaler 2: actions wrap, no overflow', (tester) async {
    await pumpLoovi(
      tester,
      LooviTooltipRich(
        title: _title,
        description: _desc,
        primaryActionLabel: 'Ver detalhes da cobertura',
        secondaryActionLabel: 'Agora não',
        onPrimaryAction: () {},
        onSecondaryAction: () {},
      ),
      textScale: 2,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('golden: variants', (tester) async {
    await pumpGolden(tester, const TooltipRichVariants(), height: 520);
    await expectLater(find.byType(TooltipRichVariants), matchesGoldenFile('../goldens/tooltip_rich_variants.png'));
  });
}
