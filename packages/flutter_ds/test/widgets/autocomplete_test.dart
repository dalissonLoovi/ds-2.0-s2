import 'dart:ui' show Tristate;

import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
// Direct src imports until lib/loovi_ds.dart exports wave 3 (integration).
import 'package:loovi_ds/src/widgets/input/loovi_input.dart' show LooviInputFloatingLabel;
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

Finder _icon(String name) => find.byWidgetPredicate((w) => w is LooviIcon && w.name == name);

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('empty unfocused: resting label, no placeholder; focus shows placeholder', (tester) async {
    await pumpLoovi(tester, const LooviAutocomplete());
    expect(find.byType(LooviInputFloatingLabel), findsNothing);
    expect(find.text('Digite para buscar'), findsNothing);
    expect(find.text('Veículo'), findsOneWidget);

    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(find.text('Digite para buscar'), findsOneWidget);
    expect(find.byType(LooviInputFloatingLabel), findsOneWidget);
    expect(tester.widget<LooviIcon>(_icon(LooviIcons.chevronDownOutline)).color, _t.text.brand);
  });

  testWidgets('typing asks to expand; expand icon toggles; chevron follows expanded', (tester) async {
    final requests = <bool>[];
    await pumpLoovi(tester, LooviAutocomplete(onExpandedChange: requests.add));
    await tester.enterText(find.byType(TextField), 'Chev');
    await tester.pump();
    expect(requests, [true]);

    await tester.tap(_icon(LooviIcons.chevronDownOutline));
    expect(requests.last, isTrue);

    await pumpLoovi(tester, LooviAutocomplete(expanded: true, onExpandedChange: requests.add));
    expect(_icon(LooviIcons.chevronUpOutline), findsOneWidget);
    await tester.tap(_icon(LooviIcons.chevronUpOutline));
    expect(requests.last, isFalse);
  });

  testWidgets('selectedValue fills the field; clear empties it', (tester) async {
    final controller = TextEditingController();
    var cleared = 0;
    await pumpLoovi(
      tester,
      LooviAutocomplete(selectedValue: 'Chevrolet Onix', controller: controller, onClear: () => cleared++),
    );
    expect(controller.text, 'Chevrolet Onix');
    await tester.tap(find.bySemanticsLabel('Limpar'));
    await tester.pump();
    expect(controller.text, isEmpty);
    expect(cleared, 1);
  });

  testWidgets('loading replaces the clear action with the spinner', (tester) async {
    await pumpLoovi(tester, const MediaQuery(
      data: MediaQueryData(disableAnimations: true),
      child: LooviAutocomplete(selectedValue: 'Chevrolet Onix', loading: true),
    ));
    expect(find.byType(LooviLoadingSpinner), findsOneWidget);
    expect(_icon(LooviIcons.xOutline), findsNothing);
  });

  testWidgets('error: validation icon, danger message, neutral expand icon, no clear', (tester) async {
    await pumpLoovi(tester, const LooviAutocomplete(selectedValue: 'Chevrolet Onix', errorText: 'Selecione um veículo'));
    expect(tester.widget<LooviIcon>(_icon(LooviIcons.alertCircleOutline)).color, _t.feedback.danger);
    expect(tester.widget<Text>(find.text('Selecione um veículo')).style!.color, _t.text.danger);
    expect(tester.widget<LooviIcon>(_icon(LooviIcons.chevronDownOutline)).color, _t.text.secondary);
    expect(_icon(LooviIcons.xOutline), findsNothing);
  });

  testWidgets('disabled: never expanded, not editable', (tester) async {
    final controller = TextEditingController(text: 'x');
    final requests = <bool>[];
    await pumpLoovi(
      tester,
      LooviAutocomplete(enabled: false, expanded: true, controller: controller, onExpandedChange: requests.add),
    );
    expect(_icon(LooviIcons.chevronDownOutline), findsOneWidget);
    expect(tester.widget<LooviIcon>(_icon(LooviIcons.chevronDownOutline)).color, _t.text.placeholder);
    await tester.enterText(find.byType(TextField), 'y');
    await tester.tap(_icon(LooviIcons.chevronDownOutline), warnIfMissed: false);
    expect(controller.text, 'x');
    expect(requests, isEmpty);
  });

  testWidgets('semantics: expanded state; labelled text field; 48 dp targets', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const LooviAutocomplete(selectedValue: 'Chevrolet Onix', expanded: true));
    final combo = tester.getSemantics(find.byType(LooviAutocomplete));
    expect(combo.getSemanticsData().flagsCollection.isExpanded, Tristate.isTrue);
    final field = tester.getSemantics(find.byType(TextField)).getSemanticsData();
    expect(field.label, contains('Veículo'));
    expect(find.bySemanticsLabel('Ocultar opções'), findsOneWidget);
    final target = find.ancestor(of: _icon(LooviIcons.chevronUpOutline), matching: find.byType(GestureDetector)).first;
    expect(tester.getSize(target).width, greaterThanOrEqualTo(48));
    handle.dispose();
  });

  testWidgets('golden: Autocomplete states (app-cliente)', (tester) async {
    await pumpGolden(tester, const _States(), height: 660);
    await expectLater(find.byType(_States), matchesGoldenFile('../goldens/autocomplete_states.png'));
  });
}

class _States extends StatelessWidget {
  const _States();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget gap() => SizedBox(height: t.spacing.s200);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(disableAnimations: true),
      child: Padding(
        padding: EdgeInsets.all(t.spacing.s200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LooviAutocomplete(),
            gap(),
            LooviAutocomplete(controller: TextEditingController(text: 'Chev'), expanded: true),
            gap(),
            const LooviAutocomplete(selectedValue: 'Chevrolet Onix'),
            gap(),
            const LooviAutocomplete(selectedValue: 'Chevrolet Onix', loading: true),
            gap(),
            const LooviAutocomplete(selectedValue: 'Chevrolet Onix', errorText: 'Selecione um veículo da lista'),
            gap(),
            const LooviAutocomplete(selectedValue: 'Chevrolet Onix', enabled: false),
            gap(),
            ColoredBox(
              color: t.color.backgroundSurfaceInverse3,
              child: Padding(
                padding: EdgeInsets.all(t.spacing.s200),
                child: const LooviAutocomplete(
                  selectedValue: 'Chevrolet Onix',
                  appearance: LooviInputAppearance.inverse,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
