import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
// Direct src imports until lib/loovi_ds.dart exports wave 3 (integration).
import 'package:loovi_ds/src/widgets/input/loovi_input.dart' show LooviInputFloatingLabel;
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

TextEditingValue _format(TextInputFormatter f, String text) =>
    f.formatEditUpdate(TextEditingValue.empty, TextEditingValue(text: text));

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('composes LooviInput; default digits-only number keyboard', (tester) async {
    final controller = TextEditingController();
    await pumpLoovi(tester, LooviInputNumber(label: 'Quantidade', controller: controller));
    expect(find.byType(LooviInput), findsOneWidget);
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.keyboardType, TextInputType.number);
    await tester.enterText(find.byType(TextField), '12a3');
    await tester.pump();
    expect(controller.text, '123');
  });

  testWidgets('showSelectCountry: phone keyboard, country trigger named separately', (tester) async {
    final handle = tester.ensureSemantics();
    var opened = 0;
    await pumpLoovi(
      tester,
      LooviInputNumber(
        showSelectCountry: true,
        onCountryPressed: () => opened++,
        controller: TextEditingController(text: '+ 55'),
      ),
    );
    expect(tester.widget<TextField>(find.byType(TextField)).keyboardType, TextInputType.phone);
    expect(find.byType(LooviSelectCountry), findsOneWidget);
    final sc = tester.widget<LooviSelectCountry>(find.byType(LooviSelectCountry));
    expect(sc.size, LooviSelectCountrySize.sm);
    await tester.tap(find.bySemanticsLabel('Selecionar país, Brasil'));
    expect(opened, 1);
    // Tapping the country does not focus the text field.
    expect(tester.widget<TextField>(find.byType(TextField)).focusNode!.hasFocus, isFalse);
    handle.dispose();
  });

  testWidgets('floating label stays at the content start with the country block', (tester) async {
    await pumpLoovi(
      tester,
      LooviInputNumber(showSelectCountry: true, onCountryPressed: () {}, controller: TextEditingController(text: '11')),
    );
    final labelLeft = tester.getTopLeft(find.byType(LooviInputFloatingLabel)).dx;
    final countryPaint = find.descendant(of: find.byType(LooviSelectCountry), matching: find.byType(DecoratedBox)).first;
    // Label cutout starts spacing/050 before the content start (field padding spacing/300).
    expect(labelLeft, _t.spacing.s300 - _t.spacing.s050);
    expect(tester.getTopLeft(countryPaint).dx, lessThanOrEqualTo(_t.spacing.s300 + 1));
  });

  testWidgets('inverse: country chevron on-color; focus text/brand; disabled on-color-disabled', (tester) async {
    Color chevron() => tester
        .widget<LooviIcon>(find.byWidgetPredicate((w) => w is LooviIcon && w.name == LooviIcons.chevronDownOutline))
        .color!;
    await pumpLoovi(
      tester,
      LooviInputNumber(appearance: LooviInputAppearance.inverse, showSelectCountry: true, onCountryPressed: () {}),
    );
    expect(chevron(), _t.text.onColor);
    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(chevron(), _t.text.brand);

    await pumpLoovi(
      tester,
      const LooviInputNumber(appearance: LooviInputAppearance.inverse, showSelectCountry: true, enabled: false),
    );
    expect(chevron(), _t.text.onColorDisabled);
    expect(tester.widget<LooviSelectCountry>(find.byType(LooviSelectCountry)).disabled, isTrue);
  });

  testWidgets('payment mark sits before the error icon and is decorative', (tester) async {
    await pumpLoovi(
      tester,
      const LooviInputNumber(
        label: 'Número do cartão',
        showPaymentMethodMark: true,
        paymentMethodBrand: LooviInputNumberTrailingPaymentMarkBrand.visa,
        errorText: 'Cartão inválido',
      ),
    );
    final mark = tester.getCenter(find.byType(LooviInputNumberTrailingPaymentMark)).dx;
    final alert = tester.getCenter(
      find.byWidgetPredicate((w) => w is LooviIcon && w.name == LooviIcons.alertCircleOutline),
    ).dx;
    expect(mark, lessThan(alert));
    expect(tester.widget<Text>(find.text('Cartão inválido')).style!.color, _t.text.danger);
  });

  testWidgets('card formatter groups by 4 and caps at 19 digits', (tester) async {
    final f = LooviInputNumberCardFormatter();
    expect(_format(f, '4111111111111111').text, '4111 1111 1111 1111');
    expect(_format(f, '4111-11x').text, '4111 11');
    expect(_format(f, '1' * 25).text.replaceAll(' ', '').length, 19);

    final controller = TextEditingController();
    await pumpLoovi(tester, LooviInputNumber(showPaymentMethodMark: true, controller: controller));
    await tester.enterText(find.byType(TextField), '41111111');
    await tester.pump();
    expect(controller.text, '4111 1111');
  });

  testWidgets('semantics: labelled text field; disabled not editable', (tester) async {
    final handle = tester.ensureSemantics();
    final controller = TextEditingController(text: '10');
    await pumpLoovi(tester, LooviInputNumber(label: 'Quantidade', controller: controller, enabled: false));
    final data = tester.getSemantics(find.byType(TextField)).getSemanticsData();
    expect(data.label, contains('Quantidade'));
    await tester.enterText(find.byType(TextField), '99');
    expect(controller.text, '10');
    handle.dispose();
  });

  testWidgets('golden: InputNumber phone / card / states (app-cliente)', (tester) async {
    await pumpGolden(tester, const _States(), height: 560);
    await expectLater(find.byType(_States), matchesGoldenFile('../goldens/input_number_states.png'));
  });
}

class _States extends StatelessWidget {
  const _States();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget gap() => SizedBox(height: t.spacing.s200);
    void noop() {}
    return Padding(
      padding: EdgeInsets.all(t.spacing.s200),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const LooviInputNumber(label: 'Quantidade'),
          gap(),
          LooviInputNumber(showSelectCountry: true, onCountryPressed: noop, controller: TextEditingController(text: '+ 55')),
          gap(),
          LooviInputNumber(
            label: 'Número do cartão',
            placeholder: '0000 0000 0000 0000',
            showPaymentMethodMark: true,
            paymentMethodBrand: LooviInputNumberTrailingPaymentMarkBrand.visa,
            trailingIcon: true,
            controller: TextEditingController(text: '4111 1111 1111 1111'),
          ),
          gap(),
          LooviInputNumber(
            showSelectCountry: true,
            onCountryPressed: noop,
            controller: TextEditingController(text: '+ 55 11'),
            errorText: 'Número inválido',
          ),
          gap(),
          LooviInputNumber(showSelectCountry: true, enabled: false, controller: TextEditingController(text: '+ 55')),
          gap(),
          ColoredBox(
            color: t.color.backgroundSurfaceInverse3,
            child: Padding(
              padding: EdgeInsets.all(t.spacing.s200),
              child: LooviInputNumber(
                appearance: LooviInputAppearance.inverse,
                showSelectCountry: true,
                onCountryPressed: noop,
                controller: TextEditingController(text: '+ 55'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
