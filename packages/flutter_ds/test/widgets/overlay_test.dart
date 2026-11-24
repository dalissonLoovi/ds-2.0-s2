import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

/// Fake page behind the scrim.
class _Page extends StatelessWidget {
  const _Page();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: Padding(
        padding: EdgeInsets.all(t.spacing.s200),
        child: Text('Conteúdo da página', style: t.typography.bodyMediumRegular.copyWith(color: t.text.primary)),
      ),
    );
  }
}

/// Story "Variants": type=modal and type=bottom-sheet (platform=mobile) over a
/// page, side by side (195 x 420 each). Same as the Widgetbook story.
class OverlayVariants extends StatelessWidget {
  const OverlayVariants({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget frame(Widget overlay) => Expanded(
      child: SizedBox(
        height: 420,
        child: Stack(fit: StackFit.expand, children: [const _Page(), overlay]),
      ),
    );
    final body = Text('Deseja sair?', style: t.typography.bodyMediumRegular.copyWith(color: t.text.secondary));
    return Row(
      children: [
        frame(LooviOverlay(child: LooviModal(title: 'Sair', showCloseAction: false, child: body))),
        frame(
          LooviOverlay(
            type: LooviOverlayType.bottomSheet,
            child: LooviBottomSheet(header: LooviBottomSheetHeaderVariant.none, semanticLabel: 'Opções', child: body),
          ),
        ),
      ],
    );
  }
}

Finder _scrim() => find.descendant(of: find.byType(LooviOverlay), matching: find.byType(ColoredBox)).first;

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('scrim color/overlay/overlay fills the box', (tester) async {
    await pumpLoovi(tester, const SizedBox(height: 400, child: LooviOverlay(child: SizedBox.square(dimension: 10))));
    expect(tester.widget<ColoredBox>(_scrim()).color, _t.color.overlayOverlay);
    expect(tester.getSize(_scrim()), const Size(390, 400));
  });

  testWidgets('padding tokens per type x platform', (tester) async {
    expect(
      LooviOverlay.paddingFor(_t, LooviOverlayType.modal, LooviOverlayPlatform.mobile),
      EdgeInsets.symmetric(vertical: _t.spacing.s400, horizontal: _t.spacing.s250),
    );
    expect(
      LooviOverlay.paddingFor(_t, LooviOverlayType.modal, LooviOverlayPlatform.web),
      EdgeInsets.symmetric(vertical: _t.spacing.s400, horizontal: _t.spacing.s1200),
    );
    expect(
      LooviOverlay.paddingFor(_t, LooviOverlayType.bottomSheet, LooviOverlayPlatform.mobile),
      EdgeInsets.only(top: _t.spacing.s700),
    );
  });

  testWidgets('modal: slot centered; bottom-sheet: anchored bottom, full width', (tester) async {
    await pumpLoovi(tester, const SizedBox(height: 400, child: LooviOverlay(child: SizedBox(width: 100, height: 50))));
    final r = tester.getRect(find.byWidgetPredicate((w) => w is SizedBox && w.width == 100));
    expect(r.center, const Offset(195, 200));
    await pumpLoovi(
      tester,
      const SizedBox(
        height: 400,
        child: LooviOverlay(type: LooviOverlayType.bottomSheet, child: SizedBox(height: 50, key: Key('sheet'))),
      ),
    );
    final s = tester.getRect(find.byKey(const Key('sheet')));
    expect(s.bottom, 400);
    expect(s.width, 390);
  });

  testWidgets('scrim tap calls onScrimTap; tap on the surface does not', (tester) async {
    var taps = 0;
    await pumpLoovi(
      tester,
      SizedBox(
        height: 400,
        child: LooviOverlay(
          onScrimTap: () => taps++,
          child: GestureDetector(onTap: () {}, child: const SizedBox(width: 100, height: 50, key: Key('surface'), child: ColoredBox(color: Color(0x00000000)))),
        ),
      ),
    );
    await tester.tapAt(const Offset(10, 10));
    expect(taps, 1);
    await tester.tap(find.byKey(const Key('surface')));
    expect(taps, 1);
  });

  testWidgets('semantics: scrim is not focusable / has no node; surface keeps its semantics', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(
      tester,
      SizedBox(
        height: 500,
        child: LooviOverlay(onScrimTap: () {}, child: const LooviModal(title: 'Sair', child: Text('Deseja sair?'))),
      ),
    );
    expect(tester.getSemantics(find.text('Deseja sair?')).label, 'Deseja sair?');
    expect(
      find.descendant(of: find.byType(LooviOverlay), matching: find.byType(ExcludeSemantics)),
      findsWidgets,
    );
    expect(find.bySemanticsLabel('Sair'), findsWidgets);
    handle.dispose();
  });

  test('bottom-sheet + web is not published (assert)', () {
    expect(
      () => LooviOverlay(type: LooviOverlayType.bottomSheet, platform: LooviOverlayPlatform.web, child: const SizedBox()),
      throwsAssertionError,
    );
  });

  testWidgets('golden: variants', (tester) async {
    await pumpGolden(tester, const OverlayVariants(), height: 420);
    await expectLater(find.byType(OverlayVariants), matchesGoldenFile('../goldens/overlay_variants.png'));
  });
}
