import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

BoxDecoration _fieldDecoration(WidgetTester tester, [int index = 0]) {
  final box = tester.widgetList<DecoratedBox>(
    find.descendant(of: find.byType(LooviInput), matching: find.byType(DecoratedBox)),
  ).where((d) => (d.decoration as BoxDecoration).border != null).elementAt(index);
  return box.decoration as BoxDecoration;
}

Color _borderColor(WidgetTester tester) => (_fieldDecoration(tester).border! as Border).top.color;
double _borderWidth(WidgetTester tester) => (_fieldDecoration(tester).border! as Border).top.width;

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('typing updates the value and onChanged', (tester) async {
    final controller = TextEditingController();
    String? changed;
    await pumpLoovi(tester, LooviInput(label: 'Nome', controller: controller, onChanged: (v) => changed = v));
    await tester.enterText(find.byType(TextField), 'Loovi');
    await tester.pump();
    expect(controller.text, 'Loovi');
    expect(changed, 'Loovi');
    expect(find.text('Loovi'), findsOneWidget);
  });

  testWidgets('focus switches stroke to interactive/focus 2 dp and floats the label', (tester) async {
    await pumpLoovi(tester, const LooviInput(label: 'Nome'));
    expect(_borderColor(tester), _t.color.border1);
    expect(_borderWidth(tester), _t.borderWidth.s012);
    // content=label: resting label is the in-field hint (no floating label).
    expect(find.byType(LooviInputFloatingLabel), findsNothing);

    await tester.tap(find.byType(LooviInput));
    await tester.pump();
    expect(_borderColor(tester), _t.interactive.focus);
    expect(_borderWidth(tester), _t.borderWidth.s025);
    final label = tester.widget<Text>(find.descendant(of: find.byType(LooviInputFloatingLabel), matching: find.byType(Text)));
    expect(label.style!.color, _t.text.brand);
  });

  testWidgets('error shows message, danger stroke/label and alert icon', (tester) async {
    await pumpLoovi(tester, const LooviInput(label: 'CPF', placeholder: '000.000.000-00', errorText: 'CPF inválido', trailingIcon: true));
    expect(find.text('CPF inválido'), findsOneWidget);
    final msg = tester.widget<Text>(find.text('CPF inválido'));
    expect(msg.style!.color, _t.feedback.danger);
    expect(_borderColor(tester), _t.color.borderFeedbackDanger);
    expect(_borderWidth(tester), _t.borderWidth.s025);
    final icons = tester.widgetList<LooviIcon>(find.byType(LooviIcon)).map((i) => i.name).toList();
    expect(icons, contains(LooviIcons.alertCircleOutline));
    expect(icons, isNot(contains(LooviIcons.xOutline)));
  });

  testWidgets('disabled does not edit nor focus', (tester) async {
    final controller = TextEditingController(text: 'fixo');
    await pumpLoovi(tester, LooviInput(label: 'Nome', controller: controller, enabled: false));
    await tester.tap(find.byType(LooviInput));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'novo');
    await tester.pump();
    expect(controller.text, 'fixo');
    expect(_fieldDecoration(tester).color!.a, 0);
    expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
  });

  testWidgets('semantics: text field with label, invalid on error', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const LooviInput(label: 'E-mail', errorText: 'Obrigatório'));
    final node = tester.getSemantics(find.byType(TextField));
    final data = node.getSemanticsData();
    expect(data.label, contains('E-mail'));
    expect(data.flagsCollection.isTextField, isTrue);
    expect(data.validationResult, SemanticsValidationResult.invalid);
    handle.dispose();
  });

  testWidgets('clear trailing (x-outline) empties the field and has a 48 dp target', (tester) async {
    final handle = tester.ensureSemantics();
    final controller = TextEditingController(text: 'abc');
    await pumpLoovi(tester, LooviInput(label: 'Busca', controller: controller, leadingIcon: true, trailingIcon: true));
    expect(find.bySemanticsLabel('Limpar'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Limpar'));
    await tester.pump();
    expect(controller.text, isEmpty);
    expect(tester.getSize(find.ancestor(of: find.byWidgetPredicate((w) => w is LooviIcon && w.name == LooviIcons.xOutline), matching: find.byType(GestureDetector)).first).width,
        greaterThanOrEqualTo(48));
    handle.dispose();
  });

  testWidgets('app-cliente radius = component/input/field/radius (full) and min height 56', (tester) async {
    await pumpLoovi(tester, const LooviInput(label: 'Nome'));
    expect(_t.component.input.fieldRadius, _t.radius.full);
    expect(_fieldDecoration(tester).borderRadius, BorderRadius.circular(_t.radius.full));
    final field = find.descendant(of: find.byType(LooviInput), matching: find.byType(DecoratedBox)).first;
    expect(tester.getSize(field).height, _t.spacing.s700);
  });

  testWidgets('system textScaler grows the field instead of clipping', (tester) async {
    await pumpLoovi(tester, const LooviInput(label: 'Nome', placeholder: 'Digite'), textScale: 2);
    final field = find.descendant(of: find.byType(LooviInput), matching: find.byType(DecoratedBox)).first;
    expect(tester.getSize(field).height, greaterThanOrEqualTo(_t.spacing.s700));
    expect(tester.takeException(), isNull);
  });

  testWidgets('golden: Input states (app-cliente)', (tester) async {
    await pumpGolden(tester, const _InputStates(), height: 680);
    await expectLater(find.byType(_InputStates), matchesGoldenFile('../goldens/input_states.png'));
  });
}

class _InputStates extends StatelessWidget {
  const _InputStates();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget gap() => SizedBox(height: t.spacing.s200);
    return Padding(
      padding: EdgeInsets.all(t.spacing.s200),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const LooviInput(label: 'Label', placeholder: 'Placeholder', leadingIcon: true, trailingIcon: true),
          gap(),
          LooviInput(label: 'Label', controller: TextEditingController(text: 'Input'), leadingIcon: true, trailingIcon: true),
          gap(),
          const LooviInput(label: 'Label', leadingIcon: true, trailingIcon: true),
          gap(),
          LooviInput(label: 'Label', controller: TextEditingController(text: 'Input'), leadingIcon: true, trailingIcon: true, autofocus: true, showCursor: false),
          gap(),
          LooviInput(label: 'Label', controller: TextEditingController(text: 'Input'), leadingIcon: true, trailingIcon: true, errorText: 'Supporting text'),
          gap(),
          LooviInput(label: 'Label', controller: TextEditingController(text: 'Input'), leadingIcon: true, trailingIcon: true, enabled: false, supportingText: 'Supporting text'),
          gap(),
          ColoredBox(
            color: t.color.backgroundSurfaceInverse3,
            child: Padding(
              padding: EdgeInsets.all(t.spacing.s100),
              child: LooviInput(
                label: 'Label',
                controller: TextEditingController(text: 'Input'),
                appearance: LooviInputAppearance.inverse,
                leadingIcon: true,
                trailingIcon: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
