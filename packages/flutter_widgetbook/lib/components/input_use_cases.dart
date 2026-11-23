// Direct src imports until lib/loovi_ds.dart exports the Input family (wave integration).

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// Seed `Input` (3873:334) — Playground (knobs) + States.
WidgetbookComponent looviInputComponent() => WidgetbookComponent(
      name: 'Input',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final appearance = context.knobs.object.dropdown<LooviInputAppearance>(
              label: 'appearance',
              options: LooviInputAppearance.values,
              labelBuilder: (v) => v == LooviInputAppearance.standard ? 'default' : v.name,
            );
            final error = context.knobs.boolean(label: 'state=error');
            final input = LooviInput(
              label: context.knobs.string(label: 'label', initialValue: 'E-mail'),
              placeholder: context.knobs.stringOrNull(label: 'placeholder', initialValue: 'Digite seu nome'),
              supportingText: context.knobs.string(label: 'supportingText', initialValue: 'Usado para acessar o app.'),
              showSupportingText: context.knobs.boolean(label: 'showSupportingText'),
              error: error,
              enabled: !context.knobs.boolean(label: 'state=disabled'),
              appearance: appearance,
              leadingIcon: context.knobs.boolean(label: 'leadingIcon'),
              trailingIcon: context.knobs.boolean(label: 'trailingIcon'),
            );
            return SeedStory(component: 'Input', child: inputSurface(context, appearance, input));
          },
        ),
        WidgetbookUseCase(
          name: 'States',
          builder: (context) => SeedStory(
            component: 'Input',
            showDescription: false,
            child: _InputStatesStory(),
          ),
        ),
      ],
    );

/// Wraps inverse samples on `color/background-surface/inverse-3`.
Widget inputSurface(BuildContext context, LooviInputAppearance appearance, Widget child) {
  final t = LooviTokens.of(context);
  if (appearance != LooviInputAppearance.inverse) return child;
  return ColoredBox(
    color: t.color.backgroundSurfaceInverse3,
    child: Padding(padding: EdgeInsets.all(t.spacing.s200), child: child),
  );
}

class _InputStatesStory extends StatefulWidget {
  @override
  State<_InputStatesStory> createState() => _InputStatesStoryState();
}

class _InputStatesStoryState extends State<_InputStatesStory> {
  final _value = TextEditingController(text: 'Ana Souza');
  final _error = TextEditingController(text: 'Ana Souza');
  final _disabled = TextEditingController(text: 'Ana Souza');
  final _inverse = TextEditingController(text: 'Ana Souza');

  @override
  void dispose() {
    for (final c in [_value, _error, _disabled, _inverse]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final gap = SizedBox(height: t.spacing.s200);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const LooviInput(label: 'content=placeholder', placeholder: 'Digite seu nome', leadingIcon: true, trailingIcon: true),
        gap,
        LooviInput(label: 'content=value', controller: _value, leadingIcon: true, trailingIcon: true),
        gap,
        const LooviInput(label: 'content=label (tap = focus)', leadingIcon: true, trailingIcon: true),
        gap,
        LooviInput(label: 'state=error', controller: _error, leadingIcon: true, trailingIcon: true, errorText: 'Confira o nome digitado.'),
        gap,
        LooviInput(label: 'state=disabled', controller: _disabled, leadingIcon: true, trailingIcon: true, enabled: false, supportingText: 'Usado para acessar o app.'),
        gap,
        inputSurface(
          context,
          LooviInputAppearance.inverse,
          LooviInput(label: 'appearance=inverse', controller: _inverse, appearance: LooviInputAppearance.inverse, leadingIcon: true, trailingIcon: true),
        ),
      ],
    );
  }
}
