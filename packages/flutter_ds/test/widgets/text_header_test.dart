import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

/// Story "Matrix": size x alignment (6/6 published). Same as the Widgetbook story.
class TextHeaderMatrix extends StatelessWidget {
  const TextHeaderMatrix({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: Padding(
        padding: EdgeInsets.all(t.spacing.s200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final s in LooviTextHeaderSize.values)
              for (final a in LooviTextHeaderAlignment.values) ...[
                LooviTextHeader(title: 'Minha proteção', description: 'Acompanhe seu plano', size: s, alignment: a),
                SizedBox(height: t.spacing.s200),
              ],
          ],
        ),
      ),
    );
  }
}

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('typography per size; title text/primary, description text/secondary', (tester) async {
    final cases = {
      LooviTextHeaderSize.large: (_t.typography.headingH1Medium, _t.typography.bodyLargeRegular),
      LooviTextHeaderSize.medium: (_t.typography.headingH2Medium, _t.typography.bodyMediumRegular),
      LooviTextHeaderSize.small: (_t.typography.headingH3Medium, _t.typography.bodySmallRegular),
    };
    for (final e in cases.entries) {
      await pumpLoovi(tester, LooviTextHeader(title: 'T', description: 'D', size: e.key));
      final title = tester.widget<Text>(find.text('T')).style!;
      expect(title.fontSize, e.value.$1.fontSize);
      expect(title.fontWeight, e.value.$1.fontWeight);
      expect(title.color, _t.text.primary);
      final desc = tester.widget<Text>(find.text('D')).style!;
      expect(desc.fontSize, e.value.$2.fontSize);
      expect(desc.fontWeight, e.value.$2.fontWeight);
      expect(desc.color, _t.text.secondary);
    }
  });

  testWidgets('gap: spacing/050 (large | medium), spacing/0 (small)', (tester) async {
    await pumpLoovi(tester, const LooviTextHeader(title: 'T', description: 'D'));
    expect(tester.getRect(find.text('D')).top - tester.getRect(find.text('T')).bottom, _t.spacing.s050);
    await pumpLoovi(tester, const LooviTextHeader(title: 'T', description: 'D', size: LooviTextHeaderSize.small));
    expect(tester.getRect(find.text('D')).top - tester.getRect(find.text('T')).bottom, _t.spacing.s0);
  });

  testWidgets('alignment center; showDescription=false; inverse on-color', (tester) async {
    await pumpLoovi(
      tester,
      const LooviTextHeader(title: 'T', description: 'D', alignment: LooviTextHeaderAlignment.center, inverse: true),
    );
    expect(tester.widget<Text>(find.text('T')).textAlign, TextAlign.center);
    expect(tester.widget<Text>(find.text('T')).style!.color, _t.text.onColor);
    expect(tester.widget<Text>(find.text('D')).style!.color, _t.text.onColorDisabled);
    await pumpLoovi(tester, const LooviTextHeader(title: 'T', description: 'D', showDescription: false));
    expect(find.text('D'), findsNothing);
  });

  testWidgets('semantics: title is a heading (level by size)', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const LooviTextHeader(title: 'Minha proteção', size: LooviTextHeaderSize.medium));
    final node = tester.getSemantics(find.text('Minha proteção'));
    expect(node.getSemanticsData().headingLevel, 2);
    expect(tester.getSemantics(find.text('Minha proteção')), isSemantics(label: 'Minha proteção', isHeader: true));
    handle.dispose();
  });

  testWidgets('textScaler 2: wraps without overflow', (tester) async {
    await pumpLoovi(tester, const LooviTextHeader(title: 'Minha proteção veicular completa', description: 'Acompanhe seu plano'), textScale: 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('golden: matrix', (tester) async {
    await pumpGolden(tester, const TextHeaderMatrix(), height: 480);
    await expectLater(find.byType(TextHeaderMatrix), matchesGoldenFile('../goldens/text_header_matrix.png'));
  });
}
