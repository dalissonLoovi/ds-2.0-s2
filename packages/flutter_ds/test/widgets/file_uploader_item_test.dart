import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

/// The spinner repeats forever: freeze it (reduce-motion) so pumpAndSettle ends.
Widget _still(Widget child) => Builder(
      builder: (context) => MediaQuery(data: MediaQuery.of(context).copyWith(disableAnimations: true), child: child),
    );

/// Story "Matrix": every state × size, plus the forced focus on remove.
class FileUploaderItemMatrix extends StatefulWidget {
  const FileUploaderItemMatrix({super.key});

  @override
  State<FileUploaderItemMatrix> createState() => _FileUploaderItemMatrixState();
}

class _FileUploaderItemMatrixState extends State<FileUploaderItemMatrix> {
  final _focus = WidgetStatesController({WidgetState.focused});

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget item(LooviFileUploaderItemSize size, LooviFileUploaderItemState state, {bool focus = false}) => Padding(
          padding: EdgeInsets.only(bottom: t.spacing.s100),
          child: LooviFileUploaderItem(
            fileName: 'documento-veiculo.png',
            size: size,
            state: state,
            shortDescription: 'O arquivo excede o limite de tamanho.',
            longDescription: 'Envie uma imagem de até 500 KB nos formatos .jpg ou .png.',
            onRemove: () {},
            removeStatesController: focus ? _focus : null,
          ),
        );
    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: Padding(
        padding: EdgeInsets.all(t.spacing.s200),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          for (final size in LooviFileUploaderItemSize.values.reversed) ...[
            for (final state in LooviFileUploaderItemState.values) item(size, state),
            item(size, LooviFileUploaderItemState.uploaded, focus: true),
          ],
        ]),
      ),
    );
  }
}

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('row heights 48/40/32 and surface/1 fill', (tester) async {
    for (final e in {
      LooviFileUploaderItemSize.lg: _t.spacing.s600,
      LooviFileUploaderItemSize.md: _t.spacing.s500,
      LooviFileUploaderItemSize.sm: _t.spacing.s400,
    }.entries) {
      await pumpLoovi(tester, LooviFileUploaderItem(fileName: 'a.png', size: e.key, onRemove: () {}));
      expect(tester.getSize(find.byType(LooviFileUploaderItem)).height, e.value);
      final box = tester.widget<DecoratedBox>(
        find.descendant(of: find.byType(LooviFileUploaderItem), matching: find.byType(DecoratedBox)).first,
      );
      final d = box.decoration as BoxDecoration;
      expect(d.color, _t.color.backgroundSurface1);
      expect(d.borderRadius, BorderRadius.circular(_t.radius.s150));
    }
  });

  testWidgets('file name body/medium/regular text/primary', (tester) async {
    await pumpLoovi(tester, const LooviFileUploaderItem(fileName: 'foto.png'));
    final txt = tester.widget<Text>(find.text('foto.png'));
    expect(txt.style!.color, _t.text.primary);
    expect(txt.style!.fontSize, _t.typography.bodyMediumRegular.fontSize);
    expect(txt.overflow, TextOverflow.ellipsis);
  });

  testWidgets('loading shows a decorative spinner and no remove; success shows feedback/success icon', (tester) async {
    await pumpLoovi(tester, _still(LooviFileUploaderItem(fileName: 'a.png', state: LooviFileUploaderItemState.loading, onRemove: () {})));
    expect(find.byType(LooviLoadingSpinner), findsOneWidget);
    expect(tester.widget<LooviLoadingSpinner>(find.byType(LooviLoadingSpinner)).decorative, isTrue);
    expect(find.byKey(const Key('loovi-file-uploader-item-remove')), findsNothing);

    await pumpLoovi(tester, LooviFileUploaderItem(fileName: 'a.png', state: LooviFileUploaderItemState.success, onRemove: () {}));
    final icon = tester.widget<LooviIcon>(find.byType(LooviIcon));
    expect(icon.name, LooviIcons.circleCheckFilled);
    expect(icon.color, _t.feedback.success);
    expect(find.byKey(const Key('loovi-file-uploader-item-remove')), findsNothing);
  });

  testWidgets('danger: border danger 025, surface/0, error text/danger, description text/secondary, icon feedback/danger',
      (tester) async {
    await pumpLoovi(
      tester,
      LooviFileUploaderItem(
        fileName: 'a.png',
        state: LooviFileUploaderItemState.dangerLong,
        shortDescription: 'Arquivo grande demais.',
        longDescription: 'Máximo 500 KB.',
        onRemove: () {},
      ),
    );
    final boxes = tester
        .widgetList<DecoratedBox>(find.descendant(of: find.byType(LooviFileUploaderItem), matching: find.byType(DecoratedBox)))
        .map((d) => d.decoration as BoxDecoration)
        .toList();
    final border = boxes.first.border as Border;
    expect(border.top.color, _t.color.borderFeedbackDanger);
    expect(border.top.width, _t.borderWidth.s025);
    expect(boxes[1].color, _t.color.backgroundSurface0);
    expect(tester.widget<Text>(find.text('Arquivo grande demais.')).style!.color, _t.text.danger);
    expect(tester.widget<Text>(find.text('Máximo 500 KB.')).style!.color, _t.text.secondary);
    expect(tester.widget<Text>(find.text('Máximo 500 KB.')).style!.fontSize, _t.typography.bodySmallRegular.fontSize);
    final alert = tester.widgetList<LooviIcon>(find.byType(LooviIcon)).firstWhere((i) => i.name == LooviIcons.alertCircleFilled);
    expect(alert.color, _t.feedback.danger);
    expect(tester.widget<Divider>(find.byType(Divider)).color, _t.color.border2);
  });

  testWidgets('danger-short hides the long description', (tester) async {
    await pumpLoovi(
      tester,
      const LooviFileUploaderItem(
        fileName: 'a.png',
        state: LooviFileUploaderItemState.dangerShort,
        shortDescription: 'Curta',
        longDescription: 'Longa',
      ),
    );
    expect(find.text('Curta'), findsOneWidget);
    expect(find.text('Longa'), findsNothing);
  });

  testWidgets('remove: tap anywhere in the right touch area, row size unchanged', (tester) async {
    var removed = 0;
    await pumpLoovi(
      tester,
      LooviFileUploaderItem(fileName: 'a.png', size: LooviFileUploaderItemSize.sm, onRemove: () => removed++),
    );
    expect(tester.getSize(find.byType(LooviFileUploaderItem)).height, _t.spacing.s400);
    final target = tester.getRect(find.byKey(const Key('loovi-file-uploader-item-remove-target')));
    expect(target.height, _t.spacing.s400);
    expect(target.width, greaterThanOrEqualTo(_t.spacing.s300 * 1.5));
    await tester.tapAt(target.topLeft + const Offset(2, 2));
    await tester.tap(find.byKey(const Key('loovi-file-uploader-item-remove')));
    expect(removed, 2);
  });

  testWidgets('semantics: row label + status live region; remove button named', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, _still(LooviFileUploaderItem(fileName: 'foto.png', state: LooviFileUploaderItemState.loading, onRemove: () {})));
    expect(
      tester.getSemantics(find.byType(LooviFileUploaderItem)),
      matchesSemantics(label: 'foto.png', value: 'Enviando', isLiveRegion: true),
    );

    await pumpLoovi(tester, LooviFileUploaderItem(fileName: 'foto.png', onRemove: () {}));
    expect(
      tester.getSemantics(find.byKey(const Key('loovi-file-uploader-item-remove-target'))),
      matchesSemantics(
        label: 'Remover arquivo foto.png',
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );
    handle.dispose();
  });

  testWidgets('focus: remove shows interactive/focus ring and Enter removes', (tester) async {
    var removed = 0;
    await pumpLoovi(tester, LooviFileUploaderItem(fileName: 'a.png', onRemove: () => removed++));
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    final ring = tester.widgetList<DecoratedBox>(find.byType(DecoratedBox)).where((d) {
      final b = (d.decoration as BoxDecoration).border;
      return b is Border && b.top.color == _t.interactive.focus;
    });
    expect(ring, isNotEmpty);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(removed, 1);
  });

  testWidgets('textScaler 2.0 grows the row instead of clipping', (tester) async {
    await pumpLoovi(tester, const LooviFileUploaderItem(fileName: 'a.png', size: LooviFileUploaderItemSize.sm), textScale: 2);
    expect(tester.getSize(find.byType(LooviFileUploaderItem)).height, greaterThan(_t.spacing.s400));
    expect(tester.takeException(), isNull);
  });

  testWidgets('golden: matrix', (tester) async {
    await pumpGolden(tester, _still(const FileUploaderItemMatrix()), height: 1320);
    await expectLater(find.byType(FileUploaderItemMatrix), matchesGoldenFile('../goldens/file_uploader_item_matrix.png'));
  });
}
