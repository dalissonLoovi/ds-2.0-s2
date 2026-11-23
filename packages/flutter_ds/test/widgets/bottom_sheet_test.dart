import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

const _title = 'Cancelar plano?';
const _body = 'Você perde a cobertura a partir da data de cancelamento.';

Widget _bodyText(BuildContext context) {
  final t = LooviTokens.of(context);
  return Text(_body, style: t.typography.bodyMediumRegular.copyWith(color: t.text.secondary));
}

/// Root decoration of the first [LooviBottomSheet].
BoxDecoration _root(WidgetTester tester) => tester
    .widgetList<DecoratedBox>(find.descendant(of: find.byType(LooviBottomSheet), matching: find.byType(DecoratedBox)))
    .map((b) => b.decoration as BoxDecoration)
    .firstWhere((d) => d.color == _t.color.backgroundSurface0);

/// Painted 40 square of an icon action (the SizedBox around the icon).
Size _paintOf(WidgetTester tester, String label) {
  final box = find.descendant(
    of: find.bySemanticsLabel(label),
    matching: find.byWidgetPredicate((w) => w is SizedBox && w.width == _t.spacing.s500 && w.height == _t.spacing.s500),
  );
  return tester.getSize(box);
}

/// Story "Variants": inline panels — same as the Widgetbook story.
class BottomSheetVariants extends StatelessWidget {
  const BottomSheetVariants({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget caption(String s) => Padding(
          padding: EdgeInsets.only(bottom: t.spacing.s100),
          child: Text(s, style: t.typography.captionLargeRegular.copyWith(color: t.text.secondary)),
        );
    Widget actions() => Row(children: [
          Expanded(
            child: LooviButton(
              label: 'Manter plano',
              variant: LooviButtonVariant.outline,
              fullWidth: true,
              onPressed: () {},
            ),
          ),
          SizedBox(width: t.spacing.s100),
          Expanded(
            child: LooviButton(
              label: 'Cancelar plano',
              intent: LooviButtonIntent.danger,
              fullWidth: true,
              onPressed: () {},
            ),
          ),
        ]);
    Widget content() => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Builder(builder: _bodyText),
          SizedBox(height: t.spacing.s300),
          actions(),
        ]);
    return ColoredBox(
      color: t.color.backgroundSurface2,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: t.spacing.s300),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Padding(padding: EdgeInsets.symmetric(horizontal: t.spacing.s300), child: caption('BottomSheet · header=none')),
          LooviBottomSheet(header: LooviBottomSheetHeaderVariant.none, child: content()),
          SizedBox(height: t.spacing.s300),
          Padding(padding: EdgeInsets.symmetric(horizontal: t.spacing.s300), child: caption('BottomSheet · header=sheet-header')),
          LooviBottomSheet(title: _title, onClose: () {}, child: content()),
          SizedBox(height: t.spacing.s300),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: t.spacing.s300),
            child: caption('BottomSheetHeader · leading / options / showLabel=false'),
          ),
          LooviBottomSheetHeader(title: 'Detalhes do plano', showLeadingAction: true, onLeadingAction: () {}, onClose: () {}),
          LooviBottomSheetHeader(title: 'Detalhes do plano', showOptionsAction: true, onOptions: () {}, onClose: () {}),
          LooviBottomSheetHeader(showLabel: false, onClose: () {}),
        ]),
      ),
    );
  }
}

class _Launcher extends StatelessWidget {
  const _Launcher({this.header = LooviBottomSheetHeaderVariant.sheetHeader});
  final LooviBottomSheetHeaderVariant header;

