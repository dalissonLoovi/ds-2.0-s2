// Direct src import until the wave export lands in lib/loovi_ds.dart.
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// ListActionDropdown (seed node 3694:1501) — panel playground + anchored
/// menu opened from a row trigger.
WidgetbookComponent looviListActionDropdownComponent() => WidgetbookComponent(
      name: 'ListActionDropdown',
      useCases: [
        WidgetbookUseCase(name: 'Playground', builder: _playground),
        WidgetbookUseCase(name: 'Anchored menu', builder: (_) => const _AnchoredMenu()),
      ],
    );

List<List<Widget>> _groups(VoidCallback? onSelect) => [
      [
        LooviListActionDropdownItem(label: 'Editar apelido', onSelect: onSelect),
        LooviListActionDropdownItem(label: 'Adicionar motorista', icon: LooviIcons.plusOutline, onSelect: onSelect),
      ],
      [
        LooviListActionDropdownItem(label: 'Ver documentos', icon: LooviIcons.fileTextOutline, onSelect: onSelect),
      ],
    ];

Widget _playground(BuildContext context) {
  final k = context.knobs;
  final showDivider = k.boolean(label: 'showDivider', initialValue: true);
  final showScroll = k.boolean(label: 'showScroll');
  return SeedStory(
    component: 'ListActionDropdown',
    child: Align(
      alignment: Alignment.centerLeft,
      child: IntrinsicWidth(
        child: LooviListActionDropdown.grouped(
          showDivider: showDivider,
          showScroll: showScroll,
          semanticLabel: 'Ações do veículo',
          groups: _groups(() {}),
        ),
      ),
    ),
  );
}

class _AnchoredMenu extends StatelessWidget {
  const _AnchoredMenu();

  @override
  Widget build(BuildContext context) {
    return SeedStory(
      component: 'ListActionDropdown',
      child: Builder(
        builder: (triggerContext) => LooviListItem(
          condition: LooviListItemCondition.twoLine,
          headline: 'Onix 2022',
          supportingText: 'Placa ABC1D23',
          leadingIcon: LooviIcons.carOutline,
          trailingIcon: LooviIcons.dotsVerticalOutline,
          semanticLabel: 'Onix 2022, placa ABC1D23, abrir ações',
          onTap: () => showLooviListActionDropdown<void>(
            context: triggerContext,
            builder: (menuContext) => LooviListActionDropdown.grouped(
              semanticLabel: 'Ações do veículo',
              groups: _groups(() => Navigator.pop(menuContext)),
            ),
          ),
        ),
      ),
    );
  }
}
