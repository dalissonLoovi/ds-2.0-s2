import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

Color _labelColor(WidgetTester tester, String label) => tester.widget<Text>(find.text(label)).style!.color!;

/// Story "Matrix": size × state × appearance (+ inline). Same as the Widgetbook story.
class LinkMatrix extends StatelessWidget {
  const LinkMatrix({super.key});

  static const _states = ['default', 'focus', 'active', 'visited', 'disabled'];

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget cell(LooviLinkSize size, LooviLinkAppearance a, String state, {bool inline = false}) => LooviLink(
          label: 'Link',
          onPressed: () {},
          size: size,
          appearance: a,
          inline: inline,
          visited: state == 'visited',
          disabled: state == 'disabled',
          statesController: switch (state) {
            'active' => WidgetStatesController({WidgetState.pressed}),
            'focus' => WidgetStatesController({WidgetState.focused}),
            _ => null,
          },
        );

    Widget block(LooviLinkAppearance a) => ColoredBox(
          color: a == LooviLinkAppearance.inverse ? t.color.backgroundSurfaceInverse3 : t.color.backgroundSurface0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: t.spacing.s100),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              for (final size in LooviLinkSize.values)
                Wrap(spacing: t.spacing.s100, children: [for (final s in _states) cell(size, a, s)]),
              Wrap(spacing: t.spacing.s100, children: [
                for (final s in _states) cell(LooviLinkSize.md, a, s, inline: true),
              ]),
            ]),
          ),
        );

    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        block(LooviLinkAppearance.defaultAppearance),
        block(LooviLinkAppearance.inverse),
      ]),
    );
  }
}

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('renders label + trailing icon and calls onPressed', (tester) async {
    var taps = 0;
    await pumpLoovi(tester, Align(alignment: Alignment.topLeft, child: LooviLink(label: 'Ver detalhes', onPressed: () => taps++)));
    expect(find.text('Ver detalhes'), findsOneWidget);
    final icon = tester.widget<LooviIcon>(find.byType(LooviIcon));
    expect(icon.name, LooviIcons.arrowNarrowRightOutline);
    expect(icon.size, _t.spacing.s200);
    await tester.tap(find.byType(LooviLink));
    expect(taps, 1);
  });

  testWidgets('disabled does not call back and paints text/placeholder', (tester) async {
    var taps = 0;
    await pumpLoovi(tester, Align(alignment: Alignment.topLeft, child: LooviLink(label: 'L', onPressed: () => taps++, disabled: true)));
    await tester.tap(find.byType(LooviLink));
    expect(taps, 0);
    expect(_labelColor(tester, 'L'), _t.text.placeholder);
  });

  testWidgets('semantics: link, label, enabled; visited hint', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(
      tester,
      Column(children: [
        LooviLink(key: const Key('a'), label: 'Ajuda', onPressed: () {}),
        LooviLink(key: const Key('b'), label: 'Termos', onPressed: () {}, visited: true),
      ]),
    );
    expect(
      tester.getSemantics(find.byKey(const Key('a'))),
      isSemantics(label: 'Ajuda', isLink: true, hasEnabledState: true, isEnabled: true, hasTapAction: true),
    );
    expect(tester.getSemantics(find.byKey(const Key('b'))), isSemantics(label: 'Termos', hint: 'Visitado'));
    handle.dispose();
  });

  testWidgets('touch target >= 48 while the paint keeps the text size', (tester) async {
    await pumpLoovi(tester, Align(alignment: Alignment.topLeft, child: LooviLink(label: 'L', onPressed: () {}, size: LooviLinkSize.sm)));
    final s = tester.getSize(find.byType(LooviLink));
    expect(s.height, greaterThanOrEqualTo(48));
    expect(s.width, greaterThanOrEqualTo(48));
    expect(tester.getSize(find.text('L')).height, closeTo(_t.typography.bodySmallRegular.fontSize! * _t.typography.bodySmallRegular.height!, 0.01));
  });

  testWidgets('state colors: default, active (pressed), visited; inverse', (tester) async {
    await pumpLoovi(
      tester,
      Column(children: [
        LooviLink(key: const Key('d'), label: 'D', onPressed: () {}),
        LooviLink(label: 'V', onPressed: () {}, visited: true),
        LooviLink(label: 'I', onPressed: () {}, appearance: LooviLinkAppearance.inverse),
        LooviLink(label: 'IV', onPressed: () {}, appearance: LooviLinkAppearance.inverse, visited: true),
      ]),
    );
    expect(_labelColor(tester, 'D'), _t.text.link);
    expect(_labelColor(tester, 'V'), _t.text.secondary);
    expect(_labelColor(tester, 'I'), _t.text.onColor);
    expect(_labelColor(tester, 'IV'), _t.text.onColorDisabled);
    final g = await tester.startGesture(tester.getCenter(find.byKey(const Key('d'))));
    await tester.pump();
    expect(_labelColor(tester, 'D'), _t.text.primary);
    await g.up();
  });

  testWidgets('inline: underline bar, no icon; sizes use body/*/regular', (tester) async {
    await pumpLoovi(
      tester,
      Column(children: [
        LooviLink(label: 'In', onPressed: () {}, inline: true, size: LooviLinkSize.md),
        LooviLink(label: 'Sm', onPressed: () {}, size: LooviLinkSize.sm),
      ]),
    );
    expect(find.descendant(of: find.widgetWithText(LooviLink, 'In'), matching: find.byType(LooviIcon)), findsNothing);
    final bar = tester.widget<SizedBox>(find.descendant(
      of: find.widgetWithText(LooviLink, 'In'),
      matching: find.byWidgetPredicate((w) => w is SizedBox && w.height == _t.borderWidth.s012),
    ));
    expect((bar.child! as ColoredBox).color, _t.text.link);
    expect(tester.widget<Text>(find.text('In')).style!.fontSize, _t.typography.bodyMediumRegular.fontSize);
    expect(tester.widget<Text>(find.text('Sm')).style!.fontWeight, _t.typography.bodySmallRegular.fontWeight);
  });

  testWidgets('keyboard focus ring (interactive/focus, border/width/012) and Enter activates', (tester) async {
    var taps = 0;
    final node = FocusNode();
    addTearDown(node.dispose);
    FocusManager.instance.highlightStrategy = FocusHighlightStrategy.alwaysTraditional;
    addTearDown(() => FocusManager.instance.highlightStrategy = FocusHighlightStrategy.automatic);
    await pumpLoovi(tester, Align(alignment: Alignment.topLeft, child: LooviLink(label: 'L', onPressed: () => taps++, focusNode: node)));
    node.requestFocus();
    await tester.pump();
    await tester.pump(); // focus highlight callback runs post-frame
    final ring = tester.widget<DecoratedBox>(find.descendant(
      of: find.byType(LooviLink),
      matching: find.byWidgetPredicate((w) => w is DecoratedBox && w.position == DecorationPosition.foreground),
    ));
    final d = ring.decoration as BoxDecoration;
    expect((d.border! as Border).top.color, _t.interactive.focus);
    expect((d.border! as Border).top.width, _t.borderWidth.s012);
    expect(d.borderRadius, BorderRadius.circular(_t.radius.s100));
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('golden: matrix', (tester) async {
    await pumpGolden(tester, const LinkMatrix(), height: 400);
    await expectLater(find.byType(LinkMatrix), matchesGoldenFile('../goldens/link_matrix.png'));
  });
}
