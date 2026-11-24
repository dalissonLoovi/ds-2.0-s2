import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
// Direct src import until lib/loovi_ds.dart exports wave 3 (integration).
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

Finder _icon(String name) => find.byWidgetPredicate((w) => w is LooviIcon && w.name == name);

List<Widget> _items() => [
      for (final name in ['Apólice', 'Boleto', 'Carro reserva'])
        LooviListItem(
          headline: name,
          supportingText: 'Toque para abrir',
          condition: LooviListItemCondition.twoLine,
          leading: LooviListItemMonogram(name[0]),
          onTap: () {},
        ),
    ];

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('placeholder: back only; typing shows clear; clear empties', (tester) async {
    final controller = TextEditingController();
    var cleared = 0;
    await pumpLoovi(
      tester,
      SizedBox(height: 400, child: LooviSearchViewFullscreen(controller: controller, onClear: () => cleared++)),
    );
    expect(_icon(LooviIcons.arrowNarrowLeftOutline), findsOneWidget);
    expect(_icon(LooviIcons.xOutline), findsNothing);
    expect(find.text('Pesquisar'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'bol');
    await tester.pump();
    expect(_icon(LooviIcons.xOutline), findsOneWidget);
    expect(tester.widget<LooviIcon>(_icon(LooviIcons.xOutline)).color, _t.text.primary);

    await tester.tap(_icon(LooviIcons.xOutline));
    await tester.pump();
    expect(controller.text, isEmpty);
    expect(cleared, 1);
  });

  testWidgets('back calls onBack; field uses body/large + focus caret', (tester) async {
    var back = 0;
    await pumpLoovi(tester, SizedBox(height: 400, child: LooviSearchViewFullscreen(onBack: () => back++)));
    await tester.tap(_icon(LooviIcons.arrowNarrowLeftOutline));
    expect(back, 1);
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.cursorColor, _t.interactive.focus);
    expect(field.style!.fontSize, _t.typography.bodyLargeRegular.fontSize);
    expect(field.textInputAction, TextInputAction.search);
  });

  testWidgets('results render below the divider only when showResults', (tester) async {
    await pumpLoovi(tester, SizedBox(height: 500, child: LooviSearchViewFullscreen(items: _items())));
    expect(find.byType(LooviDividerHorizontal), findsOneWidget);
    expect(find.byType(LooviListItem), findsNWidgets(3));
    expect(
      tester.getTopLeft(find.byType(LooviListItem).first).dy,
      greaterThanOrEqualTo(tester.getBottomLeft(find.byType(LooviDividerHorizontal)).dy),
    );

    await pumpLoovi(
      tester,
      SizedBox(height: 500, child: LooviSearchViewFullscreen(items: _items(), showResults: false)),
    );
    expect(find.byType(LooviListItem), findsNothing);
  });

  testWidgets('semantics + layout: header 56, named 48 dp back/clear, labelled field', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(
      tester,
      SizedBox(
        height: 400,
        child: LooviSearchViewFullscreen(controller: TextEditingController(text: 'bol'), autofocus: false),
      ),
    );
    expect(find.bySemanticsLabel('Voltar'), findsOneWidget);
    expect(find.bySemanticsLabel('Limpar busca'), findsOneWidget);
    expect(tester.getSemantics(find.byType(TextField)).getSemanticsData().label, contains('Pesquisar'));
    final back = find.ancestor(of: _icon(LooviIcons.arrowNarrowLeftOutline), matching: find.byType(GestureDetector)).first;
    expect(tester.getSize(back), Size.square(48));
    // Icon paints at the Figma header padding (spacing/150 = 12).
    expect(tester.getTopLeft(_icon(LooviIcons.arrowNarrowLeftOutline)).dx, _t.spacing.s150);
    expect(tester.getTopLeft(find.byType(LooviDividerHorizontal)).dy, _t.spacing.s700);
    handle.dispose();
  });

  testWidgets('golden: SearchViewFullscreen value + results / placeholder (app-cliente)', (tester) async {
    await pumpGolden(tester, const _States(), height: 520);
    await expectLater(find.byType(_States), matchesGoldenFile('../goldens/search_view_fullscreen_variants.png'));
  });
}

class _States extends StatelessWidget {
  const _States();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 330,
          child: LooviSearchViewFullscreen(
            controller: TextEditingController(text: 'Input text'),
            autofocus: false,
            items: _items(),
          ),
        ),
        SizedBox(height: t.spacing.s200, child: ColoredBox(color: t.color.backgroundSurface3)),
        SizedBox(height: 120, child: const LooviSearchViewFullscreen(autofocus: false)),
      ],
    );
  }
}
