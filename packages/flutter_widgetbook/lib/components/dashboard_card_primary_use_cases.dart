// Direct src import until the wave export lands in lib/loovi_ds.dart.

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// DashboardCardPrimary (seed node 4181:493) — Playground + type.
WidgetbookComponent looviDashboardCardPrimaryComponent() => WidgetbookComponent(
      name: 'DashboardCardPrimary',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            return SeedStory(
              component: 'DashboardCardPrimary',
              child: Align(
                alignment: Alignment.centerLeft,
                child: LooviDashboardCardPrimary(
                  type: k.object.dropdown<LooviDashboardCardPrimaryType>(
                    label: 'type',
                    options: LooviDashboardCardPrimaryType.values,
                    labelBuilder: (v) => v.name,
                  ),
                  title: k.string(label: 'title', initialValue: 'Title'),
                  primaryValue: k.string(label: 'primaryValue', initialValue: '6.838'),
                  label1: k.string(label: 'label1', initialValue: 'Label'),
                  description1: k.string(label: 'description1', initialValue: '123'),
                  label2: k.string(label: 'label2', initialValue: 'Label'),
                  description2: k.string(label: 'description2', initialValue: '123'),
                  showInfo: k.boolean(label: 'showInfo (web)', initialValue: true),
                  chartValue: k.double.slider(
                    label: 'chartValue (not in seed)',
                    initialValue: LooviDashboardCardPrimary.defaultChartValue,
                    min: 0,
                    max: 1,
                  ),
                  onInfoPressed: k.boolean(label: 'onInfoPressed') ? () {} : null,
                ),
              ),
            );
          },
        ),
        WidgetbookUseCase(
          name: 'Variants',
          builder: (context) => SeedStory(
            component: 'DashboardCardPrimary',
            showDescription: false,
            child: Builder(builder: (context) {
              final t = LooviTokens.of(context);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LooviDashboardCardPrimary(),
                  SizedBox(height: t.spacing.s200),
                  const LooviDashboardCardPrimary(type: LooviDashboardCardPrimaryType.mobile),
                ],
              );
            }),
          ),
        ),
      ],
    );
