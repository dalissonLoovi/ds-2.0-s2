// Direct src import until the wave export lands in lib/loovi_ds.dart.

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// OfferProductCard (seed node 4227:418) — Playground + carousel sample.
WidgetbookComponent looviOfferProductCardComponent() => WidgetbookComponent(
      name: 'OfferProductCard',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            return SeedStory(
              component: 'OfferProductCard',
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  // Carousel-owned width (Figma demo 232) — screen pattern, not the card.
                  width: k.double.slider(label: 'width (carousel)', initialValue: 232, min: 160, max: 342),
                  child: LooviOfferProductCard(
                    title: k.string(label: 'title', initialValue: 'Title'),
                    description: k.string(label: 'description', initialValue: 'Description'),
                    price: k.string(label: 'price', initialValue: 'R\$ 0,00'),
                    pricePeriod: k.string(label: 'pricePeriod', initialValue: '/mês'),
                    icon: k.object.dropdown<String>(
                      label: 'icon',
                      options: LooviIcons.all.where((n) => n.endsWith('-outline')).toList(),
                      initialOption: LooviIcons.packageOutline,
                    ),
                    ctaLabel: k.string(label: 'cta label', initialValue: 'Label'),
                    onCtaPressed: () {},
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
