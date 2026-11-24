import 'package:loovi_ds/loovi_ds.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

/// Freezes the spinner (reduce-motion path) so pumpAndSettle settles.
Widget _still(Widget child) => Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: true),
        child: child,
      ),
    );

/// Story "Sizes": lg | md | sm | xs. Same as the Widgetbook story.
class LoadingSpinnerSizes extends StatelessWidget {
  const LoadingSpinnerSizes({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: Padding(
        padding: EdgeInsets.all(t.spacing.s200),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (final s in LooviLoadingSpinnerSize.values) ...[
              LooviLoadingSpinner(size: s),
              SizedBox(width: t.spacing.s300),
            ],
          ],
        ),
      ),
    );
  }
}

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('sizes follow the seed map 80 / 64 / 32 / 24 (spacing tokens)', (tester) async {
    await pumpLoovi(
      tester,
      _still(Row(children: [
        for (final s in LooviLoadingSpinnerSize.values) LooviLoadingSpinner(key: Key(s.name), size: s),
      ])),
    );
    Size sizeOf(LooviLoadingSpinnerSize s) =>
        tester.getSize(find.descendant(of: find.byKey(Key(s.name)), matching: find.byType(SizedBox)).first);
    expect(sizeOf(LooviLoadingSpinnerSize.lg), Size.square(_t.spacing.s1000));
    expect(sizeOf(LooviLoadingSpinnerSize.md), Size.square(_t.spacing.s800));
    expect(sizeOf(LooviLoadingSpinnerSize.sm), Size.square(_t.spacing.s400));
    expect(sizeOf(LooviLoadingSpinnerSize.xs), Size.square(_t.spacing.s300));
    expect(LooviLoadingSpinner.boxFor(_t, LooviLoadingSpinnerSize.lg), 80);
  });

  test('ring thickness matches the Figma geometry', () {
    expect(80 * LooviLoadingSpinner.strokeFactorFor(LooviLoadingSpinnerSize.lg), closeTo(11.2, 0.001));
    expect(64 * LooviLoadingSpinner.strokeFactorFor(LooviLoadingSpinnerSize.md), closeTo(8.96, 0.001));
    expect(32 * LooviLoadingSpinner.strokeFactorFor(LooviLoadingSpinnerSize.sm), closeTo(5.76, 0.001));
    expect(24 * LooviLoadingSpinner.strokeFactorFor(LooviLoadingSpinnerSize.xs), closeTo(4.32, 0.001));
  });

  testWidgets('dimension overrides the box (resized instances)', (tester) async {
    await pumpLoovi(
      tester,
      _still(const Align(
        alignment: Alignment.topLeft,
        child: LooviLoadingSpinner(size: LooviLoadingSpinnerSize.sm, dimension: 20),
      )),
    );
    expect(tester.getSize(find.byType(LooviLoadingSpinner)), const Size(20, 20));
  });

  testWidgets('animates when motion is allowed; static under reduce-motion', (tester) async {
    await tester.pumpWidget(looviHarness(const LooviLoadingSpinner()));
    final rotation = find.descendant(of: find.byType(LooviLoadingSpinner), matching: find.byType(RotationTransition));
    final before = tester.widget<RotationTransition>(rotation).turns.value;
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.widget<RotationTransition>(rotation).turns.value, isNot(before));
    // Turns complete in the first 67 % of 1.2 s, then hold at 1.
    await tester.pump(const Duration(milliseconds: 700));
    expect(tester.widget<RotationTransition>(rotation).turns.value, 1.0);

    await tester.pumpWidget(looviHarness(_still(const LooviLoadingSpinner())));
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.widget<RotationTransition>(rotation).turns.value, 0);
  });

  testWidgets('semantics: polite live region "Carregando"; decorative is hidden', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(
      tester,
      _still(const Column(children: [
        LooviLoadingSpinner(key: Key('a')),
        LooviLoadingSpinner(key: Key('b'), decorative: true),
      ])),
    );
    final a = tester.getSemantics(find.byKey(const Key('a')));
    expect(a.label, 'Carregando');
    expect(a.flagsCollection.isLiveRegion, isTrue);
    expect(find.bySemanticsLabel('Carregando'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('golden: sizes', (tester) async {
    await pumpGolden(tester, _still(const LoadingSpinnerSizes()), height: 120);
    await expectLater(find.byType(LoadingSpinnerSizes), matchesGoldenFile('../goldens/loading_spinner_sizes.png'));
  });
}
