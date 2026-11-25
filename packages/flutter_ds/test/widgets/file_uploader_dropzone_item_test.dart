import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

/// Story "States": default, drag-hover, focus (forced), disabled.
class FileUploaderDropzoneItemStates extends StatefulWidget {
  const FileUploaderDropzoneItemStates({super.key});

  @override
  State<FileUploaderDropzoneItemStates> createState() => _FileUploaderDropzoneItemStatesState();
}

class _FileUploaderDropzoneItemStatesState extends State<FileUploaderDropzoneItemStates> {
  final _focus = WidgetStatesController({WidgetState.focused});

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget gap() => SizedBox(height: t.spacing.s200);
    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: Padding(
        padding: EdgeInsets.all(t.spacing.s200),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          LooviFileUploaderDropzoneItem(onPick: () {}),
          gap(),
          LooviFileUploaderDropzoneItem(onPick: () {}, dragHover: true),
          gap(),
          LooviFileUploaderDropzoneItem(onPick: () {}, statesController: _focus),
          gap(),
          LooviFileUploaderDropzoneItem(onPick: () {}, disabled: true),
        ]),
      ),
    );
  }
}

BoxDecoration _fill(WidgetTester tester) =>
    tester.widget<DecoratedBox>(find.byKey(const Key('loovi-dropzone-fill'))).decoration as BoxDecoration;

Color _textColor(WidgetTester tester) =>
    tester.widget<Text>(find.descendant(of: find.byType(LooviFileUploaderDropzoneItem), matching: find.byType(Text))).style!.color!;

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('default: surface/0, text/secondary body/small/regular, radius/200, padding 24/24/64', (tester) async {
    await pumpLoovi(tester, LooviFileUploaderDropzoneItem(onPick: () {}));
    expect(_fill(tester).color, _t.color.backgroundSurface0);
    expect(_fill(tester).borderRadius, BorderRadius.circular(_t.radius.s200));
    expect(_textColor(tester), _t.text.secondary);
    final text = tester.widget<Text>(find.byType(Text));
    expect(text.style!.fontSize, _t.typography.bodySmallRegular.fontSize);
    final box = tester.getRect(find.byKey(const Key('loovi-dropzone-fill')));
    final txt = tester.getRect(find.byType(Text));
    expect(txt.top - box.top, _t.spacing.s300);
    expect(txt.left - box.left, _t.spacing.s300);
    expect(box.bottom - txt.bottom, _t.spacing.s800);
  });

  testWidgets('drag-hover: interactive/hover fill', (tester) async {
    await pumpLoovi(tester, LooviFileUploaderDropzoneItem(onPick: () {}, dragHover: true));
    expect(_fill(tester).color, _t.interactive.hover);
  });

  testWidgets('disabled: disabled-surface + text/placeholder, no tap', (tester) async {
    var picks = 0;
    await pumpLoovi(tester, LooviFileUploaderDropzoneItem(onPick: () => picks++, disabled: true));
    expect(_fill(tester).color, _t.interactive.disabledSurface);
    expect(_textColor(tester), _t.text.placeholder);
    await tester.tap(find.byType(LooviFileUploaderDropzoneItem));
    expect(picks, 0);
  });

  testWidgets('tap and keyboard (Tab + Enter/Space) call onPick; target >= 48', (tester) async {
    var picks = 0;
    await pumpLoovi(tester, LooviFileUploaderDropzoneItem(onPick: () => picks++));
    expect(tester.getSize(find.byType(LooviFileUploaderDropzoneItem)).height, greaterThanOrEqualTo(_t.spacing.s600));
    await tester.tap(find.byType(LooviFileUploaderDropzoneItem));
    expect(picks, 1);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    expect(picks, 3);
  });

  testWidgets('semantics: button "Selecionar arquivo" with helper text as hint', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, LooviFileUploaderDropzoneItem(onPick: () {}, helperText: 'Toque para escolher'));
    expect(
      tester.getSemantics(find.byType(LooviFileUploaderDropzoneItem)),
      matchesSemantics(
        label: 'Selecionar arquivo',
        hint: 'Toque para escolher',
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );
    await pumpLoovi(tester, const LooviFileUploaderDropzoneItem(onPick: null));
    expect(
      tester.getSemantics(find.byType(LooviFileUploaderDropzoneItem)),
      matchesSemantics(
        label: 'Selecionar arquivo',
        hint: 'Toque para selecionar o arquivo.',
        isButton: true,
        hasEnabledState: true,
      ),
    );
    handle.dispose();
  });

  testWidgets('textScaler 2.0 does not overflow', (tester) async {
    await pumpLoovi(tester, LooviFileUploaderDropzoneItem(onPick: () {}), textScale: 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('golden: states', (tester) async {
    await pumpGolden(tester, const FileUploaderDropzoneItemStates(), height: 570);
    await expectLater(
      find.byType(FileUploaderDropzoneItemStates),
      matchesGoldenFile('../goldens/file_uploader_dropzone_item_states.png'),
    );
  });
}
