// Direct src imports until lib/loovi_ds.dart exports wave 3 (integration).

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'input_use_cases.dart' show inputSurface;
import 'seed_header.dart';

/// In-field block of the Playground (showSelectCountry and
/// showPaymentMethodMark are mutually exclusive, so one knob).
enum _Block { none, selectCountry, paymentMethodMark }

/// Seed `InputNumber` (3935:684) — Playground (knobs) + States.
WidgetbookComponent looviInputNumberComponent() => WidgetbookComponent(
      name: 'InputNumber',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            final appearance = k.object.dropdown<LooviInputAppearance>(
              label: 'appearance',
              options: LooviInputAppearance.values,
              labelBuilder: (v) => v == LooviInputAppearance.standard ? 'default' : v.name,
            );
            final block = k.object.dropdown<_Block>(
              label: 'block (showSelectCountry | showPaymentMethodMark)',
              options: _Block.values,
              initialOption: _Block.selectCountry,
              labelBuilder: (v) => v.name,
            );
            final field = LooviInputNumber(
              key: ValueKey(block),
              label: k.string(label: 'label', initialValue: 'Número de telefone'),
              placeholder: k.stringOrNull(label: 'placeholder'),
              supportingText: k.string(label: 'supportingText', initialValue: 'Supporting text'),
              showSupportingText: k.boolean(label: 'showSupportingText'),
              error: k.boolean(label: 'state=error'),
              enabled: !k.boolean(label: 'state=disabled'),
              appearance: appearance,
              leadingIcon: k.boolean(label: 'leadingIcon'),
              trailingIcon: k.boolean(label: 'trailingIcon'),
              showSelectCountry: block == _Block.selectCountry,
              onCountryPressed: () {},
              showPaymentMethodMark: block == _Block.paymentMethodMark,
              paymentMethodBrand: k.object.dropdown<LooviInputNumberTrailingPaymentMarkBrand>(
                label: 'paymentMethodMark (placeholder brand)',
                options: LooviInputNumberTrailingPaymentMarkBrand.values,
                labelBuilder: (v) => v.name,
              ),
            );
            return SeedStory(component: 'InputNumber', child: inputSurface(context, appearance, field));
          },
        ),
        WidgetbookUseCase(
          name: 'States',
          builder: (context) => SeedStory(component: 'InputNumber', showDescription: false, child: _States()),
        ),
      ],
    );

class _States extends StatefulWidget {
  @override
  State<_States> createState() => _StatesState();
}

class _StatesState extends State<_States> {
  late final _phone = List.generate(4, (_) => TextEditingController(text: '+ 55'));
  late final _card = TextEditingController(text: '4111 1111 1111 1111');

  @override
  void dispose() {
    for (final c in _phone) {
      c.dispose();
    }
    _card.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final gap = SizedBox(height: t.spacing.s200);
    void noop() {}
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const LooviInputNumber(label: 'Quantidade'),
        gap,
        LooviInputNumber(showSelectCountry: true, onCountryPressed: noop, controller: _phone[0]),
        gap,
        LooviInputNumber(
          label: 'Número do cartão',
          placeholder: '0000 0000 0000 0000',
          showPaymentMethodMark: true,
          paymentMethodBrand: LooviInputNumberTrailingPaymentMarkBrand.visa,
          controller: _card,
        ),
        gap,
        LooviInputNumber(
          showSelectCountry: true,
          onCountryPressed: noop,
          controller: _phone[1],
          errorText: 'Número inválido',
        ),
        gap,
        LooviInputNumber(showSelectCountry: true, enabled: false, controller: _phone[2]),
        gap,
        inputSurface(
          context,
          LooviInputAppearance.inverse,
          LooviInputNumber(
            appearance: LooviInputAppearance.inverse,
            showSelectCountry: true,
            onCountryPressed: noop,
            controller: _phone[3],
          ),
        ),
      ],
    );
  }
}
