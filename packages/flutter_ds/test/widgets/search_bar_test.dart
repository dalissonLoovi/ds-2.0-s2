import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
// Direct src import until lib/loovi_ds.dart exports wave 3 (integration).
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

Finder _icon(String name) => find.byWidgetPredicate((w) => w is LooviIcon && w.name == name);

BoxDecoration _pill(WidgetTester tester) => tester
    .widgetList<DecoratedBox>(find.descendant(of: find.byType(LooviSearchBar), matching: find.byType(DecoratedBox)))
    .map((d) => d.decoration as BoxDecoration)
    .firstWhere((d) => d.borderRadius == BorderRadius.circular(_t.radius.full));

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('placeholder vs value text colors; seed default actions', (tester) async {
    await pumpLoovi(tester, LooviSearchBar(onPressed: () {}));
    expect(tester.widget<Text>(find.text('Pesquisar')).style!.color, _t.text.secondary);
    expect(tester.widget<LooviIcon>(_icon(LooviIcons.menu2Outline)).color, _t.text.primary);
    expect(tester.widget<LooviIcon>(_icon(LooviIcons.searchOutline)).color, _t.text.secondary);
    expect(_icon(LooviIcons.xOutline), findsNothing);

    await pumpLoovi(tester, LooviSearchBar(query: 'Seguro auto', onPressed: () {}));
    expect(tester.widget<Text>(find.text('Seguro auto')).style!.color, _t.text.primary);
  });

  testWidgets('tap on the bar opens the view; actions call their own callbacks', (tester) async {
    var opened = 0;
    var menu = 0;
    var clear = 0;
    await pumpLoovi(
      tester,
      LooviSearchBar(
        query: 'Seguro',
        showSecondTrailingAction: true,
        onPressed: () => opened++,
        onLeadingAction: () => menu++,
        onSecondTrailingAction: () => clear++,
      ),
    );
    await tester.tap(find.text('Seguro'));
    expect(opened, 1);
    await tester.tap(_icon(LooviIcons.menu2Outline));
    expect(menu, 1);
    await tester.tap(_icon(LooviIcons.xOutline));
    expect(clear, 1);
    // Search action falls back to onPressed.
    await tester.tap(_icon(LooviIcons.searchOutline));
    expect(opened, 2);
  });

  testWidgets('pressed fill interactive/pressed; disabled fill + placeholder ink, no taps', (tester) async {
    await pumpLoovi(tester, LooviSearchBar(onPressed: () {}));
    expect(_pill(tester).color, _t.color.backgroundSurface0);
    final gesture = await tester.startGesture(tester.getCenter(find.text('Pesquisar')));
    await tester.pump(const Duration(milliseconds: 200));
    expect(_pill(tester).color, _t.interactive.pressed);
    await gesture.up();
    await tester.pump();
    expect(_pill(tester).color, _t.color.backgroundSurface0);

    var opened = 0;
    await pumpLoovi(tester, LooviSearchBar(disabled: true, onPressed: () => opened++));
    expect(_pill(tester).color, _t.interactive.disabledSurface);
    expect(tester.widget<Text>(find.text('Pesquisar')).style!.color, _t.text.placeholder);
    expect(tester.widget<LooviIcon>(_icon(LooviIcons.menu2Outline)).color, _t.text.placeholder);
    await tester.tap(find.text('Pesquisar'));
    expect(opened, 0);
  });

  testWidgets('semantics: bar is a named button; actions are named 48 dp buttons', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, LooviSearchBar(onPressed: () {}, onLeadingAction: () {}));
    final bar = tester.getSemantics(find.bySemanticsLabel('Pesquisar')).getSemanticsData();
    expect(bar.flagsCollection.isButton, isTrue);
    expect(find.bySemanticsLabel('Menu'), findsOneWidget);
    expect(find.bySemanticsLabel('Buscar'), findsOneWidget);
    final target = find.ancestor(of: _icon(LooviIcons.menu2Outline), matching: find.byType(SizedBox)).first;
    expect(tester.getSize(target), Size.square(_t.spacing.s600));
    expect(tester.getSize(find.byType(LooviSearchBar)).height, _t.spacing.s700);
    handle.dispose();
  });

  testWidgets('golden: SearchBar variants (app-cliente)', (tester) async {
    // Keyboard highlight so the autofocused bar paints state=focus.
    FocusManager.instance.highlightStrategy = FocusHighlightStrategy.alwaysTraditional;
    addTearDown(() => FocusManager.instance.highlightStrategy = FocusHighlightStrategy.automatic);
    await pumpGolden(tester, const _States(), height: 400);
    await expectLater(find.byType(_States), matchesGoldenFile('../goldens/search_bar_variants.png'));
  });
}

class _States extends StatelessWidget {
  const _States();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget gap() => SizedBox(height: t.spacing.s200);
    void noop() {}
    return ColoredBox(
      color: t.color.backgroundSurface2,
      child: Padding(
        padding: EdgeInsets.all(t.spacing.s200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LooviSearchBar(onPressed: noop),
            gap(),
            LooviSearchBar(query: 'Seguro auto', showSecondTrailingAction: true, onPressed: noop),
            gap(),
            LooviSearchBar(showProfileAction: true, profileInitials: 'RS', onPressed: noop),
            gap(),
            LooviSearchBar(autofocus: true, onPressed: noop),
            gap(),
            LooviSearchBar(disabled: true, query: 'Seguro auto', onPressed: noop),
          ],
        ),
      ),
    );
  }
}
