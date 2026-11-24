import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// ChipGroup — Figma 3667:2570 (mode app-cliente). Chips = ChipClickable outline / sm / hug.
WidgetbookComponent looviChipGroupComponent() => WidgetbookComponent(
      name: 'ChipGroup',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) => SeedStory(
            component: 'ChipGroup',
            child: _InteractiveGroup(
              type: context.knobs.object.dropdown<LooviChipGroupType>(
                label: 'type',
                options: LooviChipGroupType.values,
                labelBuilder: (v) => v.name,
              ),
              layout: context.knobs.object.dropdown<LooviChipGroupLayout>(
                label: 'layout',
                options: LooviChipGroupLayout.values,
                labelBuilder: (v) => v == LooviChipGroupLayout.singleRowScrollable ? 'single-row-scrollable' : 'multi-row-wrap',
              ),
            ),
          ),
        ),
      ],
    );

class _InteractiveGroup extends StatefulWidget {
  const _InteractiveGroup({required this.type, required this.layout});

  final LooviChipGroupType type;
  final LooviChipGroupLayout layout;

  @override
  State<_InteractiveGroup> createState() => _InteractiveGroupState();
}

class _InteractiveGroupState extends State<_InteractiveGroup> {
  final _labels = ['Todos', 'Pix', 'Boleto', 'Cartão', 'Em aberto', 'Pagos', 'Vencidos', 'Agendados', 'Cancelados'];
  final Set<String> _selected = {'Todos'};

  @override
  Widget build(BuildContext context) {
    final filter = widget.type == LooviChipGroupType.filter;
    final input = widget.type == LooviChipGroupType.input;
    return LooviChipGroup(
      type: widget.type,
      layout: widget.layout,
      semanticLabel: filter ? 'Filtros' : 'Opções',
      entries: [
        for (final l in _labels)
          LooviChipGroupEntry(
            label: l,
            selected: filter && _selected.contains(l),
            onPressed: () => setState(() {
              if (filter && !_selected.remove(l)) _selected.add(l);
            }),
            onDelete: input ? () => setState(() => _labels.remove(l)) : null,
          ),
      ],
    );
  }
}