  @override
  Widget build(BuildContext context) => LooviButton(
        label: 'Abrir',
        onPressed: () => showLooviBottomSheet<void>(
          context,
          header: header,
          title: _title,
          semanticLabel: header == LooviBottomSheetHeaderVariant.none ? _title : null,
          builder: _bodyText,
        ),
      );
}

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('root: surface/0, top radius/600, no elevation; handle on header=none', (tester) async {
    await pumpLoovi(tester, const LooviBottomSheet(header: LooviBottomSheetHeaderVariant.none, child: Text(_body)));
    final d = _root(tester);
    expect(d.borderRadius, BorderRadius.vertical(top: Radius.circular(_t.radius.s600)));
    expect(d.boxShadow, isNull);
    final handle = find.byWidgetPredicate(
      (w) => w is DecoratedBox && (w.decoration as BoxDecoration).color == _t.text.placeholder,
    );
    expect(tester.getSize(handle), Size(_t.spacing.s400, _t.spacing.s050));
    // paddingTop spacing/150 above the handle.
    final sheetTop = tester.getTopLeft(find.byType(LooviBottomSheet)).dy;
    expect(tester.getTopLeft(handle).dy - sheetTop, _t.spacing.s150);
  });

  testWidgets('sheet-header: actions paint 40, hit 48; painted header top = spacing/150', (tester) async {
    await pumpLoovi(
      tester,
      LooviBottomSheet(title: _title, showLeadingAction: true, onLeadingAction: () {}, onClose: () {}, child: const Text(_body)),
    );
    expect(_paintOf(tester, 'Fechar'), Size.square(_t.spacing.s500));
    expect(_paintOf(tester, 'Ação'), Size.square(_t.spacing.s500));
    final hit = tester.getSize(find.bySemanticsLabel('Fechar'));
    expect(hit.height, greaterThanOrEqualTo(48));
    expect(hit.width, greaterThanOrEqualTo(48));
    final sheetTop = tester.getTopLeft(find.byType(LooviBottomSheet)).dy;
    final closePaint = find.descendant(
      of: find.bySemanticsLabel('Fechar'),
      matching: find.byWidgetPredicate((w) => w is SizedBox && w.width == _t.spacing.s500),
    );
    expect(tester.getTopLeft(closePaint).dy - sheetTop, _t.spacing.s150);
    // Close paint flush with the sheet's trailing edge (root pad spacing/0).
    expect(tester.getTopRight(closePaint).dx, tester.getTopRight(find.byType(LooviBottomSheet)).dx);
    final title = tester.widget<Text>(find.text(_title));
    expect(title.style!.fontSize, _t.typography.bodyMediumMedium.fontSize);
    expect(title.style!.color, _t.text.primary);
  });

  testWidgets('header actions call back; leading wins over options in the shared slot', (tester) async {
    var leading = 0, options = 0, close = 0;
    await pumpLoovi(
      tester,
      LooviBottomSheetHeader(
        title: _title,
        showLeadingAction: true,
        showOptionsAction: true,
        onLeadingAction: () => leading++,
        onOptions: () => options++,
        onClose: () => close++,
      ),
    );
    expect(find.bySemanticsLabel('Opções'), findsNothing);
    await tester.tap(find.bySemanticsLabel('Ação'));
    await tester.tap(find.bySemanticsLabel('Fechar'));
    expect((leading, options, close), (1, 0, 1));

    await pumpLoovi(tester, LooviBottomSheetHeader(showOptionsAction: true, onOptions: () => options++));
    await tester.tap(find.bySemanticsLabel('Opções'));
    expect(options, 1);
  });

  testWidgets('semantics: route named by title, title is header', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, LooviBottomSheet(title: _title, onClose: () {}, child: const Text(_body)));
    expect(
      tester.getSemantics(find.byType(LooviBottomSheet)),
      isSemantics(label: _title, scopesRoute: true, namesRoute: true),
    );
    expect(tester.getSemantics(find.text(_title)), isSemantics(label: _title, isHeader: true));
    handle.dispose();
  });

  testWidgets('showLooviBottomSheet: overlay barrier, close/barrier/back/Esc close it', (tester) async {
    await pumpLoovi(tester, const Align(alignment: Alignment.topLeft, child: _Launcher()));

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(find.byType(LooviBottomSheet), findsOneWidget);
    expect(tester.widgetList<ModalBarrier>(find.byType(ModalBarrier)).last.color, _t.color.overlayOverlay);
    await tester.tap(find.bySemanticsLabel('Fechar'));
    await tester.pumpAndSettle();
    expect(find.byType(LooviBottomSheet), findsNothing, reason: 'close');

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(find.byType(LooviBottomSheet), findsNothing, reason: 'barrier');

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(LooviBottomSheet), findsNothing, reason: 'back');

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byType(LooviBottomSheet), findsNothing, reason: 'Esc');
  });

  testWidgets('showLooviBottomSheet header=none: handle, route named by semanticLabel, drag-free close by barrier', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(
      tester,
      const Align(alignment: Alignment.topLeft, child: _Launcher(header: LooviBottomSheetHeaderVariant.none)),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(find.byType(LooviBottomSheetHeader), findsNothing);
    expect(
      tester.getSemantics(find.byType(LooviBottomSheet)),
      isSemantics(label: _title, scopesRoute: true, namesRoute: true),
    );
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(find.byType(LooviBottomSheet), findsNothing);
    handle.dispose();
  });

  testWidgets('textScaler 2: sheet content scrolls without overflow', (tester) async {
    tester.view.physicalSize = const Size(390, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(looviHarness(
      Builder(
        builder: (context) => LooviButton(
          label: 'Abrir',
          onPressed: () => showLooviBottomSheet<void>(
            context,
            title: _title,
            builder: (c) => Column(children: [for (var i = 0; i < 10; i++) const Text(_body)]),
          ),
        ),
      ),
      textScale: 2,
    ));
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(MediaQuery.textScalerOf(tester.element(find.text(_title))).scale(10), 20);
    expect(tester.takeException(), isNull);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(tester.getRect(find.byType(LooviBottomSheet)).bottom, lessThanOrEqualTo(640));
  });

  testWidgets('golden: variants', (tester) async {
    await pumpGolden(tester, const BottomSheetVariants(), height: 820);
    await expectLater(find.byType(BottomSheetVariants), matchesGoldenFile('../goldens/bottom_sheet_variants.png'));
  });
}
