// Direct src imports until the wave export lands in lib/loovi_ds.dart.

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// FeatureStepsItem (seed node 4343:222): Playground + Variants (same as the
/// golden `feature_steps_item_variants.png`).
WidgetbookComponent looviFeatureStepsItemComponent() => WidgetbookComponent(
  name: 'FeatureStepsItem',
  useCases: [
    WidgetbookUseCase(
      name: 'Playground',
      builder: (context) {
        final k = context.knobs;
        return SeedStory(
          component: 'FeatureStepsItem',
          child: LooviFeatureStepsItem(
            leadingIcon: k.object.dropdown<String>(
              label: 'leadingIcon',
              options: LooviIcons.all.toList(),
              initialOption: LooviIcons.squareCheckOutline,
            ),
            headline: k.string(label: 'headline', initialValue: 'Label'),
            supportingText: k.string(label: 'supportingText', initialValue: 'Description'),
            showSupportingText: k.boolean(label: 'showSupportingText', initialValue: true),
            showConnector: k.boolean(label: 'showConnector', initialValue: true),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Variants',
      builder: (context) => const SeedStory(component: 'FeatureStepsItem', showDescription: false, child: _ItemVariants()),
    ),
  ],
);

class _ItemVariants extends StatelessWidget {
  const _ItemVariants();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const LooviFeatureStepsItem(),
        SizedBox(height: t.spacing.s300),
        const LooviFeatureStepsItem(leadingIcon: LooviIcons.carOutline, showSupportingText: false),
        SizedBox(height: t.spacing.s300),
        const LooviFeatureStepsItem(showConnector: false),
      ],
    );
  }
}
