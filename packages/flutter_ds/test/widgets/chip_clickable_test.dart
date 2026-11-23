import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

/// The chip paint (background DecoratedBox with the full radius).
BoxDecoration _decoration(WidgetTester tester, [Finder? chip]) {
  final boxes = tester.widgetList<DecoratedBox>(
    find.descendant(of: chip ?? find.byType(LooviChipClickable), matching: find.byType(DecoratedBox)),
  );
  return boxes
      .map((b) => b.decoration)
      .whereType<BoxDecoration>()
      .lastWhere((d) => d.borderRadius != null);
}

Color _labelColor(WidgetTester tester, String label) => tester.widget<Text>(find.text(label)).style!.color!;

/// Expected Plus Darker (LINEAR_BURN) composite: dst + src - 1 per channel.
Color _burn(Color dst, Color src) => Color.from(
      alpha: 1,
      red: (dst.r + src.r - 1).clamp(0, 1).toDouble(),
      green: (dst.g + src.g - 1).clamp(0, 1).toDouble(),
      blue: (dst.b + src.b - 1).clamp(0, 1).toDouble(),
    );

/// Story "Matrix": intent × (default, selected) + disabled, sm and md.
class ChipClickableMatrix extends StatelessWidget {
  const ChipClickableMatrix({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget chip(LooviChipClickableSize size, LooviChipClickableIntent intent,
            {bool selected = false, bool disabled = false, bool icon = false, bool delete = false}) =>
        LooviChipClickable(
          label: 'Label',
          size: size,
          intent: intent,
          selected: selected,
          disabled: disabled,
          showLeadingIcon: icon,
          leadingIcon: LooviIcons.circlePlusOutline,
          showDeleteAction: delete,
          onPressed: () {},
        );
    return Padding(
      padding: EdgeInsets.all(t.spacing.s100),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        for (final size in LooviChipClickableSize.values) ...[
          for (final intent in LooviChipClickableIntent.values)
            Row(children: [
              chip(size, intent),
              SizedBox(width: t.spacing.s100),
              chip(size, intent, selected: true),
              SizedBox(width: t.spacing.s100),
              chip(size, intent, icon: true, delete: true),
            ]),
          Row(children: [
            chip(size, LooviChipClickableIntent.system, disabled: true),
            SizedBox(width: t.spacing.s100),
            chip(size, LooviChipClickableIntent.system, disabled: true, icon: true, delete: true),
          ]),
        ],
      ]),
    );
  }
}

