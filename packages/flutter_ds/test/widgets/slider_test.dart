import 'package:flutter/semantics.dart' show SemanticsAction, SemanticsValidationResult;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

/// Every seed status (hover does not exist on the app; focus/active = the
/// autofocused track). Same as the Widgetbook story "Statuses".
class SliderStatuses extends StatelessWidget {
  const SliderStatuses({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    void noop(double _) {}
    final gap = SizedBox(height: t.spacing.s300);
    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: Padding(
        padding: EdgeInsets.all(t.spacing.s200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LooviSlider(value: 40, onChanged: noop, label: 'Enabled'),
            gap,
            LooviSlider(value: 50, onChanged: noop, label: 'Focus / active', autofocus: true),
            gap,
            LooviSlider(value: 60, onChanged: noop, label: 'Error', errorText: 'Error message goes here'),
            gap,
            LooviSlider(value: 60, onChanged: noop, label: 'Warning', warningText: 'Warning message goes here'),
            gap,
            LooviSlider(value: 50, onChanged: noop, label: 'Disabled', enabled: false),
            gap,
            LooviSlider(value: 50, onChanged: noop, label: 'Read-only', readOnly: true),
            gap,
            LooviSlider(value: 50, onChanged: noop, label: 'Skeleton', skeleton: true),
          ],
        ),
      ),
    );
  }
}

/// Controlled harness: keeps the value and records callbacks.
class _Host extends StatefulWidget {
  const _Host({this.enabled = true, this.readOnly = false, this.focusNode});

  final bool enabled;
  final bool readOnly;
  final FocusNode? focusNode;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  double value = 40;
  final List<double> ends = [];

  @override
  Widget build(BuildContext context) => LooviSlider(
    value: value,

    enabled: widget.enabled,
    readOnly: widget.readOnly,
    focusNode: widget.focusNode,
    label: 'Valor',
    onChanged: (v) => setState(() => value = v),
    onChangeEnd: ends.add,
  );
}

double _hostValue(WidgetTester tester) => tester.state<_HostState>(find.byType(_Host)).value;

