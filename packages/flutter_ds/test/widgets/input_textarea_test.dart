import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

Finder _field() => find.descendant(
      of: find.byType(LooviInputTextArea),
      matching: find.byWidgetPredicate((w) => w is DecoratedBox && (w.decoration as BoxDecoration).border != null),
    );

BoxDecoration _deco(WidgetTester tester) => tester.widget<DecoratedBox>(_field()).decoration as BoxDecoration;
Border _border(WidgetTester tester) => _deco(tester).border! as Border;

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('typing updates value and the default count', (tester) async {
    final controller = TextEditingController();
    await pumpLoovi(tester, LooviInputTextArea(label: 'Mensagem', controller: controller, maxLength: 100));
    expect(find.text('0/100'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Olá\nmundo');
    await tester.pump();
    expect(controller.text, 'Olá\nmundo');
    expect(find.text('9/100'), findsOneWidget);
  });

  testWidgets('maxLength is enforced', (tester) async {
    final controller = TextEditingController();
    await pumpLoovi(tester, LooviInputTextArea(controller: controller, maxLength: 5));
    await tester.enterText(find.byType(TextField), '1234567');
    await tester.pump();
    expect(controller.text, '12345');
  });

  testWidgets('focus paints interactive/focus 2 dp and brand floating label', (tester) async {
    await pumpLoovi(tester, const LooviInputTextArea(label: 'Mensagem', countText: '0/100'));
    expect(_border(tester).top.color, _t.color.border1);
    await tester.tap(find.byType(LooviInputTextArea));
    await tester.pump();
    expect(_border(tester).top.color, _t.interactive.focus);
    expect(_border(tester).top.width, _t.borderWidth.s025);
    final label = tester.widget<Text>(find.descendant(of: find.byType(LooviInputFloatingLabel), matching: find.byType(Text)));
    expect(label.style!.color, _t.text.brand);
    expect(label.style!.fontSize, _t.typography.captionLargeRegular.fontSize);
  });

  testWidgets('error shows danger message and stroke', (tester) async {
    await pumpLoovi(tester, const LooviInputTextArea(errorText: 'Campo obrigatório'));
    final msg = tester.widget<Text>(find.text('Campo obrigatório'));
    expect(msg.style!.color, _t.feedback.danger);
    expect(_border(tester).top.color, _t.color.borderFeedbackDanger);
  });

  testWidgets('disabled does not edit', (tester) async {
    final controller = TextEditingController(text: 'fixo');
    await pumpLoovi(tester, LooviInputTextArea(controller: controller, enabled: false));
    await tester.enterText(find.byType(TextField), 'novo');
    await tester.pump();
    expect(controller.text, 'fixo');
  });

  testWidgets('semantics: multiline text field with label and count', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const LooviInputTextArea(label: 'Comentário', countText: '0/100', errorText: 'Erro'));
    final data = tester.getSemantics(find.byType(TextField)).getSemanticsData();
    expect(data.label, contains('Comentário'));
    expect(data.hint, contains('0/100'));
    expect(data.flagsCollection.isTextField, isTrue);
    expect(data.flagsCollection.isMultiline, isTrue);
    expect(data.validationResult, SemanticsValidationResult.invalid);
    handle.dispose();
  });

  testWidgets('app-cliente radius = component/input-textarea/field/radius (20), min height 160', (tester) async {
    await pumpLoovi(tester, const LooviInputTextArea());
    expect(_t.component.inputTextarea.fieldRadius, _t.radius.s500);
    expect(_deco(tester).borderRadius, BorderRadius.circular(20));
    expect(tester.getSize(_field()).height, 160);
  });

  testWidgets('grows with content and with the system textScaler', (tester) async {
    final controller = TextEditingController(text: List.filled(12, 'linha').join('\n'));
    await pumpLoovi(tester, LooviInputTextArea(controller: controller), textScale: 1.5);
    expect(tester.getSize(_field()).height, greaterThan(160));
    expect(tester.takeException(), isNull);
  });

  testWidgets('golden: InputTextArea states (app-cliente)', (tester) async {
    await pumpGolden(tester, const _TextAreaStates(), height: 1160);
    await expectLater(find.byType(_TextAreaStates), matchesGoldenFile('../goldens/input_textarea_states.png'));
  });
}

class _TextAreaStates extends StatelessWidget {
  const _TextAreaStates();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget gap() => SizedBox(height: t.spacing.s100);
    const value = 'Input text goes here for a longer message.';
    return Padding(
      padding: EdgeInsets.all(t.spacing.s200),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LooviInputTextArea(controller: TextEditingController(text: value), countText: '0/100'),
          gap(),
          const LooviInputTextArea(placeholder: 'Placeholder', countText: '0/100'),
          gap(),
          const LooviInputTextArea(countText: '0/100'),
          gap(),
          LooviInputTextArea(controller: TextEditingController(text: value), countText: '0/100', trailingIcon: true, autofocus: true, showCursor: false),
          gap(),
          LooviInputTextArea(controller: TextEditingController(text: value), countText: '0/100', leadingIcon: true, errorText: 'Supporting text'),
          gap(),
          LooviInputTextArea(controller: TextEditingController(text: value), countText: '0/100', enabled: false),
        ],
      ),
    );
  }
}
