// Direct src import until the wave export lands in lib/loovi_ds.dart.
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// ListActionDropdownItem (seed node 3681:11151) — Playground + states.
WidgetbookComponent looviListActionDropdownItemComponent() => WidgetbookComponent(
      name: 'ListActionDropdownItem',
      useCases: [
        WidgetbookUseCase(name: 'Playground', builder: _playground),
        WidgetbookUseCase(name: 'States', builder: (_) => const _States()),
      ],
    );

const _icons = [
  LooviIcons.editOutline,
  LooviIcons.plusOutline,
  LooviIcons.fileTextOutline,
  LooviIcons.uploadOutline,
  LooviIcons.xOutline,
];

Widget _playground(BuildContext context) {
  final k = context.knobs;
  return SeedStory(
    component: 'ListActionDropdownItem',
    child: LooviListActionDropdownItem(
      label: k.string(label: 'label', initialValue: 'Editar'),
      showIcon: k.boolean(label: 'showIcon', initialValue: true),
      icon: k.object.dropdown<String>(label: 'icon', options: _icons, labelBuilder: (v) => v),
      selected: k.boolean(label: 'selected'),
      disabled: k.boolean(label: 'disabled'),
      onSelect: () {},
    ),
  );
}

class _States extends StatelessWidget {
  const _States();

  @override
  Widget build(BuildContext context) {
    return SeedStory(
      component: 'ListActionDropdownItem',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LooviListActionDropdownItem(label: 'Editar (default)', onSelect: () {}),
          LooviListActionDropdownItem(label: 'Selecionado', icon: LooviIcons.checkOutline, selected: true, onSelect: () {}),
          LooviListActionDropdownItem(label: 'Indisponível', icon: LooviIcons.uploadOutline, disabled: true, onSelect: () {}),
          LooviListActionDropdownItem(label: 'Sem ícone', showIcon: false, onSelect: () {}),
        ],
      ),
    );
  }
}
