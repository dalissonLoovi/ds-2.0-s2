import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

/// Container paint of the first [LooviButton] (the fill/border DecoratedBox).
BoxDecoration _decoration(WidgetTester tester, {Finder? of}) {
  final box = tester.widget<DecoratedBox>(
    find
        .descendant(
          of: of ?? find.byType(LooviButton),
          matching: find.byWidgetPredicate((w) => w is DecoratedBox && w.position == DecorationPosition.background),
        )
        .first,
  );
  return box.decoration as BoxDecoration;
}

Color _labelColor(WidgetTester tester, String label) => tester.widget<Text>(find.text(label)).style!.color!;

/// Freezes the loading spinner (reduce-motion path) so pumpAndSettle settles.
Widget _still(Widget child) => Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: true),
        child: child,
      ),
    );

/// Story "Matrix": variant × intent × state (md) + sizes. Same as the Widgetbook story.
class ButtonMatrix extends StatelessWidget {
  const ButtonMatrix({super.key});

  static const _states = ['default', 'pressed', 'focus', 'selected', 'disabled', 'loading'];

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget cell(LooviButtonVariant v, LooviButtonIntent i, String state) => LooviButton(
          label: 'Label',
          onPressed: () {},
          variant: v,
          intent: i,
          selected: state == 'selected',
          disabled: state == 'disabled',
          loading: state == 'loading',
          statesController: switch (state) {
            'pressed' => WidgetStatesController({WidgetState.pressed}),
            'focus' => WidgetStatesController({WidgetState.focused}),
            _ => null,
          },
        );

