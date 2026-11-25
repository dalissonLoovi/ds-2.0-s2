import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

const _files = [
  LooviFileUploaderFile(fileName: 'cnh-frente.png', id: 1),
  LooviFileUploaderFile(fileName: 'cnh-verso.png', id: 2),
  LooviFileUploaderFile(fileName: 'comprovante.pdf', id: 3),
];

/// Story "Matrix": variant × state at size=lg, then sizes md / sm.
class FileUploaderMatrix extends StatelessWidget {
  const FileUploaderMatrix({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget uploader(LooviFileUploaderVariant v, LooviFileUploaderState s, {LooviFileUploaderSize size = LooviFileUploaderSize.lg}) =>
        Padding(
          padding: EdgeInsets.only(bottom: t.spacing.s200),
          child: LooviFileUploader(
            label: 'Enviar arquivos',
            description: 'Tamanho máximo de 500 KB. Formatos .jpg e .png.',
            variant: v,
            state: s,
            size: size,
            files: _files,
            onPick: () {},
            onRemove: (_) {},
          ),
        );
    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        for (final v in LooviFileUploaderVariant.values)
          for (final s in LooviFileUploaderState.values) uploader(v, s),
        uploader(LooviFileUploaderVariant.standard, LooviFileUploaderState.standard, size: LooviFileUploaderSize.sm),
      ]),
    );
  }
}

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('header: label body/medium/semi-bold text/primary, description body/small/regular text/secondary', (tester) async {
    await pumpLoovi(tester, LooviFileUploader(label: 'Label', description: 'Desc', onPick: () {}));
    final label = tester.widget<Text>(find.text('Label'));
    expect(label.style!.color, _t.text.primary);
    expect(label.style!.fontWeight, _t.typography.bodyMediumSemiBold.fontWeight);
    final desc = tester.widget<Text>(find.text('Desc'));
    expect(desc.style!.color, _t.text.secondary);
    expect(desc.style!.fontSize, _t.typography.bodySmallRegular.fontSize);
    // root padding spacing/200 × spacing/100
    final root = tester.getRect(find.byType(LooviFileUploader));
    expect(tester.getRect(find.text('Label')).left - root.left, _t.spacing.s200);
    expect(tester.getRect(find.text('Label')).top - root.top, _t.spacing.s100);
  });

  testWidgets('variant=default: solid primary Button, size 1:1, upload-outline; onPick on tap', (tester) async {
    var picks = 0;
    for (final e in {
      LooviFileUploaderSize.lg: LooviButtonSize.lg,
      LooviFileUploaderSize.md: LooviButtonSize.md,
      LooviFileUploaderSize.sm: LooviButtonSize.sm,
    }.entries) {
      await pumpLoovi(tester, LooviFileUploader(label: 'L', size: e.key, onPick: () => picks++));
      final b = tester.widget<LooviButton>(find.byType(LooviButton));
      expect(b.size, e.value);
      expect(b.variant, LooviButtonVariant.solid);
      expect(b.intent, LooviButtonIntent.primary);
      expect(b.showIcon, isTrue);
      expect(b.leadingIcon, LooviIcons.uploadOutline);
      expect(b.label, 'Subir arquivo');
      expect(find.byType(LooviFileUploaderDropzoneItem), findsNothing);
      await tester.tap(find.byType(LooviButton));
    }
    expect(picks, 3);
  });

  testWidgets('variant=drag-and-drop: dropzone instead of Button', (tester) async {
    var picks = 0;
    await pumpLoovi(
      tester,
      LooviFileUploader(label: 'L', variant: LooviFileUploaderVariant.dragAndDrop, onPick: () => picks++),
    );
    expect(find.byType(LooviButton), findsNothing);
    await tester.tap(find.byType(LooviFileUploaderDropzoneItem));
    expect(picks, 1);
  });

  testWidgets('files: list at item size 1:1; onRemove gets the file; showFiles=false hides', (tester) async {
    LooviFileUploaderFile? removed;
    await pumpLoovi(
      tester,
      LooviFileUploader(label: 'L', size: LooviFileUploaderSize.md, files: _files, onPick: () {}, onRemove: (f) => removed = f),
    );
    expect(find.byType(LooviFileUploaderItem), findsNWidgets(3));
    expect(tester.widget<LooviFileUploaderItem>(find.byType(LooviFileUploaderItem).first).size, LooviFileUploaderItemSize.md);
    await tester.tap(find.byKey(const Key('loovi-file-uploader-item-remove')).at(1));
    expect(removed?.id, 2);

    await pumpLoovi(tester, LooviFileUploader(label: 'L', files: _files, showFiles: false, onPick: () {}));
    expect(find.byType(LooviFileUploaderList), findsNothing);
  });

  testWidgets('disabled: placeholder texts, Button disabled, list hard-hidden', (tester) async {
    var picks = 0;
    await pumpLoovi(
      tester,
      LooviFileUploader(label: 'L', description: 'D', files: _files, state: LooviFileUploaderState.disabled, onPick: () => picks++),
    );
    expect(tester.widget<Text>(find.text('L')).style!.color, _t.text.placeholder);
    expect(tester.widget<Text>(find.text('D')).style!.color, _t.text.placeholder);
    expect(tester.widget<LooviButton>(find.byType(LooviButton)).disabled, isTrue);
    expect(find.byType(LooviFileUploaderList), findsNothing);
    await tester.tap(find.byType(LooviButton));
    expect(picks, 0);
  });

  testWidgets('skeleton: bones only, disabled-surface root, no nested components', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(
      tester,
      LooviFileUploader(label: 'L', files: _files, state: LooviFileUploaderState.skeleton, onPick: () {}),
    );
    expect(find.byType(LooviButton), findsNothing);
    expect(find.byType(LooviFileUploaderDropzoneItem), findsNothing);
    expect(find.byType(LooviFileUploaderList), findsNothing);
    expect(find.text('L'), findsNothing);
    final root = tester.widget<DecoratedBox>(find.byKey(const Key('loovi-file-uploader-skeleton')));
    expect((root.decoration as BoxDecoration).color, _t.interactive.disabledSurface);
    expect(find.bySemanticsLabel('Carregando'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('textScaler 2.0 does not overflow', (tester) async {
    await pumpLoovi(
      tester,
      LooviFileUploader(label: 'Enviar arquivos', description: 'Tamanho máximo 500 KB.', files: _files, onPick: () {}),
      textScale: 2,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('golden: matrix', (tester) async {
    await pumpGolden(tester, const FileUploaderMatrix(), height: 1640);
    await expectLater(find.byType(FileUploaderMatrix), matchesGoldenFile('../goldens/file_uploader_matrix.png'));
  });
}
