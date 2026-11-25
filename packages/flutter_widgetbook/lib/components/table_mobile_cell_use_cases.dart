// Direct src imports until the wave export lands in lib/loovi_ds.dart.

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

const _tag = LooviChipTag(label: 'Pago', size: LooviChipTagSize.sm, intent: LooviChipTagIntent.success);

/// TableMobileCell (seed node 3452:2656): Playground + types × states.
WidgetbookComponent looviTableMobileCellComponent() => WidgetbookComponent(
  name: 'TableMobileCell',
  useCases: [
    WidgetbookUseCase(
      name: 'Playground',
      builder: (context) {
        final k = context.knobs;
        final type = k.object.dropdown<LooviTableMobileCellType>(
          label: 'type',
          options: LooviTableMobileCellType.values,
          initialOption: LooviTableMobileCellType.action,
          labelBuilder: (v) => v.name,
        );
        final state = k.object.dropdown<LooviTableMobileCellState>(
          label: 'state',
          options: LooviTableMobileCellState.values,
          initialOption: LooviTableMobileCellState.standard,
          labelBuilder: (v) => v.name,
        );
        final label = k.string(label: 'label', initialValue: type == LooviTableMobileCellType.action ? 'Sobre o valor' : 'Name of cell');
        final tooltip = k.string(label: 'tooltip (action)', initialValue: 'Valor com desconto no Pix.');
        return SeedStory(
          component: 'TableMobileCell',
          child: Align(
            alignment: Alignment.centerLeft,
            child: LooviTableMobileCell(
              type: type,
              state: state,
              label: label,
              tooltip: type == LooviTableMobileCellType.action && tooltip.isNotEmpty ? tooltip : null,
              onPressed: () {},
              child: type == LooviTableMobileCellType.tag ? _tag : null,
            ),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Types × states',
      builder: (context) => SeedStory(
        component: 'TableMobileCell',
        showDescription: false,
        child: Column(
          children: [
            for (final state in LooviTableMobileCellState.values)
              Row(
                children: [
                  Expanded(
                    child: LooviTableMobileCell(label: 'Name of cell', state: state),
                  ),
                  Expanded(
                    child: LooviTableMobileCell(type: LooviTableMobileCellType.secondary, label: 'Name of cell', state: state),
                  ),
                  Expanded(
                    child: LooviTableMobileCell(type: LooviTableMobileCellType.tag, state: state, child: _tag),
                  ),
                  LooviTableMobileCell(
                    type: LooviTableMobileCellType.action,
                    label: 'Sobre o valor',
                    tooltip: 'Valor com desconto no Pix.',
                    state: state,
                  ),
                  LooviTableMobileCell(type: LooviTableMobileCellType.icon, label: 'Adicionar', state: state, onPressed: () {}),
                ],
              ),
          ],
        ),
      ),
    ),
  ],
);
