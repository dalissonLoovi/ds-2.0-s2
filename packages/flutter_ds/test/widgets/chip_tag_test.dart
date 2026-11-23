import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

BoxDecoration _decoration(WidgetTester tester) {
  final box = tester.widget<DecoratedBox>(
    find.descendant(of: find.byType(LooviChipTag), matching: find.byType(DecoratedBox)).first,
  );
  return box.decoration as BoxDecoration;
}

Color _labelColor(WidgetTester tester, String label) => tester.widget<Text>(find.text(label)).style!.color!;

const _statusIntents = [
  LooviChipTagIntent.info,
  LooviChipTagIntent.system,
  LooviChipTagIntent.success,
  LooviChipTagIntent.warning,
  LooviChipTagIntent.danger,
];

/// Story "Matrix": intent × emphasis × state, sm and md, hug and fill.
class ChipTagMatrix extends StatelessWidget {
  const ChipTagMatrix({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget row(LooviChipTagSize size, LooviChipTagIntent intent,
        {LooviChipTagEmphasis emphasis = LooviChipTagEmphasis.primary, bool disabled = false}) {
      return Padding(
        padding: EdgeInsets.only(bottom: t.spacing.s100),
        child: Row(children: [
          LooviChipTag(label: 'Label', size: size, intent: intent, emphasis: emphasis, disabled: disabled),
          SizedBox(width: t.spacing.s200),
          LooviChipTag(
            label: 'Label',
            size: size,
            intent: intent,
            emphasis: emphasis,
            disabled: disabled,
            showLeadingIcon: true,
          ),
          SizedBox(width: t.spacing.s200),
          Expanded(
            child: LooviChipTag(
              label: 'Label',
              size: size,
              intent: intent,
              emphasis: emphasis,
              disabled: disabled,
              width: LooviChipTagWidth.fill,
            ),
          ),
        ]),
      );
    }

    return Padding(
      padding: EdgeInsets.all(t.spacing.s100),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        for (final size in LooviChipTagSize.values) ...[
          for (final intent in LooviChipTagIntent.values) row(size, intent),
          for (final intent in _statusIntents) row(size, intent, emphasis: LooviChipTagEmphasis.secondary),
          row(size, LooviChipTagIntent.system, disabled: true),
        ],
      ]),
    );
  }
}

