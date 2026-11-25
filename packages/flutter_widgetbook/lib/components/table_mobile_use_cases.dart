// Direct src imports until the wave export lands in lib/loovi_ds.dart.

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

const _values = ['Fatura', 'Mar/26', 'R\$ 89,90', 'Venc. 10/03', 'Pix', 'Cartão final 1234'];
const _headers = ['Tipo', 'Mês', 'Valor', 'Vencimento', 'Forma', 'Conta'];
const _tag = LooviChipTag(label: 'Pago', size: LooviChipTagSize.sm, intent: LooviChipTagIntent.success);

/// TableMobile (seed node 3452:2722): Playground + Default (same as the
/// golden `table_mobile.png`). Tap the chevron to expand the detail row.
WidgetbookComponent looviTableMobileComponent() => WidgetbookComponent(
  name: 'TableMobile',
  useCases: [
    WidgetbookUseCase(
      name: 'Playground',
      builder: (context) {
        final k = context.knobs;
        final columnCount = k.int.slider(label: 'columnCount (values + tag)', initialValue: 6, min: 2, max: 6);
        final showTag = k.boolean(label: 'showTag', initialValue: true);
        final interactive = k.boolean(label: 'interactive (initially expanded)', initialValue: true);
        final withAction = k.boolean(label: 'plus-outline action', initialValue: true);
        final rowTap = k.boolean(label: 'row onTap (pressed state)', initialValue: true);
        final n = columnCount - (showTag ? 1 : 0);
        return SeedStory(
          component: 'TableMobile',
          child: LooviTableMobile(
            key: ValueKey('$columnCount$showTag$interactive'),
            values: _values.take(n).toList(),
            headers: _headers.take(n).toList(),
            tag: showTag ? _tag : null,
            initiallyExpanded: interactive,
            onAction: withAction ? () {} : null,
            onTap: rowTap ? () {} : null,
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => const SeedStory(
        component: 'TableMobile',
        showDescription: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LooviTableMobile(values: ['Placa', 'ABC1D23']),
            LooviTableMobile(values: ['Plano', 'Mensal'], tag: _tag),
            LooviTableMobile(values: ['Fatura', 'Mar/26', 'R\$ 89', 'Venc. 10/03', 'Pix'], tag: _tag),
            LooviTableMobile(values: ['Fatura', 'Fev/26', 'R\$ 89', 'Venc. 10/02', 'Pix'], tag: _tag, initiallyExpanded: true),
            LooviTableMobile(values: ['Fatura', 'Jan/26', 'R\$ 89', 'Venc. 10/01', 'Boleto', 'Pago'], initiallyExpanded: true),
          ],
        ),
      ),
    ),
  ],
);
