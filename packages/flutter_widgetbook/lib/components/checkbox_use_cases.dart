import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// Checkbox — Figma 3667:3812 (mode app-cliente).
WidgetbookComponent looviCheckboxComponent() => WidgetbookComponent(
      name: 'Checkbox',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final checked = context.knobs.object.dropdown<LooviCheckboxChecked>(
              label: 'checked',
              options: LooviCheckboxChecked.values,
              labelBuilder: (v) => v.seedValue,
            );
            return SeedStory(
              component: 'Checkbox',
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: _InteractiveCheckbox(
                  initial: checked,
                  label: context.knobs.string(label: 'label', initialValue: 'Label Checkbox'),
                  description: context.knobs.string(label: 'description', initialValue: 'Texto de descrição abaixo do label do checkbox'),
                  showLabel: context.knobs.boolean(label: 'showLabel', initialValue: true),
                  showDescription: context.knobs.boolean(label: 'showDescription', initialValue: true),
                  showContent: context.knobs.boolean(label: 'showContent', initialValue: true),
                  disabled: context.knobs.boolean(label: 'disabled (state=disabled)'),
                  focus: context.knobs.boolean(label: 'focus ring (state=focus)'),
                ),
              ),
            );
          },
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
                      for (final c in LooviCheckboxChecked.values)
                        LooviCheckbox(
                          checked: c,
                          onChanged: disabled ? null : (_) {},
                          forceFocusRing: focus,
                          label: 'Label Checkbox',
                          description: 'checked=${c.seedValue}',
                        ),
                    ],
                  ),
                );
            return SeedStory(
              component: 'Checkbox',
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

class _InteractiveCheckbox extends StatefulWidget {
  const _InteractiveCheckbox({
    required this.initial,
    required this.label,
    required this.description,
    required this.showLabel,
    required this.showDescription,
    required this.showContent,
    required this.disabled,
    required this.focus,
  });

  final LooviCheckboxChecked initial;
  final String label;
  final String description;
  final bool showLabel;
  final bool showDescription;
  final bool showContent;
  final bool disabled;
  final bool focus;

  @override
  State<_InteractiveCheckbox> createState() => _InteractiveCheckboxState();
}

class _InteractiveCheckboxState extends State<_InteractiveCheckbox> {
  late LooviCheckboxChecked _value = widget.initial;

  @override
  void didUpdateWidget(_InteractiveCheckbox old) {
    super.didUpdateWidget(old);
    if (old.initial != widget.initial) _value = widget.initial;
  }

  @override
  Widget build(BuildContext context) => LooviCheckbox(
        checked: _value,
        onChanged: (v) => setState(() => _value = v),
        label: widget.label,
        description: widget.description,
        showLabel: widget.showLabel,
        showDescription: widget.showDescription,
        showContent: widget.showContent,
        disabled: widget.disabled,
        forceFocusRing: widget.focus,
        semanticLabel: widget.label,
      );
}
