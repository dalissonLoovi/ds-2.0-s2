import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// Slider (seed node 3950:7327): Playground + Statuses.
WidgetbookComponent looviSliderComponent() => WidgetbookComponent(
  name: 'Slider',
  useCases: [
    WidgetbookUseCase(
      name: 'Playground',
      builder: (context) {
        final k = context.knobs;
        final error = k.string(label: 'errorText (empty = none)', initialValue: '');
        final warning = k.string(label: 'warningText (empty = none)', initialValue: '');
        return SeedStory(
          component: 'Slider',
          child: _Playground(
            label: k.string(label: 'label', initialValue: 'Label'),
            min: k.double.input(label: 'min', initialValue: 0),
            max: k.double.input(label: 'max', initialValue: 100),
            step: k.double.input(label: 'step (0 = continuous)', initialValue: 1),
            errorText: error.isEmpty ? null : error,
            warningText: warning.isEmpty ? null : warning,
            enabled: k.boolean(label: 'enabled (false = status disabled)', initialValue: true),
            readOnly: k.boolean(label: 'readOnly (status read-only)', initialValue: false),
            skeleton: k.boolean(label: 'skeleton (status skeleton)', initialValue: false),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Statuses',
      builder: (context) => const SeedStory(component: 'Slider', showDescription: false, child: _Statuses()),
    ),
  ],
);

class _Playground extends StatefulWidget {
  const _Playground({
    required this.label,
    required this.min,
    required this.max,
    required this.step,
    required this.errorText,
    required this.warningText,
    required this.enabled,
    required this.readOnly,
    required this.skeleton,
  });

  final String label;
  final double min;
  final double max;
  final double step;
  final String? errorText;
  final String? warningText;
  final bool enabled;
  final bool readOnly;
  final bool skeleton;

  @override
  State<_Playground> createState() => _PlaygroundState();
}

class _PlaygroundState extends State<_Playground> {
  double _value = 40;

  @override
  Widget build(BuildContext context) {
    final max = widget.max > widget.min ? widget.max : widget.min + 1;
    return LooviSlider(
      value: _value.clamp(widget.min, max).toDouble(),
      min: widget.min,
      max: max,
      step: widget.step > 0 ? widget.step : null,
      label: widget.label,
      errorText: widget.errorText,
      warningText: widget.warningText,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      skeleton: widget.skeleton,
      onChanged: (v) => setState(() => _value = v),
    );
  }
}

/// Every seed status (hover does not exist on the app; focus / active =
/// autofocused track). Same as the golden `slider_statuses.png`.
class _Statuses extends StatelessWidget {
  const _Statuses();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    void noop(double _) {}
    final gap = SizedBox(height: t.spacing.s300);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LooviSlider(value: 40, onChanged: noop, label: 'Enabled'),
        gap,
        LooviSlider(value: 50, onChanged: noop, label: 'Focus / active', autofocus: true),
        gap,
        LooviSlider(value: 60, onChanged: noop, label: 'Error', errorText: 'Error message goes here'),
        gap,
        LooviSlider(value: 60, onChanged: noop, label: 'Warning', warningText: 'Warning message goes here'),
        gap,
        LooviSlider(value: 50, onChanged: noop, label: 'Disabled', enabled: false),
        gap,
        LooviSlider(value: 50, onChanged: noop, label: 'Read-only', readOnly: true),
        gap,
        LooviSlider(value: 50, onChanged: noop, label: 'Skeleton', skeleton: true),
      ],
    );
  }
}
