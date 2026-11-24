// Direct src import until the wave export lands in lib/loovi_ds.dart.
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// ListItemStateLayer (seed node 3720:28) — internal layer behind ListItem.
WidgetbookComponent looviListItemStateLayerComponent() => WidgetbookComponent(
      name: 'ListItemStateLayer',
      useCases: [
        WidgetbookUseCase(name: 'Playground', builder: _playground),
        WidgetbookUseCase(name: 'States', builder: (_) => const _States()),
      ],
    );

String _label(LooviListItemStateLayerState s) => s == LooviListItemStateLayerState.standard ? 'default' : s.name;

Widget _layer(BuildContext context, LooviListItemStateLayerState s) {
  final t = LooviTokens.of(context);
  return SizedBox(
    height: t.spacing.s700,
    child: Stack(
      children: [
        Positioned.fill(child: LooviListItemStateLayer(state: s)),
        Center(child: Text(_label(s), style: t.typography.bodyMediumRegular.copyWith(color: t.text.primary))),
      ],
    ),
  );
}

Widget _playground(BuildContext context) {
  final state = context.knobs.object.dropdown<LooviListItemStateLayerState>(
    label: 'state',
    options: LooviListItemStateLayerState.values,
    labelBuilder: _label,
  );
  return SeedStory(component: 'ListItemStateLayer', child: _layer(context, state));
}

class _States extends StatelessWidget {
  const _States();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return SeedStory(
      component: 'ListItemStateLayer',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final s in LooviListItemStateLayerState.values) ...[
            _layer(context, s),
            SizedBox(height: t.spacing.s200),
          ],
        ],
      ),
    );
  }
}
