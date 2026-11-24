// Direct src import until the wave export lands in lib/loovi_ds.dart.

import 'package:loovi_ds/loovi_ds.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// VehicleConfirmCard (seed node 4360:444) — Playground.
WidgetbookComponent looviVehicleConfirmCardComponent() => WidgetbookComponent(
      name: 'VehicleConfirmCard',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            return SeedStory(
              component: 'VehicleConfirmCard',
              child: LooviVehicleConfirmCard(
                plate: k.string(label: 'plate', initialValue: 'ABC1D23'),
                brandModel: k.string(label: 'brandModel', initialValue: 'Brand Model'),
              ),
            );
          },
        ),
      ],
    );