Rect _track(WidgetTester tester) => tester.getRect(find.byKey(const ValueKey('loovi-slider-track')));

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('paint: label caption/large text/secondary, min/max body/medium text/primary, Input value', (
    tester,
  ) async {
    await pumpLoovi(tester, const _Host());
    final label = tester.widget<Text>(find.text('Valor').first);
    expect(label.style!.fontSize, _t.typography.captionLargeRegular.fontSize);
    expect(label.style!.color, _t.text.secondary);
    final min = tester.widget<Text>(find.text('0'));
    expect(min.style!.fontSize, _t.typography.bodyMediumRegular.fontSize);
    expect(min.style!.color, _t.text.primary);
    expect(find.text('100'), findsOneWidget);
    expect(find.byType(LooviInput), findsOneWidget);
    expect(find.text('40'), findsOneWidget); // Input text
  });

  testWidgets('track: 48 dp touch target, fill = value fraction, endCap 14 at rest', (tester) async {
    await pumpLoovi(tester, const _Host());
    final track = _track(tester);
    expect(track.height, greaterThanOrEqualTo(48));
    final fill = tester.getRect(find.byKey(const ValueKey('loovi-slider-fill')));
    expect(fill.width, closeTo(track.width * 0.4, 0.01));
    final cap = tester.getRect(find.byKey(const ValueKey('loovi-slider-end-cap')));
    expect(cap.width, _t.spacing.s150 + _t.spacing.s025);
    expect(cap.center.dx, closeTo(fill.right, 0.01));
  });

  testWidgets('railRow and Input share the row 1:1 with gap spacing/200', (tester) async {
    await pumpLoovi(tester, const _Host());
    final input = tester.getRect(find.byType(LooviInput));
    final minText = tester.getRect(find.text('0'));
    final maxText = tester.getRect(find.text('100'));
    expect(input.left - maxText.right, closeTo(_t.spacing.s200, 0.5));
    expect(maxText.right - minText.left, closeTo(input.width, 0.5));
  });

  testWidgets('drag and tap set the value (snapped to step) and call onChangeEnd', (tester) async {
    await pumpLoovi(tester, const _Host());
    final track = _track(tester);
    await tester.tapAt(Offset(track.left + track.width * 0.75, track.center.dy));
    await tester.pumpAndSettle();
    expect(_hostValue(tester), 75);
    expect(tester.state<_HostState>(find.byType(_Host)).ends.last, 75);

    await tester.dragFrom(Offset(track.left + track.width * 0.75, track.center.dy), Offset(-track.width * 0.5, 0));
    await tester.pumpAndSettle();
    expect(_hostValue(tester), 25);
    expect(find.text('25'), findsOneWidget); // Input follows
  });

  testWidgets('endCap grows to 20 while dragging (status=active)', (tester) async {
    await pumpLoovi(tester, const _Host());
    final track = _track(tester);
    final gesture = await tester.startGesture(Offset(track.left + track.width * 0.4, track.center.dy));
    await gesture.moveBy(const Offset(30, 0));
    await tester.pump();
    expect(tester.widget<LooviSliderLeftRail>(find.byType(LooviSliderLeftRail)).active, isTrue);
    expect(tester.getSize(find.byKey(const ValueKey('loovi-slider-end-cap'))).width, _t.spacing.s250);
    await gesture.up();
    await tester.pumpAndSettle();
    expect(tester.widget<LooviSliderLeftRail>(find.byType(LooviSliderLeftRail)).active, isFalse);
  });

  testWidgets('keyboard: arrows ± step, Home / End; focus = active endCap', (tester) async {
    final node = FocusNode();
    addTearDown(node.dispose);
    await pumpLoovi(tester, _Host(focusNode: node));
    node.requestFocus();
    await tester.pumpAndSettle();
    expect(tester.widget<LooviSliderLeftRail>(find.byType(LooviSliderLeftRail)).active, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(_hostValue(tester), 41);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();
    expect(_hostValue(tester), 39);
    await tester.sendKeyEvent(LogicalKeyboardKey.end);
    await tester.pump();
    expect(_hostValue(tester), 100);
    await tester.sendKeyEvent(LogicalKeyboardKey.home);
    await tester.pump();
    expect(_hostValue(tester), 0);
  });

  testWidgets('Input: typing updates the value (clamped), text normalized on submit', (tester) async {
    await pumpLoovi(tester, const _Host());
    await tester.enterText(find.byType(TextField), '72');
    await tester.pump();
    expect(_hostValue(tester), 72);
    await tester.enterText(find.byType(TextField), '250');
    await tester.pump();
    expect(_hostValue(tester), 100);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.text('100'), findsNWidgets(2)); // max label + Input
    expect(tester.state<_HostState>(find.byType(_Host)).ends.last, 100);
  });

  testWidgets('semantics: slider named by label with value, increase / decrease', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const _Host());
    final node = tester.getSemantics(find.byKey(const ValueKey('loovi-slider-track')));
    final data = node.getSemanticsData();
    expect(data.flagsCollection.isSlider, isTrue);
    expect(data.label, 'Valor');
    expect(data.value, '40');
    expect(data.increasedValue, '41');
    expect(data.decreasedValue, '39');
    expect(data.hasAction(SemanticsAction.increase), isTrue);
    tester.semantics.performAction(find.semantics.byLabel('Valor').first, SemanticsAction.increase);
    await tester.pump();
    expect(_hostValue(tester), 41);
    handle.dispose();
  });

  testWidgets('error: Input error, message text/danger body/small, semantics invalid + hint', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, LooviSlider(value: 10, onChanged: (_) {}, label: 'Valor', errorText: 'Valor inválido'));
    final msg = tester.widget<Text>(find.text('Valor inválido'));
    expect(msg.style!.color, _t.text.danger);
    expect(msg.style!.fontSize, _t.typography.bodySmallRegular.fontSize);
    expect(tester.widget<LooviInput>(find.byType(LooviInput)).error, isTrue);
    final data = tester.getSemantics(find.byKey(const ValueKey('loovi-slider-track'))).getSemanticsData();
    expect(data.hint, 'Valor inválido');
    expect(data.validationResult, SemanticsValidationResult.invalid);
    handle.dispose();
  });

  testWidgets('warning: Input default, message text/warning', (tester) async {
    await pumpLoovi(tester, LooviSlider(value: 10, onChanged: (_) {}, warningText: 'Confira'));
    expect(tester.widget<Text>(find.text('Confira')).style!.color, _t.text.warning);
    expect(tester.widget<LooviInput>(find.byType(LooviInput)).error, isFalse);
  });

  testWidgets('disabled: no change on tap / keys, texts text/placeholder, Input disabled', (tester) async {
    await pumpLoovi(tester, const _Host(enabled: false));
    final track = _track(tester);
    await tester.tapAt(Offset(track.left + track.width * 0.9, track.center.dy));
    await tester.pumpAndSettle();
    expect(_hostValue(tester), 40);
    expect(tester.widget<Text>(find.text('0')).style!.color, _t.text.placeholder);
    expect(tester.widget<LooviInput>(find.byType(LooviInput)).enabled, isFalse);
  });

  testWidgets('read-only: default paint, no change, Input not editable', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const _Host(readOnly: true));
    final track = _track(tester);
    await tester.tapAt(Offset(track.left + track.width * 0.9, track.center.dy));
    await tester.pumpAndSettle();
    expect(_hostValue(tester), 40);
    expect(tester.widget<Text>(find.text('0')).style!.color, _t.text.primary);
    expect(tester.widget<LooviInput>(find.byType(LooviInput)).enabled, isTrue);
    await tester.tap(find.byType(LooviInput), warnIfMissed: false);
    await tester.pump();
    expect(tester.binding.focusManager.primaryFocus?.context?.widget, isNot(isA<EditableText>()));
    final data = tester.getSemantics(find.byKey(const ValueKey('loovi-slider-track'))).getSemanticsData();
    expect(data.flagsCollection.isReadOnly, isTrue);
    expect(data.hasAction(SemanticsAction.increase), isFalse);
    handle.dispose();
  });

  testWidgets('skeleton: SliderSkeletonItem only, announces label + loading', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, LooviSlider(value: 10, onChanged: (_) {}, label: 'Valor', skeleton: true));
    expect(find.byType(LooviSliderSkeletonItem), findsOneWidget);
    expect(find.byType(LooviInput), findsNothing);
    expect(find.bySemanticsLabel('Valor'), findsOneWidget);
    final data = tester.getSemantics(find.bySemanticsLabel('Valor')).getSemanticsData();
    expect(data.hint, 'Carregando');
    handle.dispose();
  });

  testWidgets('continuous step + custom formatter', (tester) async {
    double v = 0;
    await pumpLoovi(
      tester,
      StatefulBuilder(
        builder: (context, setState) => LooviSlider(
          value: v,
          step: null,
          min: 0,
          max: 1,
          valueFormatter: (x) => '${(x * 100).round()}%',
          onChanged: (n) => setState(() => v = n),
        ),
      ),
    );
    expect(find.text('0%'), findsNWidgets(2)); // min label + Input
    expect(find.text('100%'), findsOneWidget);
    final track = _track(tester);
    await tester.tapAt(Offset(track.left + track.width * 0.333, track.center.dy));
    await tester.pumpAndSettle();
    expect(v, closeTo(0.333, 0.001));
  });

  testWidgets('textScaler 2: no overflow', (tester) async {
    await pumpLoovi(tester, LooviSlider(value: 10, onChanged: (_) {}, errorText: 'Erro'), textScale: 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('golden: statuses', (tester) async {
    await pumpGolden(tester, const SliderStatuses(), height: 900);
    await expectLater(find.byType(SliderStatuses), matchesGoldenFile('../goldens/slider_statuses.png'));
  });
}
