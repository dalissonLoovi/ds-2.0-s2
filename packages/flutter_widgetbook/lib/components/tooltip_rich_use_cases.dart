import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

const _title = 'Cobertura para terceiros';
const _desc = 'Cobre danos que seu carro causar a outros veículos.';

/// TooltipRich (seed node 3566:10477): Interactive (tap the icon) + Variants
/// (static surfaces).
WidgetbookComponent looviTooltipRichComponent() => WidgetbookComponent(
  name: 'TooltipRich',
  useCases: [
    WidgetbookUseCase(
      name: 'Interactive',
      builder: (context) {
        final k = context.knobs;
        final t = LooviTokens.of(context);
        final placement = k.object.dropdown<LooviTooltipRichPlacement>(
          label: 'placement (arrow edge)',
          options: LooviTooltipPlacement.values,
          initialOption: LooviTooltipPlacement.bottomCenter,
          labelBuilder: (v) => v.name,
        );
        return SeedStory(
          component: 'TooltipRich',
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: t.spacing.s1200 * 2),
            child: Align(
              alignment: switch (placement.arrowAlign) {
                -1 => Alignment.centerLeft,
                1 => Alignment.centerRight,
                _ => Alignment.center,
              },
              child: LooviTooltipRich(
                placement: placement,
                title: k.string(label: 'title', initialValue: _title),
                showTitle: k.boolean(label: 'showTitle', initialValue: true),
                description: k.string(label: 'description', initialValue: _desc),
                showDescription: k.boolean(label: 'showDescription', initialValue: true),
                showActions: k.boolean(label: 'showActions', initialValue: true),
                showPrimaryAction: k.boolean(label: 'showPrimaryAction', initialValue: true),
                showSecondaryAction: k.boolean(label: 'showSecondaryAction', initialValue: true),
                primaryActionLabel: k.string(label: 'primaryActionLabel', initialValue: 'Ver mais'),
                secondaryActionLabel: k.string(label: 'secondaryActionLabel', initialValue: 'Fechar'),
                onPrimaryAction: () {},
                onSecondaryAction: () {},
                child: LooviTapTarget(
                  child: LooviIcon(LooviIcons.infoCircleOutline, size: t.spacing.s300, semanticLabel: 'Ajuda'),
                ),
              ),
            ),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Variants',
      builder: (context) => const SeedStory(component: 'TooltipRich', showDescription: false, child: _Variants()),
    ),
  ],
);

/// Full, no actions, primary only. Same as the golden
/// `tooltip_rich_variants.png`.
class _Variants extends StatelessWidget {
  const _Variants();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LooviTooltipRich(
          title: _title,
          description: _desc,
          primaryActionLabel: 'Ver mais',
          secondaryActionLabel: 'Fechar',
          onPrimaryAction: () {},
          onSecondaryAction: () {},
        ),
        SizedBox(height: t.spacing.s300),
        const LooviTooltipRich(
          placement: LooviTooltipPlacement.bottomLeft,
          title: _title,
          description: _desc,
          showActions: false,
        ),
        SizedBox(height: t.spacing.s300),
        LooviTooltipRich(
          placement: LooviTooltipPlacement.topRight,
          showTitle: false,
          description: _desc,
          showSecondaryAction: false,
          primaryActionLabel: 'Entendi',
          onPrimaryAction: () {},
        ),
      ],
    );
  }
}
