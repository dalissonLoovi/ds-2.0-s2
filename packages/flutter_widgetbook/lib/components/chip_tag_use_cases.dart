import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// ChipTag (seed node 3653:23220) — Playground + Matrix.
WidgetbookComponent looviChipTagComponent() => WidgetbookComponent(
      name: 'ChipTag',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            final width = k.object.dropdown<LooviChipTagWidth>(
              label: 'width',
              options: LooviChipTagWidth.values,
              labelBuilder: (v) => v.name,
            );
            return SeedStory(
              component: 'ChipTag',
              child: Align(
                alignment: Alignment.centerLeft,
                child: LooviChipTag(
                  label: k.string(label: 'label', initialValue: 'Label'),
                  size: k.object.dropdown<LooviChipTagSize>(
                    label: 'size',
                    options: LooviChipTagSize.values,
                    initialOption: LooviChipTagSize.md,
                    labelBuilder: (v) => v.name,
                  ),
                  intent: k.object.dropdown<LooviChipTagIntent>(
                    label: 'intent',
                    options: LooviChipTagIntent.values,
                    labelBuilder: (v) => v.name,
                  ),
                  emphasis: k.object.dropdown<LooviChipTagEmphasis>(
                    label: 'emphasis',
                    options: LooviChipTagEmphasis.values,
                    labelBuilder: (v) => v.name,
                  ),
                  width: width,
                  disabled: k.boolean(label: 'state=disabled'),
                  showLeadingIcon: k.boolean(label: 'showLeadingIcon'),
                  leadingIcon: k.object.dropdown<String>(
                    label: 'leadingIcon',
                    options: LooviIcons.all.toList(),
                    initialOption: LooviIcons.circleCheckFilled,
                  ),
                ),
              ),
            );
          },
        ),
        WidgetbookUseCase(
          name: 'Matrix',
          builder: (context) => const SeedStory(component: 'ChipTag', showDescription: false, child: _ChipTagMatrix()),
        ),
      ],
    );

class _ChipTagMatrix extends StatelessWidget {
  const _ChipTagMatrix();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget row(LooviChipTagSize size, LooviChipTagIntent intent,
        {LooviChipTagEmphasis emphasis = LooviChipTagEmphasis.strong, bool disabled = false}) {
      return Padding(
        padding: EdgeInsets.only(bottom: t.spacing.s100),
        child: Row(children: [
          LooviChipTag(label: 'Label', size: size, intent: intent, emphasis: emphasis, disabled: disabled),
          SizedBox(width: t.spacing.s200),
          LooviChipTag(label: 'Label', size: size, intent: intent, emphasis: emphasis, disabled: disabled, showLeadingIcon: true),
          SizedBox(width: t.spacing.s200),
          Expanded(
            child: LooviChipTag(
              label: 'Label',
              size: size,
              intent: intent,
              emphasis: emphasis,
              disabled: disabled,
              width: LooviChipTagWidth.fill,
            ),
          ),
        ]),
      );
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      for (final size in LooviChipTagSize.values) ...[
        for (final intent in LooviChipTagIntent.values) row(size, intent),
        for (final intent in [LooviChipTagIntent.success, LooviChipTagIntent.warning, LooviChipTagIntent.danger])
          row(size, intent, emphasis: LooviChipTagEmphasis.soft),
        row(size, LooviChipTagIntent.system, disabled: true),
      ],
    ]);
  }
}
