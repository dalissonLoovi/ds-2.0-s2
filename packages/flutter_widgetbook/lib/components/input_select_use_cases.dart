// Direct src import until lib/loovi_ds.dart exports InputSelect (wave 3 integration).

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'input_use_cases.dart' show inputSurface;
import 'seed_header.dart';

const _options = [
  LooviInputSelectOption(value: 'sp', label: 'São Paulo'),
  LooviInputSelectOption(value: 'rj', label: 'Rio de Janeiro'),
  LooviInputSelectOption(value: 'mg', label: 'Minas Gerais'),
  LooviInputSelectOption(value: 'pr', label: 'Paraná'),
];

/// Seed `InputSelect` (3898:2755) — Playground (knobs) + States.
WidgetbookComponent looviInputSelectComponent() => WidgetbookComponent(
      name: 'InputSelect',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final appearance = context.knobs.object.dropdown<LooviInputAppearance>(
              label: 'appearance',
              options: LooviInputAppearance.values,
              labelBuilder: (v) => v == LooviInputAppearance.standard ? 'default' : v.name,
            );
            final field = _SelectPlayground(
              label: context.knobs.string(label: 'label', initialValue: 'Estado'),
              placeholder: context.knobs.stringOrNull(label: 'placeholder', initialValue: 'Selecione'),
              supportingText: context.knobs.string(label: 'supportingText', initialValue: 'Onde o carro circula.'),
              showSupportingText: context.knobs.boolean(label: 'showSupportingText'),
              error: context.knobs.boolean(label: 'state=error'),
              enabled: !context.knobs.boolean(label: 'state=disabled'),
              appearance: appearance,
              leadingIcon: context.knobs.boolean(label: 'leadingIcon'),
            );
            return SeedStory(component: 'InputSelect', child: inputSurface(context, appearance, field));
          },
        ),
        WidgetbookUseCase(
          name: 'States',
          builder: (context) => const SeedStory(component: 'InputSelect', showDescription: false, child: _SelectStates()),
        ),
      ],
    );

class _SelectPlayground extends StatefulWidget {
  const _SelectPlayground({
    required this.label,
    required this.placeholder,
    required this.supportingText,
    required this.showSupportingText,
    required this.error,
    required this.enabled,
    required this.appearance,
    required this.leadingIcon,
  });

  final String label;
  final String? placeholder;
  final String supportingText;
  final bool showSupportingText;
  final bool error;
  final bool enabled;
  final LooviInputAppearance appearance;
  final bool leadingIcon;

  @override
  State<_SelectPlayground> createState() => _SelectPlaygroundState();
}

class _SelectPlaygroundState extends State<_SelectPlayground> {
  String? _value;

  @override
  Widget build(BuildContext context) => LooviInputSelect<String>(
        label: widget.label,
        placeholder: widget.placeholder,
        supportingText: widget.supportingText,
        showSupportingText: widget.showSupportingText,
        error: widget.error,
        enabled: widget.enabled,
        appearance: widget.appearance,
        leadingIcon: widget.leadingIcon,
        options: _options,
        value: _value,
        onChanged: (v) => setState(() => _value = v),
      );
}

class _SelectStates extends StatelessWidget {
  const _SelectStates();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final gap = SizedBox(height: t.spacing.s200);
    void noop(String _) {}
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LooviInputSelect<String>(label: 'content=label', options: _options, onChanged: noop),
        gap,
        LooviInputSelect<String>(label: 'content=placeholder', placeholder: 'Selecione', options: _options, onChanged: noop),
        gap,
        LooviInputSelect<String>(label: 'content=value', options: _options, value: 'sp', leadingIcon: true, onChanged: noop),
        gap,
        LooviInputSelect<String>(label: 'state=focus (open)', options: _options, value: 'sp', expanded: true, onTap: () {}),
        gap,
        LooviInputSelect<String>(label: 'state=error', options: _options, errorText: 'Escolha um estado', onChanged: noop),
        gap,
        LooviInputSelect<String>(label: 'state=disabled', options: _options, value: 'sp', enabled: false),
        gap,
        inputSurface(
          context,
          LooviInputAppearance.inverse,
          LooviInputSelect<String>(
            label: 'appearance=inverse',
            options: _options,
            value: 'rj',
            appearance: LooviInputAppearance.inverse,
            onChanged: noop,
          ),
        ),
      ],
    );
  }
}
