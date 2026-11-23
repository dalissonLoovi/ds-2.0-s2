import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// RadioButton — Figma 3653:5279 (mode app-cliente). No hover on the app.
WidgetbookComponent looviRadioButtonComponent() => WidgetbookComponent(
      name: 'RadioButton',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) => SeedStory(
            component: 'RadioButton',
            child: _InteractiveGroup(
              label: context.knobs.string(label: 'label', initialValue: 'Label Radio'),
              description: context.knobs.string(label: 'description', initialValue: 'Texto de descrição abaixo do label do radio'),
              showLabel: context.knobs.boolean(label: 'showLabel', initialValue: true),
              showDescription: context.knobs.boolean(label: 'showDescription', initialValue: true),
              showContent: context.knobs.boolean(label: 'showContent', initialValue: true),
              disabled: context.knobs.boolean(label: 'disabled (state=disabled)'),
              focus: context.knobs.boolean(label: 'focus ring (state=focus)'),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('state=$state', style: t.typography.bodySmallMedium.copyWith(color: t.text.secondary)),
                      for (final checked in [false, true])
                        LooviRadioButton<bool>(
                          value: true,
                          groupValue: checked,
                          onChanged: disabled ? null : (_) {},
                          forceFocusRing: focus,
                          label: 'Label Radio',
                          description: 'checked=$checked',
                        ),
                    ],
                  ),
                );
            return SeedStory(
              component: 'RadioButton',
              showDescription: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  row('default'),
                  row('focus', focus: true),
                  row('disabled', disabled: true),
                ],
              ),
            );
          },
        ),
      ],
    );

class _InteractiveGroup extends StatefulWidget {
  const _InteractiveGroup({
    required this.label,
    required this.description,
    required this.showLabel,
    required this.showDescription,
    required this.showContent,
    required this.disabled,
    required this.focus,
  });

  final String label;
  final String description;
  final bool showLabel;
  final bool showDescription;
  final bool showContent;
  final bool disabled;
  final bool focus;

  @override
  State<_InteractiveGroup> createState() => _InteractiveGroupState();
}

class _InteractiveGroupState extends State<_InteractiveGroup> {
  int _value = 1;

  @override
  Widget build(BuildContext context) => Semantics(
        label: 'Grupo de exemplo',
        container: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final v in [1, 2, 3])
              LooviRadioButton<int>(
                value: v,
                groupValue: _value,
                onChanged: (n) => setState(() => _value = n),
                label: '${widget.label} $v',
                description: widget.description,
                showLabel: widget.showLabel,
                showDescription: widget.showDescription,
                showContent: widget.showContent,
                disabled: widget.disabled,
                forceFocusRing: widget.focus && v == _value,
                semanticLabel: '${widget.label} $v',
              ),
          ],
        ),
      );
}
