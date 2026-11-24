// Direct src import until the wave export lands in lib/loovi_ds.dart.

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// DashboardCardSecondary (seed node 4181:528) — Playground + type × growth.
WidgetbookComponent looviDashboardCardSecondaryComponent() => WidgetbookComponent(
      name: 'DashboardCardSecondary',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            final type = k.object.dropdown<LooviDashboardCardSecondaryType>(
              label: 'type',
              options: LooviDashboardCardSecondaryType.values,
              labelBuilder: (v) => v.name,
            );
            return SeedStory(
              component: 'DashboardCardSecondary',
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  // Figma demo widths (web 210 / mobile 116); the screen sets it.
                  width: type == LooviDashboardCardSecondaryType.web ? 210 : 116,
                  child: LooviDashboardCardSecondary(
                    type: type,
                    growth: k.object.dropdown<LooviDashboardCardSecondaryGrowth>(
                      label: 'growth',
                      options: LooviDashboardCardSecondaryGrowth.values,
                      labelBuilder: (v) => v.name,
                    ),
                    icon: k.object.dropdown<String>(
                      label: 'icon (web)',
                      options: const [LooviIcons.fileDescriptionOutline, LooviIcons.walletOutline, LooviIcons.carOutline],
                    ),
                    showIcon: k.boolean(label: 'showIcon (web)', initialValue: true),
                    title: k.string(label: 'title', initialValue: 'Title'),
                    value: k.string(label: 'value', initialValue: '25'),
                    showInfo: k.boolean(label: 'showInfo', initialValue: true),
                    showDescription: k.boolean(label: 'showDescription', initialValue: true),
                    percentage: k.string(label: 'percentage', initialValue: '100%'),
                    percentageDescription: k.string(label: 'percentageDescription', initialValue: '12 no mês anterior'),
                    onInfoPressed: k.boolean(label: 'onInfoPressed') ? () {} : null,
                  ),
                ),
              ),
            );
          },
        ),
        WidgetbookUseCase(
          name: 'Variants',
          builder: (context) => SeedStory(
            component: 'DashboardCardSecondary',
            showDescription: false,
            child: Builder(builder: (context) {
              final t = LooviTokens.of(context);
              return Wrap(
                spacing: t.spacing.s200,
                runSpacing: t.spacing.s200,
                children: [
                  for (final g in LooviDashboardCardSecondaryGrowth.values)
                    SizedBox(width: 210, child: LooviDashboardCardSecondary(growth: g)),
                  for (final g in LooviDashboardCardSecondaryGrowth.values)
                    SizedBox(
                      width: 116,
                      child: LooviDashboardCardSecondary(type: LooviDashboardCardSecondaryType.mobile, growth: g),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
