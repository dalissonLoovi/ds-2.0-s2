import 'dart:ui' show Tristate;

import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

/// Story "Flow": a 4-step horizontal stepper (completed → current → pending)
/// plus an all-pending row. Same as the Widgetbook story.
class StepperPrimaryFlow extends StatelessWidget {
  const StepperPrimaryFlow({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: Padding(
        padding: EdgeInsets.all(t.spacing.s200),
        child: Column(
          children: [
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: LooviStepperPrimary(
                    label: 'Dados',
                    trail: LooviStepperPrimaryTrail.right,
                    trailState: LooviStepperPrimaryTrailState.right,
                  ),
                ),
                Expanded(
                  child: LooviStepperPrimary(label: 'Veículo', trailState: LooviStepperPrimaryTrailState.both),
                ),
                Expanded(
                  child: LooviStepperPrimary(
                    label: 'Vistoria',
                    status: LooviStepperPrimaryStatus.current,
                    trailState: LooviStepperPrimaryTrailState.left,
                  ),
                ),
                Expanded(
                  child: LooviStepperPrimary(
                    label: 'Pagamento',
                    status: LooviStepperPrimaryStatus.pending,
                    trail: LooviStepperPrimaryTrail.left,
                  ),
                ),
              ],
            ),
            SizedBox(height: t.spacing.s300),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: LooviStepperPrimary(
                    label: 'Dados',
                    status: LooviStepperPrimaryStatus.current,
                    trail: LooviStepperPrimaryTrail.right,
                  ),
                ),
                Expanded(child: LooviStepperPrimary(label: 'Veículo', status: LooviStepperPrimaryStatus.pending)),
                Expanded(
                  child: LooviStepperPrimary(
                    label: 'Pagamento',
                    status: LooviStepperPrimaryStatus.pending,
                    trail: LooviStepperPrimaryTrail.left,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Color? _trailColor(WidgetTester tester, String key) {
  final box = find.descendant(of: find.byKey(ValueKey(key)), matching: find.byType(DecoratedBox));
  if (box.evaluate().isEmpty) return null;
  return (tester.widget<DecoratedBox>(box).decoration as BoxDecoration).color;
}

void main() {
  setUpAll(loadGoldenFonts);

  for (final s in LooviStepperPrimaryStatus.values) {
    testWidgets('status=${s.name}: icon, icon color, label color', (tester) async {
      await pumpLoovi(tester, LooviStepperPrimary(label: 'Etapa', status: s));
      final icon = tester.widget<LooviIcon>(find.byType(LooviIcon));
      expect(icon.name, switch (s) {
        LooviStepperPrimaryStatus.completed => LooviIcons.circleCheckFilled,
        LooviStepperPrimaryStatus.current => LooviIcons.circleDotFilled,
        LooviStepperPrimaryStatus.pending => LooviIcons.circleOutline,
      });
      expect(icon.size, _t.spacing.s300);
      expect(icon.color, s == LooviStepperPrimaryStatus.pending ? _t.text.secondary : _t.color.actionsPrimary);
      final txt = tester.widget<Text>(find.text('Etapa'));
      expect(txt.style!.color, switch (s) {
        LooviStepperPrimaryStatus.completed => _t.color.actionsPrimary,
        LooviStepperPrimaryStatus.current => _t.text.primary,
        LooviStepperPrimaryStatus.pending => _t.text.secondary,
      });
      expect(txt.style!.fontSize, _t.typography.bodyMediumMedium.fontSize);
      expect(txt.style!.fontWeight, _t.typography.bodyMediumMedium.fontWeight);
    });
  }

  testWidgets('trails: active actions/primary, inactive border/2, absent side unpainted but keeps space', (tester) async {
    await pumpLoovi(
      tester,
      const LooviStepperPrimary(label: 'A', trailState: LooviStepperPrimaryTrailState.left),
    );
    expect(_trailColor(tester, 'leftTrail'), _t.color.actionsPrimary);
    expect(_trailColor(tester, 'rightTrail'), _t.color.border2);
    expect(tester.getSize(find.byKey(const ValueKey('leftTrail'))).height, _t.borderWidth.s025);

    await pumpLoovi(tester, const LooviStepperPrimary(label: 'A', trail: LooviStepperPrimaryTrail.left));
    expect(_trailColor(tester, 'rightTrail'), isNull);
    final root = tester.getRect(find.byType(LooviStepperPrimary));
    expect(tester.getRect(find.byType(LooviIcon)).center.dx, closeTo(root.center.dx, 0.01));
  });

  testWidgets('layout: trail row spacing/300, gap spacing/050, icon gaps spacing/100', (tester) async {
    await pumpLoovi(tester, const LooviStepperPrimary(label: 'Etapa'));
    final icon = tester.getRect(find.byType(LooviIcon));
    expect(tester.getRect(find.text('Etapa')).top - icon.bottom, _t.spacing.s050);
    expect(icon.left - tester.getRect(find.byKey(const ValueKey('leftTrail'))).right, _t.spacing.s100);
  });

  testWidgets('semantics: "{label}, {status}"; not focusable', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const LooviStepperPrimary(label: 'Vistoria', status: LooviStepperPrimaryStatus.current));
    final s = tester.getSemantics(find.byType(LooviStepperPrimary));
    expect(s.label, 'Vistoria, Etapa atual');
    expect(s.flagsCollection.isFocused, Tristate.none);
    handle.dispose();
  });

  test('asserts the sparse matrix', () {
    expect(
      () => LooviStepperPrimary(
        label: 'x',
        trail: LooviStepperPrimaryTrail.left,
        trailState: LooviStepperPrimaryTrailState.right,
      ),
      throwsAssertionError,
    );
    expect(
      () => LooviStepperPrimary(
        label: 'x',
        status: LooviStepperPrimaryStatus.pending,
        trailState: LooviStepperPrimaryTrailState.left,
      ),
      throwsAssertionError,
    );
    expect(
      () => LooviStepperPrimary(
        label: 'x',
        status: LooviStepperPrimaryStatus.current,
        trailState: LooviStepperPrimaryTrailState.both,
      ),
      throwsAssertionError,
    );
  });

  testWidgets('textScaler 2: long label wraps, no overflow', (tester) async {
    await pumpLoovi(
      tester,
      const Row(children: [
        Expanded(child: LooviStepperPrimary(label: 'Dados do veículo', trail: LooviStepperPrimaryTrail.right)),
        Expanded(child: LooviStepperPrimary(label: 'Pagamento', status: LooviStepperPrimaryStatus.current, trail: LooviStepperPrimaryTrail.left)),
      ]),
      textScale: 2,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('golden: flow', (tester) async {
    await pumpGolden(tester, const StepperPrimaryFlow(), height: 180);
    await expectLater(find.byType(StepperPrimaryFlow), matchesGoldenFile('../goldens/stepper_primary_flow.png'));
  });
}
