import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

List<String> _digits(WidgetTester tester) =>
    tester.widgetList<LooviVerificationCodeInputItem>(find.byType(LooviVerificationCodeInputItem)).map((c) => c.digit).toList();

List<LooviVerificationCodeInputItemState> _states(WidgetTester tester) =>
    tester.widgetList<LooviVerificationCodeInputItem>(find.byType(LooviVerificationCodeInputItem)).map((c) => c.state).toList();

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('renders 5 cells by default (seed fixedLength5) and N when asked', (tester) async {
    await pumpLoovi(tester, const LooviVerificationCodeInput());
    expect(find.byType(LooviVerificationCodeInputItem), findsNWidgets(5));
    expect(find.text('Digite o código'), findsOneWidget);
    await pumpLoovi(tester, const LooviVerificationCodeInput(length: 6, key: Key('six')));
    expect(find.byType(LooviVerificationCodeInputItem), findsNWidgets(6));
  });

  testWidgets('cells are ≥ 48 dp tall and share the row', (tester) async {
    await pumpLoovi(tester, const LooviVerificationCodeInput());
    final sizes = tester.widgetList(find.byType(LooviVerificationCodeInputItem)).map((w) => tester.getSize(find.byWidget(w)));
    for (final s in sizes) {
      expect(s.height, greaterThanOrEqualTo(48));
    }
    expect(sizes.map((s) => s.width).toSet().length, 1);
  });

  testWidgets('numeric keyboard + one-time-code autofill', (tester) async {
    await pumpLoovi(tester, const LooviVerificationCodeInput());
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.keyboardType, TextInputType.number);
    expect(field.autofillHints, contains(AutofillHints.oneTimeCode));
  });

  testWidgets('typing fills cells left to right and drops non-digits', (tester) async {
    final changes = <String>[];
    await pumpLoovi(tester, LooviVerificationCodeInput(onChanged: changes.add));
    await tester.enterText(find.byType(TextField), '1a2');
    await tester.pump();
    expect(_digits(tester), ['1', '2', '', '', '']);
    expect(changes.last, '12');
  });

  testWidgets('backspace clears the previous cell', (tester) async {
    final controller = TextEditingController(text: '123');
    addTearDown(controller.dispose);
    await pumpLoovi(tester, LooviVerificationCodeInput(controller: controller));
    await tester.showKeyboard(find.byType(TextField));
    tester.testTextInput.updateEditingValue(const TextEditingValue(text: '12', selection: TextSelection.collapsed(offset: 2)));
    await tester.pump();
    expect(_digits(tester), ['1', '2', '', '', '']);
  });

  testWidgets('paste / autofill of a full code replaces the value; onCompleted fires once', (tester) async {
    final completed = <String>[];
    final controller = TextEditingController(text: '12');
    addTearDown(controller.dispose);
    await pumpLoovi(tester, LooviVerificationCodeInput(controller: controller, onCompleted: completed.add));
    await tester.showKeyboard(find.byType(TextField));
    tester.testTextInput.updateEditingValue(const TextEditingValue(text: '12987-654', selection: TextSelection.collapsed(offset: 9)));
    await tester.pump();
    expect(controller.text, '98765');
    expect(_digits(tester), ['9', '8', '7', '6', '5']);
    expect(completed, ['98765']);
  });

  testWidgets('focus paints the active (next empty) cell; error propagates to all cells', (tester) async {
    final controller = TextEditingController(text: '12');
    addTearDown(controller.dispose);
    await pumpLoovi(tester, LooviVerificationCodeInput(controller: controller));
    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(_states(tester)[2], LooviVerificationCodeInputItemState.focus);
    expect(_states(tester).where((s) => s == LooviVerificationCodeInputItemState.focus).length, 1);

    await pumpLoovi(tester, LooviVerificationCodeInput(controller: controller, error: true, key: const Key('e')));
    expect(_states(tester).toSet(), {LooviVerificationCodeInputItemState.error});
    expect(find.text('Código inválido. Tente novamente.'), findsOneWidget);
  });

  testWidgets('supporting text only in error', (tester) async {
    await pumpLoovi(tester, const LooviVerificationCodeInput(supportingText: 'Erro'));
    expect(find.text('Erro'), findsNothing);
    await pumpLoovi(tester, const LooviVerificationCodeInput(supportingText: 'Erro', error: true, showSupportingText: false, key: Key('x')));
    expect(find.text('Erro'), findsNothing);
  });

  testWidgets('disabled: no input, cells disabled, label placeholder', (tester) async {
    await pumpLoovi(tester, const LooviVerificationCodeInput(disabled: true));
    expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
    expect(_states(tester).toSet(), {LooviVerificationCodeInputItemState.disabled});
    final label = tester.widget<Text>(find.text('Digite o código'));
    expect(label.style!.color, LooviTokens.appCliente.text.placeholder);
  });

  testWidgets('semantics: field label, position hint, invalid on error', (tester) async {
    final handle = tester.ensureSemantics();
    final controller = TextEditingController(text: '12');
    addTearDown(controller.dispose);
    await pumpLoovi(tester, LooviVerificationCodeInput(controller: controller, length: 6));
    var data = tester.getSemantics(find.byType(TextField)).getSemanticsData();
    expect(data.label, contains('Digite o código'));
    expect(data.hint, 'Dígito 3 de 6');
    expect(data.validationResult, SemanticsValidationResult.none);

    await pumpLoovi(tester, LooviVerificationCodeInput(controller: controller, length: 6, error: true, supportingText: 'Código inválido', key: const Key('e')));
    data = tester.getSemantics(find.byType(TextField)).getSemanticsData();
    expect(data.hint, 'Código inválido. Dígito 3 de 6');
    expect(data.validationResult, SemanticsValidationResult.invalid);
    handle.dispose();
  });

  testWidgets('golden: states (default / focus / error / disabled)', (tester) async {
    Widget field(String text, {bool error = false, bool disabled = false, bool focus = false}) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: LooviVerificationCodeInput(
            controller: TextEditingController(text: text),
            error: error,
            disabled: disabled,
            forceFocusRing: focus,
          ),
        );
    await pumpGolden(
      tester,
      Container(
        key: const Key('golden'),
        color: LooviTokens.appCliente.color.backgroundSurface0,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            field(''),
            field('1234', focus: true),
            field('12345', error: true),
            field('12', disabled: true),
          ],
        ),
      ),
      height: 420,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/verification_code_input_states.png'));
  });
}