void main() {
  setUpAll(loadGoldenFonts);

  final base = <LooviChipClickableIntent, Color?>{
    LooviChipClickableIntent.info: _t.color.backgroundFeedbackPrimaryInfo,
    LooviChipClickableIntent.system: _t.color.backgroundFeedbackPrimarySystem,
    LooviChipClickableIntent.success: _t.color.backgroundFeedbackPrimarySuccess,
    LooviChipClickableIntent.warning: _t.color.backgroundFeedbackPrimaryWarning,
    LooviChipClickableIntent.danger: _t.interactive.errorSurface,
    LooviChipClickableIntent.soft: _t.color.backgroundSurface0,
    LooviChipClickableIntent.brand: _t.color.backgroundSurfaceBrand,
    LooviChipClickableIntent.outline: null,
  };

  group('LooviChipClickable paint by token', () {
    for (final e in base.entries) {
      testWidgets('${e.key.name}: default + selected fill, label, stroke', (tester) async {
        await pumpLoovi(tester, Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          LooviChipClickable(key: const Key('d'), label: 'Default', intent: e.key, onPressed: () {}),
          LooviChipClickable(key: const Key('s'), label: 'Selected', intent: e.key, selected: true, onPressed: () {}),
        ]));
        final d = _decoration(tester, find.byKey(const Key('d')));
        final s = _decoration(tester, find.byKey(const Key('s')));
        expect(d.color, e.value);
        expect(s.color, e.value == null ? _t.interactive.selected : _burn(e.value!, _t.interactive.selected));
        final stroked = e.key == LooviChipClickableIntent.outline || e.key == LooviChipClickableIntent.soft;
        if (stroked) {
          final side = (d.border! as Border).top;
          expect(side.color, _t.color.border2);
          expect(side.width, _t.borderWidth.s012);
        } else {
          expect(d.border, isNull);
        }
        expect(d.borderRadius, BorderRadius.circular(_t.radius.full));
        expect(
          _labelColor(tester, 'Default'),
          e.key == LooviChipClickableIntent.brand ? _t.text.onColor : _t.text.primary,
        );
        expect(tester.widget<Text>(find.text('Default')).style!.fontSize, _t.typography.bodySmallMedium.fontSize);
      });
    }

    testWidgets('pressed: interactive/pressed Plus Darker over base while held', (tester) async {
      await pumpLoovi(tester, Align(
        alignment: Alignment.topLeft,
        child: LooviChipClickable(label: 'Info', intent: LooviChipClickableIntent.info, onPressed: () {}),
      ));
      final gesture = await tester.startGesture(tester.getCenter(find.text('Info')));
      await tester.pump();
      expect(_decoration(tester).color, _burn(_t.color.backgroundFeedbackPrimaryInfo, _t.interactive.pressed));
      await gesture.up();
      await tester.pump();
      expect(_decoration(tester).color, _t.color.backgroundFeedbackPrimaryInfo);
    });

    testWidgets('outline pressed replaces the transparent base', (tester) async {
      await pumpLoovi(tester, Align(alignment: Alignment.topLeft, child: LooviChipClickable(label: 'O', onPressed: () {})));
      final gesture = await tester.startGesture(tester.getCenter(find.text('O')));
      await tester.pump();
      expect(_decoration(tester).color, _t.interactive.pressed);
      await gesture.up();
    });
  });

  testWidgets('tap fires onPressed', (tester) async {
    var taps = 0;
    await pumpLoovi(tester, Align(alignment: Alignment.topLeft, child: LooviChipClickable(label: 'Tap', onPressed: () => taps++)));
    await tester.tap(find.text('Tap'));
    expect(taps, 1);
  });

  testWidgets('disabled: no tap, disabled-surface + text/placeholder, no stroke', (tester) async {
    var taps = 0;
    await pumpLoovi(tester, Align(
      alignment: Alignment.topLeft,
      child: LooviChipClickable(label: 'Off', disabled: true, onPressed: () => taps++),
    ));
    await tester.tap(find.text('Off'), warnIfMissed: false);
    expect(taps, 0);
    expect(_decoration(tester).color, _t.interactive.disabledSurface);
    expect(_decoration(tester).border, isNull);
    expect(_labelColor(tester, 'Off'), _t.text.placeholder);
  });

  testWidgets('onPressed null = disabled', (tester) async {
    await pumpLoovi(tester, const Align(alignment: Alignment.topLeft, child: LooviChipClickable(label: 'Null', onPressed: null)));
    expect(_decoration(tester).color, _t.interactive.disabledSurface);
  });

  testWidgets('sizes: paint sm 25 / md 40; touch target ≥ 48; icon sm 20, md 24', (tester) async {
    await pumpLoovi(tester, Align(
      alignment: Alignment.topLeft,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        LooviChipClickable(key: const Key('sm'), label: 'S', size: LooviChipClickableSize.sm, showLeadingIcon: true, onPressed: () {}),
        LooviChipClickable(key: const Key('md'), label: 'M', size: LooviChipClickableSize.md, showLeadingIcon: true, onPressed: () {}),
      ]),
    ));
    Size paint(String k) => tester.getSize(find
        .descendant(of: find.byKey(Key(k)), matching: find.byType(DecoratedBox))
        .last);
    // sm: max(icon 20, label 17) + 2 × spacing/050 = 28 with icon.
    expect(paint('sm').height, _t.spacing.s250 + 2 * _t.spacing.s050);
    expect(paint('md').height, _t.spacing.s500);
    expect(tester.getSize(find.byKey(const Key('sm'))).height, greaterThanOrEqualTo(_t.spacing.s600));
    expect(tester.getSize(find.byKey(const Key('md'))).height, greaterThanOrEqualTo(_t.spacing.s600));
    final icons = tester.widgetList<LooviIcon>(find.byType(LooviIcon)).toList();
    expect(icons[0].size, _t.spacing.s250);
    expect(icons[1].size, _t.spacing.s300);
  });

  testWidgets('tap on the 48 dp area outside the paint still fires', (tester) async {
    var taps = 0;
    await pumpLoovi(tester, Align(
      alignment: Alignment.topLeft,
      child: LooviChipClickable(label: 'Hit', size: LooviChipClickableSize.sm, onPressed: () => taps++),
    ));
    await tester.tapAt(tester.getTopLeft(find.byType(LooviChipClickable)) + const Offset(2, 2));
    expect(taps, 1);
  });

  testWidgets('delete action: x-outline 16, onDelete, accessible name', (tester) async {
    final handle = tester.ensureSemantics();
    var deletes = 0;
    var taps = 0;
    await pumpLoovi(tester, Align(
      alignment: Alignment.topLeft,
      child: LooviChipClickable(
        label: 'Filtro',
        showDeleteAction: true,
        onDelete: () => deletes++,
        onPressed: () => taps++,
      ),
    ));
    final x = find.byWidgetPredicate((w) => w is LooviIcon && w.name == LooviIcons.xOutline);
    expect(tester.widget<LooviIcon>(x).size, _t.spacing.s200);
    await tester.tap(x);
    expect(deletes, 1);
    expect(taps, 0);
    expect(find.bySemanticsLabel('Remover Filtro'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('semantics: button with label, selected flag, enabled state', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, Column(children: [
      LooviChipClickable(label: 'Sel', selected: true, onPressed: () {}),
      const LooviChipClickable(label: 'Dis', disabled: true, onPressed: null),
    ]));
    expect(
      tester.getSemantics(find.bySemanticsLabel('Sel')),
      isSemantics(label: 'Sel', isButton: true, isSelected: true, isEnabled: true, hasTapAction: true),
    );
    expect(
      tester.getSemantics(find.bySemanticsLabel('Dis')),
      isSemantics(label: 'Dis', isButton: true, isEnabled: false),
    );
    handle.dispose();
  });

  testWidgets('golden: matrix', (tester) async {
    await pumpGolden(tester, const ChipClickableMatrix(), height: 1000);
    await expectLater(find.byType(ChipClickableMatrix), matchesGoldenFile('../goldens/chip_clickable_matrix.png'));
  });
}
