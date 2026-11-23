import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// ChipClickable (seed node 3653:23577) — Playground + Matrix.
/// `state` of the seed: pressed comes from touch, selected/disabled are knobs.
WidgetbookComponent looviChipClickableComponent() => WidgetbookComponent(
      name: 'ChipClickable',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            return SeedStory(
              component: 'ChipClickable',
              child: Align(
                alignment: Alignment.centerLeft,
                child: _PlaygroundChip(
                  label: k.string(label: 'label', initialValue: 'Label'),
                  size: k.object.dropdown<LooviChipClickableSize>(
                    label: 'size',
                    options: LooviChipClickableSize.values,
                    initialOption: LooviChipClickableSize.md,
                    labelBuilder: (v) => v.name,
                  ),
                  intent: k.object.dropdown<LooviChipClickableIntent>(
                    label: 'intent',
                    options: LooviChipClickableIntent.values,
                    initialOption: LooviChipClickableIntent.outline,
                    labelBuilder: (v) => v.name,
                  ),
                  width: k.object.dropdown<LooviChipClickableWidth>(
                    label: 'width',
                    options: LooviChipClickableWidth.values,
                    labelBuilder: (v) => v.name,
                  ),
                  selected: k.boolean(label: 'state=selected'),
                  disabled: k.boolean(label: 'state=disabled'),
                  showLeadingIcon: k.boolean(label: 'showLeadingIcon'),
                  leadingIcon: k.object.dropdown<String>(
                    label: 'leadingIcon',
                    options: LooviIcons.all.toList(),
                    initialOption: LooviIcons.plusOutline,
                  ),
                  showDeleteAction: k.boolean(label: 'showDeleteAction'),
                ),
              ),
            );
          },
        ),
        WidgetbookUseCase(
          name: 'Matrix',
          builder: (context) =>
              const SeedStory(component: 'ChipClickable', showDescription: false, child: _ChipClickableMatrix()),
        ),
      ],
    );

/// Playground chip: tapping toggles `selected` locally (filter behaviour).
class _PlaygroundChip extends StatefulWidget {
  const _PlaygroundChip({
    required this.label,
    required this.size,
    required this.intent,
    required this.width,
    required this.selected,
    required this.disabled,
    required this.showLeadingIcon,
    required this.leadingIcon,
    required this.showDeleteAction,
  });

  final String label;
  final LooviChipClickableSize size;
  final LooviChipClickableIntent intent;
  final LooviChipClickableWidth width;
  final bool selected;
  final bool disabled;
  final bool showLeadingIcon;
  final String leadingIcon;
  final bool showDeleteAction;

  @override
  State<_PlaygroundChip> createState() => _PlaygroundChipState();
}

class _PlaygroundChipState extends State<_PlaygroundChip> {
  late bool _selected = widget.selected;

  @override
  void didUpdateWidget(_PlaygroundChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) _selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) => LooviChipClickable(
        label: widget.label,
        size: widget.size,
        intent: widget.intent,
        width: widget.width,
        selected: _selected,
        disabled: widget.disabled,
        showLeadingIcon: widget.showLeadingIcon,
        leadingIcon: widget.leadingIcon,
        showDeleteAction: widget.showDeleteAction,
        onDelete: () {},
        onPressed: () => setState(() => _selected = !_selected),
      );
}

class _ChipClickableMatrix extends StatelessWidget {
  const _ChipClickableMatrix();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget chip(LooviChipClickableSize size, LooviChipClickableIntent intent,
            {bool selected = false, bool disabled = false, bool icon = false, bool delete = false}) =>
        LooviChipClickable(
          label: 'Label',
          size: size,
          intent: intent,
          selected: selected,
          disabled: disabled,
          showLeadingIcon: icon,
          leadingIcon: LooviIcons.circlePlusOutline,
          showDeleteAction: delete,
          onPressed: () {},
        );
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      for (final size in LooviChipClickableSize.values) ...[
        for (final intent in LooviChipClickableIntent.values)
          Row(children: [
            chip(size, intent),
            SizedBox(width: t.spacing.s100),
            chip(size, intent, selected: true),
            SizedBox(width: t.spacing.s100),
            chip(size, intent, icon: true, delete: true),
          ]),
        Row(children: [
          chip(size, LooviChipClickableIntent.system, disabled: true),
          SizedBox(width: t.spacing.s100),
          chip(size, LooviChipClickableIntent.system, disabled: true, icon: true, delete: true),
        ]),
      ],
    ]);
  }
}