void main() {
  setUpAll(loadGoldenFonts);

  group('LooviChipTag paint by token', () {
    final primary = <LooviChipTagIntent, Color>{
      LooviChipTagIntent.info: _t.color.backgroundFeedbackPrimaryInfo,
      LooviChipTagIntent.system: _t.color.backgroundFeedbackPrimarySystem,
      LooviChipTagIntent.success: _t.color.backgroundFeedbackPrimarySuccess,
      LooviChipTagIntent.warning: _t.color.backgroundFeedbackPrimaryWarning,
      LooviChipTagIntent.danger: _t.color.backgroundFeedbackPrimaryDanger,
      LooviChipTagIntent.brand: _t.color.backgroundSurfaceBrandStrong,
    };
    for (final e in primary.entries) {
      testWidgets('primary ${e.key.name} → fill token', (tester) async {
        await pumpLoovi(tester, Align(alignment: Alignment.topLeft, child: LooviChipTag(label: 'Tag', intent: e.key, emphasis: LooviChipTagEmphasis.primary)));
        expect(_decoration(tester).color, e.value);
        expect(_decoration(tester).border, isNull);
        expect(
          _labelColor(tester, 'Tag'),
          e.key == LooviChipTagIntent.brand ? _t.text.onColor : _t.text.primary,
        );
      });
    }

    final secondary = <LooviChipTagIntent, Color>{
      LooviChipTagIntent.info: _t.color.backgroundFeedbackSecondaryInfo,
      LooviChipTagIntent.system: _t.color.backgroundFeedbackSecondarySystem,
      LooviChipTagIntent.success: _t.color.backgroundFeedbackSecondarySuccess,
      LooviChipTagIntent.warning: _t.color.backgroundFeedbackSecondaryWarning,
      LooviChipTagIntent.danger: _t.color.backgroundFeedbackSecondaryDanger,
    };
    for (final e in secondary.entries) {
      testWidgets('secondary ${e.key.name} → fill token + text/primary', (tester) async {
        await pumpLoovi(
          tester,
          Align(alignment: Alignment.topLeft, child: LooviChipTag(label: 'Tag', intent: e.key, emphasis: LooviChipTagEmphasis.secondary)),
        );
        expect(_decoration(tester).color, e.value);
        expect(_labelColor(tester, 'Tag'), _t.text.primary);
      });
    }

    testWidgets('default emphasis is secondary (soft); emphasis is ignored by outline/brand', (tester) async {
      expect(const LooviChipTag(label: 'x').emphasis, LooviChipTagEmphasis.secondary);
      await pumpLoovi(tester, const Align(alignment: Alignment.topLeft, child: LooviChipTag(label: 'Info')));
      expect(_decoration(tester).color, _t.color.backgroundFeedbackSecondaryInfo);
      await pumpLoovi(tester, const Align(
        alignment: Alignment.topLeft,
        child: LooviChipTag(label: 'Tag', intent: LooviChipTagIntent.brand, emphasis: LooviChipTagEmphasis.secondary),
      ));
      expect(_decoration(tester).color, _t.color.backgroundSurfaceBrandStrong);
    });

    testWidgets('outline → no fill, border/2 stroke at border/width/012', (tester) async {
      await pumpLoovi(tester, const Align(alignment: Alignment.topLeft, child: LooviChipTag(label: 'Tag', intent: LooviChipTagIntent.outline)));
      final d = _decoration(tester);
      expect(d.color, isNull);
      final side = (d.border! as Border).top;
      expect(side.color, _t.color.border2);
      expect(side.width, _t.borderWidth.s012);
      expect(d.borderRadius, BorderRadius.circular(_t.radius.full));
    });

    testWidgets('disabled → border/2 fill + text/secondary', (tester) async {
      await pumpLoovi(tester, const Align(alignment: Alignment.topLeft, child: LooviChipTag(label: 'Tag', intent: LooviChipTagIntent.system, disabled: true)));
      expect(_decoration(tester).color, _t.color.border2);
      expect(_labelColor(tester, 'Tag'), _t.text.secondary);
    });
  });

  testWidgets('sizes: sm 24 tall body/small/medium, md 40 tall body/medium/medium', (tester) async {
    await pumpLoovi(tester, const Align(
      alignment: Alignment.topLeft,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        LooviChipTag(key: Key('sm'), label: 'Small', size: LooviChipTagSize.sm),
        LooviChipTag(key: Key('md'), label: 'Medium', size: LooviChipTagSize.md),
      ]),
    ));
    expect(tester.getSize(find.byKey(const Key('sm'))).height, _t.spacing.s300);
    expect(tester.getSize(find.byKey(const Key('md'))).height, _t.spacing.s500);
    expect(tester.widget<Text>(find.text('Small')).style!.fontSize, _t.typography.bodySmallMedium.fontSize);
    expect(tester.widget<Text>(find.text('Medium')).style!.fontSize, _t.typography.bodyMediumMedium.fontSize);
  });

  testWidgets('width=fill takes the available width', (tester) async {
    await pumpLoovi(tester, const LooviChipTag(key: Key('fill'), label: 'Fill', width: LooviChipTagWidth.fill));
    expect(tester.getSize(find.byKey(const Key('fill'))).width, 390);
  });

  testWidgets('leading icon: sm 20, md 32 (Figma frames)', (tester) async {
    await pumpLoovi(tester, const Align(
      alignment: Alignment.topLeft,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        LooviChipTag(label: 'A', size: LooviChipTagSize.sm, showLeadingIcon: true),
        LooviChipTag(label: 'B', size: LooviChipTagSize.md, showLeadingIcon: true),
      ]),
    ));
    final icons = tester.widgetList<LooviIcon>(find.byType(LooviIcon)).toList();
    expect(icons[0].size, _t.spacing.s250);
    expect(icons[1].size, _t.spacing.s400);
  });

  testWidgets('semantics: label exposed, not a button, not focusable; decorative hides it', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const Column(children: [
      LooviChipTag(label: 'Ativo'),
      LooviChipTag(label: 'Oculto', decorative: true),
    ]));
    expect(tester.getSemantics(find.bySemanticsLabel('Ativo')), isSemantics(label: 'Ativo', isButton: false, isFocusable: false));
    expect(find.bySemanticsLabel('Oculto'), findsNothing);
    expect(find.descendant(of: find.byType(LooviChipTag), matching: find.byType(GestureDetector)), findsNothing);
    handle.dispose();
  });

  testWidgets('textScaler 2: sm grows past 24 instead of clipping the label', (tester) async {
    await pumpLoovi(
      tester,
      const Align(alignment: Alignment.topLeft, child: LooviChipTag(key: Key('sm'), label: 'Ativo', size: LooviChipTagSize.sm)),
      textScale: 2,
    );
    expect(tester.takeException(), isNull);
    final chip = tester.getRect(find.byKey(const Key('sm')));
    final label = tester.getRect(find.text('Ativo'));
    expect(chip.height, greaterThan(_t.spacing.s300));
    expect(label.top, greaterThanOrEqualTo(chip.top));
    expect(label.bottom, lessThanOrEqualTo(chip.bottom));
  });

  testWidgets('golden: matrix', (tester) async {
    await pumpGolden(tester, const ChipTagMatrix(), height: 1100);
    await expectLater(find.byType(ChipTagMatrix), matchesGoldenFile('../goldens/chip_tag_matrix.png'));
  });
}
