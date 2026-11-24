// Direct src import until the wave export lands in lib/loovi_ds.dart.

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// VehicleSummaryCard (seed node 4581:1451) — Playground + appearance × status.
WidgetbookComponent looviVehicleSummaryCardComponent() => WidgetbookComponent(
      name: 'VehicleSummaryCard',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            final appearance = k.object.dropdown<LooviVehicleSummaryCardAppearance>(
              label: 'appearance',
              options: LooviVehicleSummaryCardAppearance.values,
              labelBuilder: (v) => v == LooviVehicleSummaryCardAppearance.standard ? 'default' : v.name,
            );
            return SeedStory(
              component: 'VehicleSummaryCard',
              child: LooviVehicleSummaryCard(
                appearance: appearance,
                status: k.object.dropdown<LooviVehicleSummaryCardStatus>(
                  label: 'status',
                  options: LooviVehicleSummaryCardStatus.values,
                  labelBuilder: (v) => v.name,
                ),
                brandModel: k.string(label: 'brandModel', initialValue: 'Marca'),
                model: k.string(label: 'model', initialValue: 'Modelo'),
                title: k.string(label: 'title (secondary)', initialValue: 'Marca Modelo • 2020'),
                plate: k.string(label: 'plate', initialValue: 'ABC1D23'),
                illustration: k.object.dropdown<LooviVehicleIllustration>(
                  label: 'illustration',
                  options: LooviVehicleIllustration.values,
                  labelBuilder: (v) => v.name,
                ),
                showStatus: k.boolean(label: 'showStatus', initialValue: true),
                onPressed: k.boolean(label: 'onPressed (default only)') ? () {} : null,
              ),
            );
          },
        ),
        WidgetbookUseCase(
          name: 'Variants',
          builder: (context) => SeedStory(
            component: 'VehicleSummaryCard',
            showDescription: false,
            child: Builder(builder: (context) {
              final t = LooviTokens.of(context);
              final gap = SizedBox(height: t.spacing.s100);
              return Column(
                children: [
                  const LooviVehicleSummaryCard(plate: 'ABC1D23'),
                  gap,
                  const LooviVehicleSummaryCard(status: LooviVehicleSummaryCardStatus.inactive, plate: 'ABC1D23', illustration: LooviVehicleIllustration.van),
                  gap,
                  const LooviVehicleSummaryCard(showStatus: false, plate: 'ABC1D23', illustration: LooviVehicleIllustration.suv),
                  gap,
                  const LooviVehicleSummaryCard(
                    appearance: LooviVehicleSummaryCardAppearance.secondary,
                    title: 'Marca Modelo • 2020',
                    plate: 'ABC1D23',
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
