import 'package:loovi_ds/loovi_ds.dart';
// ignore: implementation_imports — direct import until loovi_ds.dart exports the widget.
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// Badge (seed node 3669:8175): Playground + Content (standalone and attached).
WidgetbookComponent looviBadgeComponent() => WidgetbookComponent(
  name: 'Badge',
  useCases: [
    WidgetbookUseCase(
      name: 'Playground',
      builder: (context) {
        final k = context.knobs;
        final content = k.object.dropdown<LooviBadgeContent>(
          label: 'content',
          options: LooviBadgeContent.values,
          initialOption: LooviBadgeContent.count,
          labelBuilder: (v) => v.name,
        );
        return SeedStory(
          component: 'Badge',
          child: Align(
            alignment: Alignment.centerLeft,
            child: LooviBadge(
              // Figma: sm only with dot; lg with count | overflow.
              size: content == LooviBadgeContent.dot ? LooviBadgeSize.sm : LooviBadgeSize.lg,
              content: content,
              count: k.int.slider(label: 'count', initialValue: 3, min: 1, max: 99),
              overflowLabel: k.string(label: 'overflowLabel', initialValue: '999+'),
              decorative: k.boolean(label: 'decorative'),
            ),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Content',
      builder: (context) => const SeedStory(component: 'Badge', showDescription: false, child: _BadgeContent()),
    ),
  ],
);

/// dot · count · overflow, standalone and on a bell icon. Same as the golden
/// `badge_matrix.png`.
class _BadgeContent extends StatelessWidget {
  const _BadgeContent();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    const badges = [LooviBadge(), LooviBadge.count(3), LooviBadge.count(42), LooviBadge.overflow()];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (final b in badges) ...[b, SizedBox(width: t.spacing.s300)],
          ],
        ),
        SizedBox(height: t.spacing.s300),
        Row(
          children: [
            for (final b in badges) ...[
              SizedBox.square(
                dimension: t.spacing.s500,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Center(child: LooviIcon(LooviIcons.bellOutline, size: t.spacing.s300)),
                    PositionedDirectional(top: t.spacing.s050, start: t.spacing.s250, child: b),
                  ],
                ),
              ),
              SizedBox(width: t.spacing.s300),
            ],
          ],
        ),
      ],
    );
  }
}
