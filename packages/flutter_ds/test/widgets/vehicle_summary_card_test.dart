import 'package:loovi_ds/loovi_ds.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

BoxDecoration _cardDecoration(WidgetTester tester) => tester
    .widget<DecoratedBox>(find.descendant(of: find.byType(LooviVehicleSummaryCard), matching: find.byType(DecoratedBox)).first)
    .decoration as BoxDecoration;

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('standard/active: texts, outline sm ChipTag "Ativo" with success dot', (tester) async {
    await pumpLoovi(tester, const LooviVehicleSummaryCard(brandModel: 'Marca', model: 'Modelo', plate: 'ABC1D23'));
    expect(find.text('ABC1D23'), findsOneWidget);
    final chip = tester.widget<LooviChipTag>(find.byType(LooviChipTag));
    expect(chip.label, 'Ativo');
    expect(chip.size, LooviChipTagSize.sm);
    expect(chip.intent, LooviChipTagIntent.outline);
    final dot = tester.widget<LooviIcon>(find.byType(LooviIcon));
    expect(dot.name, LooviIcons.circleDotFilled);
    expect(dot.color, _t.color.backgroundFeedbackPrimarySuccess);
    final deco = _cardDecoration(tester);
    expect(deco.color, _t.color.backgroundSurface0);
    expect(deco.borderRadius, BorderRadius.circular(_t.radius.s400));
    expect(tester.widget<Text>(find.text('ABC1D23')).style!.color, _t.text.secondary);
  });

  testWidgets('standard/inactive: "Inativo" with warning dot (not danger)', (tester) async {
    await pumpLoovi(tester, const LooviVehicleSummaryCard(status: LooviVehicleSummaryCardStatus.inactive, plate: 'ABC1D23'));
    expect(find.text('Inativo'), findsOneWidget);
    expect(tester.widget<LooviIcon>(find.byType(LooviIcon)).color, _t.color.backgroundFeedbackPrimaryWarning);
  });

  testWidgets('showStatus=false hides the chip', (tester) async {
    await pumpLoovi(tester, const LooviVehicleSummaryCard(showStatus: false, plate: 'ABC1D23'));
    expect(find.byType(LooviChipTag), findsNothing);
  });

  testWidgets('secondary: brand-muted surface, radius/300, on-color texts, no chip, not a button', (tester) async {
    final handle = tester.ensureSemantics();
    var taps = 0;
    await pumpLoovi(
      tester,
      LooviVehicleSummaryCard(
        key: const Key('card'),
        appearance: LooviVehicleSummaryCardAppearance.secondary,
        title: 'Marca Modelo • 2020',
        plate: 'ABC1D23',
        illustration: LooviVehicleIllustration.suv,
        onPressed: () => taps++,
      ),
    );
    expect(find.byType(LooviChipTag), findsNothing);
    final deco = _cardDecoration(tester);
    expect(deco.color, _t.color.backgroundSurfaceBrandMuted);
    expect(deco.borderRadius, BorderRadius.circular(_t.radius.s300));
    expect(tester.widget<Text>(find.text('Marca Modelo • 2020')).style!.color, _t.text.onColor);
    await tester.tap(find.byKey(const Key('card')));
    expect(taps, 0);
    final node = tester.getSemantics(find.byKey(const Key('card')));
    expect(node.label, 'Marca Modelo • 2020, ABC1D23');
    expect(node.getSemanticsData().flagsCollection.isButton, isFalse);
    handle.dispose();
  });

  testWidgets('standard with onPressed: button semantics, tap + pressed wash', (tester) async {
    final handle = tester.ensureSemantics();
    var taps = 0;
    await pumpLoovi(tester, LooviVehicleSummaryCard(key: const Key('card'), plate: 'ABC1D23', onPressed: () => taps++));
    final node = tester.getSemantics(find.byKey(const Key('card')));
    expect(node.label, 'Marca Modelo, ABC1D23, Ativo');
    expect(node.getSemanticsData().flagsCollection.isButton, isTrue);
    final gesture = await tester.startGesture(tester.getCenter(find.byKey(const Key('card'))));
    await tester.pump();
    final boxes = tester.widgetList<DecoratedBox>(find.descendant(of: find.byKey(const Key('card')), matching: find.byType(DecoratedBox)));
    expect(boxes.any((d) => (d.decoration as BoxDecoration).color == _t.interactive.pressed), isTrue);
    await gesture.up();
    await tester.pump();
    expect(taps, 1);
    expect(tester.getSize(find.byKey(const Key('card'))).height, greaterThanOrEqualTo(48));
    handle.dispose();
  });

  testWidgets('illustration enum maps to the packaged SVG assets', (tester) async {
    for (final i in LooviVehicleIllustration.values) {
      await pumpLoovi(tester, Align(alignment: Alignment.topLeft, child: LooviVehicleIllustrationView(i)));
      final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));
      expect((svg.bytesLoader as SvgAssetLoader).assetName, 'assets/illustrations/vehicle/${i.name}.svg');
      expect(tester.getSize(find.byType(SvgPicture)), const Size(52, 52));
    }
  });

  testWidgets('golden: appearance x status', (tester) async {
    await pumpGolden(
      tester,
      Padding(
        key: const Key('golden'),
        padding: EdgeInsets.all(_t.spacing.s200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const LooviVehicleSummaryCard(plate: 'ABC1D23'),
            SizedBox(height: _t.spacing.s100),
            const LooviVehicleSummaryCard(status: LooviVehicleSummaryCardStatus.inactive, plate: 'ABC1D23', illustration: LooviVehicleIllustration.van),
            SizedBox(height: _t.spacing.s100),
            const LooviVehicleSummaryCard(showStatus: false, plate: 'ABC1D23', illustration: LooviVehicleIllustration.suv),
            SizedBox(height: _t.spacing.s100),
            const LooviVehicleSummaryCard(appearance: LooviVehicleSummaryCardAppearance.secondary, title: 'Marca Modelo • 2020', plate: 'ABC1D23'),
          ],
        ),
      ),
      height: 340,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/vehicle_summary_card_variants.png'));
  });
}
