// Direct src imports until the wave export lands in lib/loovi_ds.dart.

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// TextHeader (seed node 3667:4129): Playground + Matrix (size x alignment,
/// 6/6; same as the golden `text_header_matrix.png`).
WidgetbookComponent looviTextHeaderComponent() => WidgetbookComponent(
  name: 'TextHeader',
  useCases: [
    WidgetbookUseCase(
      name: 'Playground',
      builder: (context) {
        final k = context.knobs;
        final inverse = k.boolean(label: 'inverse (nested in inverse chrome)');
        final t = LooviTokens.of(context);
        final header = LooviTextHeader(
          title: k.string(label: 'title', initialValue: 'Minha proteção'),
          description: k.string(label: 'description', initialValue: 'Acompanhe seu plano'),
          size: k.object.dropdown<LooviTextHeaderSize>(
            label: 'size',
            options: LooviTextHeaderSize.values,
            labelBuilder: (v) => v.name,
          ),
          alignment: k.object.dropdown<LooviTextHeaderAlignment>(
            label: 'alignment',
            options: LooviTextHeaderAlignment.values,
            labelBuilder: (v) => v.name,
          ),
          showDescription: k.boolean(label: 'showDescription', initialValue: true),
          inverse: inverse,
        );
        return SeedStory(
          component: 'TextHeader',
          child: inverse
              ? ColoredBox(
                  color: t.component.appHeader.inverseBackground,
                  child: Padding(padding: EdgeInsets.all(t.spacing.s200), child: header),
                )
              : header,
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Matrix',
      builder: (context) => const SeedStory(component: 'TextHeader', showDescription: false, child: _Matrix()),
    ),
  ],
);

class _Matrix extends StatelessWidget {
  const _Matrix();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final s in LooviTextHeaderSize.values)
          for (final a in LooviTextHeaderAlignment.values) ...[
            LooviTextHeader(title: 'Minha proteção', description: 'Acompanhe seu plano', size: s, alignment: a),
            SizedBox(height: t.spacing.s200),
          ],
      ],
    );
  }
}
