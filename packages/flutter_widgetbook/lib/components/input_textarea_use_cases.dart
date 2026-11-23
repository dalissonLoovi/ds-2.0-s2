// Direct src imports until lib/loovi_ds.dart exports the Input family (wave integration).

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'input_use_cases.dart' show inputSurface;
import 'seed_header.dart';

/// Seed `InputTextArea` (4052:21848) — Playground (knobs) + States.
WidgetbookComponent looviInputTextAreaComponent() => WidgetbookComponent(
      name: 'InputTextArea',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final appearance = context.knobs.object.dropdown<LooviInputAppearance>(
              label: 'appearance',
              options: LooviInputAppearance.values,
              labelBuilder: (v) => v == LooviInputAppearance.standard ? 'default' : v.name,
            );
            final field = LooviInputTextArea(
              label: context.knobs.string(label: 'label', initialValue: 'Mensagem'),
              placeholder: context.knobs.stringOrNull(label: 'placeholder', initialValue: 'Conte o que aconteceu'),
              supportingText: context.knobs.string(label: 'supportingText', initialValue: 'Inclua onde e quando aconteceu.'),
              showSupportingText: context.knobs.boolean(label: 'showSupportingText'),
              maxLength: context.knobs.boolean(label: 'showCount', initialValue: true) ? 100 : null,
              showResizeHandle: context.knobs.boolean(label: 'showResizeHandle', initialValue: true),
              error: context.knobs.boolean(label: 'state=error'),
              enabled: !context.knobs.boolean(label: 'state=disabled'),
              appearance: appearance,
              leadingIcon: context.knobs.boolean(label: 'leadingIcon'),
              trailingIcon: context.knobs.boolean(label: 'trailingIcon'),
            );
            return SeedStory(component: 'InputTextArea', child: inputSurface(context, appearance, field));
          },
        ),
        WidgetbookUseCase(
          name: 'States',
          builder: (context) => SeedStory(
            component: 'InputTextArea',
            showDescription: false,
            child: _TextAreaStatesStory(),
          ),
        ),
      ],
    );

class _TextAreaStatesStory extends StatefulWidget {
  @override
  State<_TextAreaStatesStory> createState() => _TextAreaStatesStoryState();
}

class _TextAreaStatesStoryState extends State<_TextAreaStatesStory> {
  static const _text = 'O carro fez um barulho na roda dianteira ao frear.';
  late final List<TextEditingController> _c = List.generate(4, (_) => TextEditingController(text: _text));

  @override
  void dispose() {
    for (final c in _c) {
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
        LooviInputTextArea(label: 'content=value', controller: _c[0], maxLength: 100),
        gap,
        const LooviInputTextArea(label: 'content=placeholder', placeholder: 'Conte o que aconteceu', maxLength: 100),
        gap,
        const LooviInputTextArea(label: 'content=label (tap = focus)', maxLength: 100),
        gap,
        LooviInputTextArea(label: 'state=error', controller: _c[1], maxLength: 100, leadingIcon: true, errorText: 'Conte com mais detalhes o que aconteceu.'),
        gap,
        LooviInputTextArea(label: 'state=disabled', controller: _c[2], maxLength: 100, enabled: false),
        gap,
        inputSurface(
          context,
          LooviInputAppearance.inverse,
          LooviInputTextArea(label: 'appearance=inverse', controller: _c[3], maxLength: 100, appearance: LooviInputAppearance.inverse),
        ),
      ],
    );
  }
}
