import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

/// Story "Default": the Figma default (3 rows) plus one error row.
class FileUploaderListDefault extends StatelessWidget {
  const FileUploaderListDefault({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: Padding(
        padding: EdgeInsets.all(t.spacing.s200),
        child: LooviFileUploaderList(children: [
          LooviFileUploaderItem(fileName: 'cnh-frente.png', onRemove: () {}),
          LooviFileUploaderItem(fileName: 'cnh-verso.png', onRemove: () {}),
          LooviFileUploaderItem(fileName: 'comprovante.pdf', state: LooviFileUploaderItemState.success, onRemove: () {}),
          LooviFileUploaderItem(
            fileName: 'documento.heic',
            state: LooviFileUploaderItemState.dangerShort,
            shortDescription: 'Formato não suportado.',
            onRemove: () {},
          ),
        ]),
      ),
    );
  }
}

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('stacks children with spacing/100 gaps', (tester) async {
    await pumpLoovi(
      tester,
      const LooviFileUploaderList(children: [
        LooviFileUploaderItem(fileName: 'a.png'),
        LooviFileUploaderItem(fileName: 'b.png'),
      ]),
    );
    final a = tester.getRect(find.widgetWithText(LooviFileUploaderItem, 'a.png'));
    final b = tester.getRect(find.widgetWithText(LooviFileUploaderItem, 'b.png'));
    expect(b.top - a.bottom, _t.spacing.s100);
  });

  testWidgets('semantics: named group keeps each row', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(
      tester,
      const LooviFileUploaderList(semanticLabel: 'Documentos', children: [LooviFileUploaderItem(fileName: 'a.png')]),
    );
    expect(find.bySemanticsLabel('Documentos'), findsOneWidget);
    expect(find.bySemanticsLabel('a.png'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('golden: default', (tester) async {
    await pumpGolden(tester, const FileUploaderListDefault(), height: 300);
    await expectLater(find.byType(FileUploaderListDefault), matchesGoldenFile('../goldens/file_uploader_list_default.png'));
  });
}
