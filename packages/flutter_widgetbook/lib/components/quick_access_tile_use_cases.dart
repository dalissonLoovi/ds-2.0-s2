// Direct src import until the wave export lands in lib/loovi_ds.dart.

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// QuickAccessTile (seed node 4203:447) — Playground + "Acesso rápido" grid.
WidgetbookComponent looviQuickAccessTileComponent() => WidgetbookComponent(
      name: 'QuickAccessTile',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            return SeedStory(
              component: 'QuickAccessTile',
              child: Align(
                alignment: Alignment.centerLeft,
                child: LooviQuickAccessTile(
                  label: k.string(label: 'label', initialValue: 'Label'),
                  icon: k.object.dropdown<String>(
                    label: 'icon',
                    options: LooviIcons.all.where((n) => n.endsWith('-outline')).toList(),
                    initialOption: LooviIcons.appsOutline,
                  ),
                  disabled: k.boolean(label: 'state=disabled'),
                  onPressed: () {},
                ),
              ),
            );
          },
        ),
        WidgetbookUseCase(
          name: 'States',
          builder: (context) => SeedStory(
            component: 'QuickAccessTile',
            showDescription: false,
            child: Builder(builder: (context) {
              final t = LooviTokens.of(context);
              // "Acesso rápido" is a screen composition of N tiles (not a component).
              return Wrap(
                spacing: t.spacing.s200,
                runSpacing: t.spacing.s200,
                children: [
                  LooviQuickAccessTile(label: 'Label', onPressed: () {}),
                  LooviQuickAccessTile(label: 'Pagar fatura', icon: LooviIcons.walletOutline, onPressed: () {}),
                  LooviQuickAccessTile(label: 'Assistência', icon: LooviIcons.headsetOutline, onPressed: () {}),
                  LooviQuickAccessTile(label: 'Meu plano', icon: LooviIcons.shieldOutline, disabled: true, onPressed: () {}),
                ],
              );
            }),
          ),
        ),
      ],
    );
