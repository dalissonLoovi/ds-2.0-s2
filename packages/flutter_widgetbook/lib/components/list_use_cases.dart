// Direct src import until the wave export lands in lib/loovi_ds.dart.

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

WidgetbookComponent looviListComponent() => WidgetbookComponent(
      name: 'List',
      useCases: [
        WidgetbookUseCase(name: 'Playground', builder: _playground),
        WidgetbookUseCase(name: 'Variants', builder: (_) => const _Variants()),
      ],
    );

List<Widget> _rows() => [
      LooviListItem(condition: LooviListItemCondition.twoLine, headline: 'Meu veículo', supportingText: 'Onix 2022 · ABC1D23', leading: const LooviListItemMonogram('O'), trailingIcon: LooviIcons.chevronRightOutline, showDivider: true, onTap: () {}),
      LooviListItem(condition: LooviListItemCondition.twoLine, headline: 'Coberturas do plano', supportingText: 'Veja o que está incluído no seu plano', leadingIcon: LooviIcons.shieldCheckOutline, trailingIcon: LooviIcons.chevronRightOutline, showDivider: true, onTap: () {}),
      LooviListItem(condition: LooviListItemCondition.twoLine, headline: 'Pagamentos', supportingText: 'Próxima fatura em 10/12', leadingIcon: LooviIcons.walletOutline, trailingIcon: LooviIcons.chevronRightOutline, onTap: () {}),
    ];

Widget _playground(BuildContext context) {
  final type = context.knobs.object.dropdown<LooviListType>(
    label: 'type',
    options: LooviListType.values,
    initialOption: LooviListType.dropdown,
    labelBuilder: (v) => v.name,
  );
  final showScroll = context.knobs.boolean(label: 'showScroll');
  return SeedStory(component: 'List', child: LooviList(type: type, showScroll: showScroll, children: _rows()));
}

class _Variants extends StatelessWidget {
  const _Variants();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return SeedStory(
      component: 'List',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('type=dropdown', style: t.typography.bodySmallMedium.copyWith(color: t.text.secondary)),
          SizedBox(height: t.spacing.s100),
          LooviList(children: _rows()),
          SizedBox(height: t.spacing.s400),
          Text('type=plain · showScroll', style: t.typography.bodySmallMedium.copyWith(color: t.text.secondary)),
          SizedBox(height: t.spacing.s100),
          LooviList(type: LooviListType.plain, showScroll: true, children: _rows()),
        ],
      ),
    );
  }
}
