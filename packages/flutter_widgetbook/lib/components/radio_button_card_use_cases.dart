import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// RadioButtonCard — Figma 4498:68 (mode app-cliente). No hover on the app.
WidgetbookComponent looviRadioButtonCardComponent() => WidgetbookComponent(
      name: 'RadioButtonCard',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) => SeedStory(
            component: 'RadioButtonCard',
            child: _InteractiveCards(
              description: context.knobs.string(label: 'description', initialValue: 'Texto de descrição abaixo do label do radio'),
              showDescription: context.knobs.boolean(label: 'showDescription', initialValue: true),
              disabled: context.knobs.boolean(label: 'disabled (state=disabled)'),
              focus: context.knobs.boolean(label: 'focus stroke (state=focus)'),
            ),
          ),
        ),
        WidgetbookUseCase(
          name: 'States',
          builder: (context) {
            final t = LooviTokens.of(context);
            Widget row(String state, {bool disabled = false, bool focus = false}) => Padding(
                  padding: EdgeInsets.only(bottom: t.spacing.s200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('state=$state', style: t.typography.bodySmallMedium.copyWith(color: t.text.secondary)),
                      for (final checked in [false, true])
                        Padding(
                          padding: EdgeInsets.only(top: t.spacing.s100),
                          child: LooviRadioButtonCard<bool>(
                            value: true,
                            groupValue: checked,
                            onChanged: disabled ? null : (_) {},
                            forceFocusRing: focus,
                            label: checked ? 'Sim' : 'Não',
                            description: 'checked=$checked',
                          ),
                        ),
                    ],
                  ),
                );
            return SeedStory(
              component: 'RadioButtonCard',
              showDescription: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [row('default'), row('focus', focus: true), row('disabled', disabled: true)],
              ),
            );
          },
        ),
      ],
    );

class _InteractiveCards extends StatefulWidget {
  const _InteractiveCards({required this.description, required this.showDescription, required this.disabled, required this.focus});

  final String description;
  final bool showDescription;
  final bool disabled;
  final bool focus;

  @override
  State<_InteractiveCards> createState() => _InteractiveCardsState();
}

class _InteractiveCardsState extends State<_InteractiveCards> {
  String _value = 'sim';

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return Semantics(
      label: 'Você possui seguro?',
      container: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (v, label) in [('sim', 'Sim'), ('nao', 'Não')])
            Padding(
              padding: EdgeInsets.only(bottom: t.spacing.s100),
              child: LooviRadioButtonCard<String>(
                value: v,
                groupValue: _value,
                onChanged: (n) => setState(() => _value = n),
                label: label,
                description: widget.description,
                showDescription: widget.showDescription,
                disabled: widget.disabled,
                forceFocusRing: widget.focus && v == _value,
              ),
            ),
        ],
      ),
    );
  }
}
