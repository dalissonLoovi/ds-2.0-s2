import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// SliderBaseItem (seed node 3950:7416) — INTERNAL to Slider; shown for
/// reference only (static track + Input slots).
WidgetbookComponent looviSliderBaseItemComponent() => WidgetbookComponent(
  name: 'SliderBaseItem (internal)',
  useCases: [
    WidgetbookUseCase(
      name: 'Playground',
      builder: (context) {
        final k = context.knobs;
        final label = k.string(label: 'label', initialValue: 'Label');
        final active = k.boolean(label: 'sliderItem.active', initialValue: false);
        final fill = k.double.slider(label: 'fill (0–1)', initialValue: 0.4, min: 0, max: 1);
        final disabled = k.boolean(label: 'disabled', initialValue: false);
        return SeedStory(
          component: 'SliderBaseItem',
          child: LooviSliderBaseItem(
            label: label,
            minValue: k.string(label: 'minValue', initialValue: '0'),
            maxValue: k.string(label: 'maxValue', initialValue: '100'),
            disabled: disabled,
            sliderItem: SizedBox(
              height: LooviTapTarget.minSize(context),
              child: Center(child: LooviSliderItem(active: active, fraction: fill)),
            ),
            input: _StaticInput(label: label, value: '${(fill * 100).round()}', enabled: !disabled),
          ),
        );
      },
    ),
  ],
);

/// Input slot with its own controller (the real Slider owns it).
class _StaticInput extends StatefulWidget {
  const _StaticInput({required this.label, required this.value, required this.enabled});

  final String label;
  final String value;
  final bool enabled;

  @override
  State<_StaticInput> createState() => _StaticInputState();
}

class _StaticInputState extends State<_StaticInput> {
  late final TextEditingController _c = TextEditingController(text: widget.value);

  @override
  void didUpdateWidget(_StaticInput old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) _c.text = widget.value;
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LooviInput(label: widget.label, controller: _c, enabled: widget.enabled);
}