    Widget group(LooviButtonVariant v, LooviButtonIntent i) => Padding(
          padding: EdgeInsets.only(bottom: t.spacing.s100),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${v.name} · ${i.name}', style: t.typography.captionLargeRegular.copyWith(color: t.text.secondary)),
            Wrap(
              spacing: t.spacing.s100,
              children: [for (final s in _states) cell(v, i, s)],
            ),
          ]),
        );

    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: Padding(
        padding: EdgeInsets.all(t.spacing.s100),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          for (final size in LooviButtonSize.values)
            Padding(
              padding: EdgeInsets.only(bottom: t.spacing.s100),
              child: Row(children: [
                LooviButton(label: 'Continuar', onPressed: () {}, size: size, showIcon: true, showTrailingIcon: true),
                SizedBox(width: t.spacing.s100),
                LooviButton(label: 'Continuar', onPressed: () {}, size: size, loading: true),
              ]),
            ),
          for (final i in LooviButtonIntent.values) group(LooviButtonVariant.solid, i),
          for (final v in [LooviButtonVariant.outline, LooviButtonVariant.text])
            for (final i in [LooviButtonIntent.primary, LooviButtonIntent.success, LooviButtonIntent.danger]) group(v, i),
        ]),
      ),
    );
  }
}

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('renders label and calls onPressed on tap', (tester) async {
    var taps = 0;
    await pumpLoovi(tester, Align(alignment: Alignment.topLeft, child: LooviButton(label: 'Continuar', onPressed: () => taps++)));
    expect(find.text('Continuar'), findsOneWidget);
    await tester.tap(find.byType(LooviButton));
    expect(taps, 1);
  });

  testWidgets('disabled (prop or null onPressed) does not call back', (tester) async {
    var taps = 0;
    await pumpLoovi(
      tester,
      Column(children: [
        LooviButton(key: const Key('a'), label: 'A', onPressed: () => taps++, disabled: true),
        const LooviButton(key: Key('b'), label: 'B', onPressed: null),
      ]),
    );
    await tester.tap(find.byKey(const Key('a')));
    await tester.tap(find.byKey(const Key('b')));
    expect(taps, 0);
    expect(_decoration(tester, of: find.byKey(const Key('a'))).color, _t.interactive.disabledSurface);
    expect(_labelColor(tester, 'A'), _t.text.placeholder);
  });

  testWidgets('loading: no callback, spinner only, busy semantics, square hug', (tester) async {
    final handle = tester.ensureSemantics();
    var taps = 0;
    await pumpLoovi(
      tester,
      _still(Align(alignment: Alignment.topLeft, child: LooviButton(label: 'Salvar', onPressed: () => taps++, loading: true))),
    );
    await tester.tap(find.byType(LooviButton));
    expect(taps, 0);
    expect(find.text('Salvar'), findsNothing);
    expect(find.byType(LooviIcon), findsNothing);
    final box = find.descendant(
      of: find.byType(LooviButton),
      matching: find.byWidgetPredicate((w) => w is DecoratedBox && w.position == DecorationPosition.background),
    );
    expect(tester.getSize(box.first), Size(_t.spacing.s600, _t.spacing.s600));
    expect(
      tester.getSemantics(find.byType(LooviButton)),
      isSemantics(label: 'Salvar', value: 'Carregando', isButton: true, hasEnabledState: true, isEnabled: false, isLiveRegion: true),
    );
    handle.dispose();
  });

  testWidgets('semantics: button, label, enabled; icon-only keeps the name', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(
      tester,
      Column(children: [
        LooviButton(key: const Key('a'), label: 'Continuar', onPressed: () {}),
        LooviButton(key: const Key('b'), label: 'Adicionar', onPressed: () {}, showLabel: false, showIcon: true),
      ]),
    );
    expect(
      tester.getSemantics(find.byKey(const Key('a'))),
      isSemantics(label: 'Continuar', isButton: true, hasEnabledState: true, isEnabled: true, hasTapAction: true),
    );
    expect(tester.getSemantics(find.byKey(const Key('b'))).label, 'Adicionar');
    handle.dispose();
  });

  testWidgets('touch target >= 48 for every size; sm paints 40', (tester) async {
    for (final size in LooviButtonSize.values) {
      await pumpLoovi(tester, Align(alignment: Alignment.topLeft, child: LooviButton(label: 'Ok', onPressed: () {}, size: size)));
      final s = tester.getSize(find.byType(LooviButton));
      expect(s.height, greaterThanOrEqualTo(48));
      expect(s.width, greaterThanOrEqualTo(48));
    }
    await pumpLoovi(tester, Align(alignment: Alignment.topLeft, child: LooviButton(label: 'Ok', onPressed: () {}, size: LooviButtonSize.sm)));
    final paint = find.descendant(
      of: find.byType(LooviButton),
      matching: find.byWidgetPredicate((w) => w is DecoratedBox && w.position == DecorationPosition.background),
    );
    expect(tester.getSize(paint.first).height, _t.spacing.s500);
  });

  testWidgets('app-cliente paint: solid primary uses component/button tokens, radius full', (tester) async {
    await pumpLoovi(tester, Align(alignment: Alignment.topLeft, child: LooviButton(label: 'Continuar', onPressed: () {}, size: LooviButtonSize.lg)));
    final d = _decoration(tester);
    expect(d.color, _t.component.button.containerBackground);
    expect(d.borderRadius, BorderRadius.circular(_t.radius.full));
    expect(d.borderRadius, BorderRadius.circular(_t.component.button.containerRadiusLg));
    final style = tester.widget<Text>(find.text('Continuar')).style!;
    expect(style.color, _t.component.button.labelColor);
    expect(style.fontWeight, _t.component.button.labelFontWeight);
    expect(style.fontSize, _t.typography.bodyLargeMedium.fontSize);
    expect(tester.getSize(find.byType(LooviButton)).height, _t.spacing.s700);
  });

  testWidgets('pressed: solid = Plus Darker(fill, interactive/pressed); outline = interactive/pressed', (tester) async {
    await pumpLoovi(
      tester,
      Column(children: [
        LooviButton(key: const Key('s'), label: 'S', onPressed: () {}),
        LooviButton(key: const Key('o'), label: 'O', onPressed: () {}, variant: LooviButtonVariant.outline),
      ]),
    );
    final gesture = await tester.startGesture(tester.getCenter(find.byKey(const Key('s'))));
    await tester.pump();
    final c = _decoration(tester, of: find.byKey(const Key('s'))).color!;
    final base = _t.component.button.containerBackground;
    final over = _t.interactive.pressed;
    expect(c.r, closeTo(base.r + over.r - 1, 1e-6));
    expect(c.b, closeTo(base.b + over.b - 1, 1e-6));
    await gesture.up();
    await tester.pump();
    expect(_decoration(tester, of: find.byKey(const Key('s'))).color, base);

    final g2 = await tester.startGesture(tester.getCenter(find.byKey(const Key('o'))));
    await tester.pump();
    final o = _decoration(tester, of: find.byKey(const Key('o')));
    expect(o.color, _t.interactive.pressed);
    expect((o.border! as Border).top.color, _t.color.border1);
    await g2.up();
  });

  testWidgets('intents: danger/success colors and text-variant primary icon', (tester) async {
    await pumpLoovi(
      tester,
      Column(children: [
        LooviButton(key: const Key('d'), label: 'D', onPressed: () {}, intent: LooviButtonIntent.danger),
        LooviButton(key: const Key('s'), label: 'S', onPressed: () {}, intent: LooviButtonIntent.success, variant: LooviButtonVariant.outline),
        LooviButton(key: const Key('t'), label: 'T', onPressed: () {}, variant: LooviButtonVariant.text, showIcon: true),
      ]),
    );
    expect(_decoration(tester, of: find.byKey(const Key('d'))).color, _t.color.actionsDanger);
    expect(_labelColor(tester, 'D'), _t.color.backgroundSurface0);
    expect((_decoration(tester, of: find.byKey(const Key('s'))).border! as Border).top.color, _t.color.borderFeedbackSuccess);
    expect(_labelColor(tester, 'S'), _t.feedback.success);
    final icon = tester.widget<LooviIcon>(find.descendant(of: find.byKey(const Key('t')), matching: find.byType(LooviIcon)));
    expect(icon.color, _t.text.primary);
  });

  testWidgets('keyboard focus shows the focus ring and Enter activates', (tester) async {
    var taps = 0;
    final node = FocusNode();
    addTearDown(node.dispose);
    FocusManager.instance.highlightStrategy = FocusHighlightStrategy.alwaysTraditional;
    addTearDown(() => FocusManager.instance.highlightStrategy = FocusHighlightStrategy.automatic);
    await pumpLoovi(tester, Align(alignment: Alignment.topLeft, child: LooviButton(label: 'Ok', onPressed: () => taps++, focusNode: node)));
    node.requestFocus();
    await tester.pump();
    await tester.pump(); // focus highlight callback runs post-frame
    final ring = find.descendant(
      of: find.byType(LooviButton),
      matching: find.byWidgetPredicate((w) =>
          w is DecoratedBox &&
          w.position == DecorationPosition.foreground &&
          ((w.decoration as BoxDecoration).border as Border?)?.top.color == _t.interactive.focus),
    );
    expect(ring, findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('golden: matrix', (tester) async {
    await pumpGolden(tester, _still(const ButtonMatrix()), height: 1400);
    await expectLater(find.byType(ButtonMatrix), matchesGoldenFile('../goldens/button_matrix.png'));
  });
}
