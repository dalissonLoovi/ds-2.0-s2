import 'package:loovi_ds/loovi_ds.dart';
// Direct import until loovi_ds.dart exports the widget.
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// SectionHeader (seed node 4235:406) — Playground + Variants (emphasis × showAction, 4/4).
WidgetbookComponent looviSectionHeaderComponent() => WidgetbookComponent(
      name: 'SectionHeader',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            return SeedStory(
              component: 'SectionHeader',
              child: LooviSectionHeader(
                title: k.string(label: 'title', initialValue: 'Coberturas'),
                emphasis: k.object.dropdown<LooviSectionHeaderEmphasis>(
                  label: 'emphasis',
                  options: LooviSectionHeaderEmphasis.values,
                  labelBuilder: (v) => v.name,
                ),
                showAction: k.boolean(label: 'showAction', initialValue: true),
                actionIcon: k.object.dropdown<String>(
                  label: 'action icon',
                  options: LooviIcons.all.toList(),
                  initialOption: LooviIcons.arrowNarrowRightOutline,
                ),
                actionLabel: k.string(label: 'action accessible label', initialValue: 'Ver mais'),
                onActionPressed: () {},
              ),
            );
          },
        ),
        WidgetbookUseCase(
          name: 'Variants',
          builder: (context) => const SeedStory(component: 'SectionHeader', showDescription: false, child: _SectionHeaderVariants()),
        ),
      ],
    );

/// emphasis × showAction. Same layout as the golden `section_header_variants.png`.
class _SectionHeaderVariants extends StatelessWidget {
  const _SectionHeaderVariants();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final e in LooviSectionHeaderEmphasis.values)
          for (final action in [false, true]) ...[
            LooviSectionHeader(
              title: e == LooviSectionHeaderEmphasis.primary ? 'Coberturas' : 'Ofertas para você',
              emphasis: e,
              showAction: action,
              onActionPressed: () {},
            ),
            SizedBox(height: t.spacing.s300),
          ],
      ],
    );
  }
}
