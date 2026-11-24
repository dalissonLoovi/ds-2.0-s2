// Direct src imports until lib/loovi_ds.dart exports InputDatePicker / DatePickerSelect (wave 3 integration).
import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;
Finder _field() =>
    find.descendant(of: find.byType(LooviInputDatePicker), matching: find.byType(FocusableActionDetector)).first;

class _Host extends StatefulWidget {
  const _Host({this.initial, this.onChanged});
  final DateTime? initial;
  final ValueChanged<DateTime>? onChanged;
  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  late DateTime? _value = widget.initial;
  @override
  Widget build(BuildContext context) => LooviInputDatePicker(
    placeholder: 'Selecione a data',
    value: _value,
    firstDate: DateTime(2020),
    lastDate: DateTime(2030, 12, 31),
    onChanged: (d) {
      setState(() => _value = d);
      widget.onChanged?.call(d);
    },
  );
}

List<String> _fieldIcons(WidgetTester tester) => tester
    .widgetList<LooviIcon>(find.descendant(of: find.byType(LooviInputDatePicker), matching: find.byType(LooviIcon)))
    .map((i) => i.name)
    .toList();

void main() {
  setUpAll(loadGoldenFonts);

  test('looviFormatDate: "21 abr 2025"', () {
    expect(looviFormatDate(DateTime(2025, 4, 21)), '21 abr 2025');
    expect(looviFormatDate(DateTime(2025, 1, 5)), '05 jan 2025');
  });

  testWidgets('renders label, placeholder and calendar 20', (tester) async {
    await pumpLoovi(tester, const _Host());
    expect(find.text('Data'), findsOneWidget);
    expect(find.text('Selecione a data'), findsOneWidget);
    expect(_fieldIcons(tester), [LooviIcons.calendarOutline]);
    expect(tester.getSize(find.byType(LooviIcon)), Size.square(_t.spacing.s250));
  });

  testWidgets('tap opens the sheet with DatePickerSelect; pick month + confirm', (tester) async {
    final picked = <DateTime>[];
    await pumpLoovi(tester, _Host(initial: DateTime(2025, 4, 21), onChanged: picked.add));
    expect(find.text('21 abr 2025'), findsOneWidget);

    await tester.tap(find.byType(LooviInputDatePicker));
    await tester.pumpAndSettle();
    expect(find.byType(LooviBottomSheet), findsOneWidget);
    expect(find.byType(LooviDatePickerSelect), findsOneWidget);
    expect(find.text('Abril'), findsOneWidget);

    await tester.tap(find.text('Abril'));
    await tester.pumpAndSettle();
    final monthItem = tester
        .widgetList<LooviDatePickerSelectItem>(find.byType(LooviDatePickerSelectItem))
        .firstWhere((i) => i.unit == LooviDatePickerSelectItemUnit.month);
    expect(monthItem.expanded, isTrue);

    await tester.tap(find.text('Junho'));
    await tester.pumpAndSettle();
    expect(find.text('Junho'), findsOneWidget); // list closed; block shows the new value

    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();
    expect(find.byType(LooviBottomSheet), findsNothing);
    expect(picked, [DateTime(2025, 6, 21)]);
    expect(find.text('21 jun 2025'), findsOneWidget);
  });

  testWidgets('day is clamped to the month length', (tester) async {
    final picked = <DateTime>[];
    await pumpLoovi(tester, _Host(initial: DateTime(2025, 1, 31), onChanged: picked.add));
    await tester.tap(find.byType(LooviInputDatePicker));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Janeiro'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fevereiro'));
    await tester.pumpAndSettle();
    expect(find.text('28'), findsOneWidget);
    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();
    expect(picked, [DateTime(2025, 2, 28)]);
  });

  testWidgets('field paints focus while the sheet is open; dismiss keeps value', (tester) async {
    final picked = <DateTime>[];
    await pumpLoovi(tester, _Host(initial: DateTime(2025, 4, 21), onChanged: picked.add));
    await tester.tap(find.byType(LooviInputDatePicker));
    await tester.pumpAndSettle();
    final calendar = tester
        .widgetList<LooviIcon>(find.descendant(of: find.byType(LooviInputDatePicker), matching: find.byType(LooviIcon)))
        .single;
    expect(calendar.color, _t.text.brand);
    await tester.tap(find.bySemanticsLabel('Fechar'));
    await tester.pumpAndSettle();
    expect(picked, isEmpty);
    expect(find.text('21 abr 2025'), findsOneWidget);
  });

  testWidgets('semantics: button, label + formatted value', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, _Host(initial: DateTime(2025, 4, 21)));
    final data = tester.getSemantics(_field()).getSemanticsData();
    expect(data.label, 'Data');
    expect(data.value, '21 abr 2025');
    expect(data.flagsCollection.isButton, isTrue);
    handle.dispose();
  });

  testWidgets('error: alert before calendar; calendar stays text/primary', (tester) async {
    await pumpLoovi(tester, LooviInputDatePicker(errorText: 'Data inválida', onChanged: (_) {}));
    expect(_fieldIcons(tester), [LooviIcons.alertCircleOutline, LooviIcons.calendarOutline]);
    expect(tester.widgetList<LooviIcon>(find.byType(LooviIcon)).last.color, _t.text.primary);
    expect(tester.widget<Text>(find.text('Data inválida')).style!.color, _t.text.danger);
  });

  testWidgets('disabled: no sheet, no fill, border/1', (tester) async {
    await pumpLoovi(tester, LooviInputDatePicker(value: DateTime(2025, 4, 21), enabled: false, onChanged: (_) {}));
    await tester.tap(find.byType(LooviInputDatePicker));
    await tester.pumpAndSettle();
    expect(find.byType(LooviBottomSheet), findsNothing);
    final deco = tester
        .widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .map((d) => d.decoration)
        .whereType<BoxDecoration>()
        .firstWhere((d) => d.border != null);
    expect(deco.border, Border.all(color: _t.color.border1, width: _t.borderWidth.s012));
    expect(deco.color!.a, 0);
  });

  testWidgets('showLooviDatePicker format=year returns Jan 1 of the picked year', (tester) async {
    DateTime? result;
    await pumpLoovi(
      tester,
      Builder(
        builder: (context) => LooviButton(
          label: 'abrir',
          onPressed: () async => result = await showLooviDatePicker(
            context,
            initialDate: DateTime(2025, 4, 21),
            firstDate: DateTime(2020),
            lastDate: DateTime(2030),
            format: LooviDatePickerSelectFormat.year,
          ),
        ),
      ),
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    expect(find.byType(LooviDatePickerSelectItem), findsOneWidget);
    await tester.tap(find.text('2025'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2027'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();
    expect(result, DateTime(2027));
  });

  testWidgets('golden: InputDatePicker states (app-cliente)', (tester) async {
    await pumpGolden(tester, const _DateStates(), height: 640);
    await expectLater(find.byType(_DateStates), matchesGoldenFile('../goldens/input_date_picker_states.png'));
  });

  testWidgets('golden: date picker sheet with month expanded (app-cliente)', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(looviHarness(_Host(initial: DateTime(2025, 4, 21))));
    await tester.tap(find.byType(LooviInputDatePicker));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Abril'));
    await tester.pumpAndSettle();
    await expectLater(find.byType(LooviBottomSheet), matchesGoldenFile('../goldens/input_date_picker_sheet.png'));
  });
}

class _DateStates extends StatelessWidget {
  const _DateStates();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget gap() => SizedBox(height: t.spacing.s200);
    void noop(DateTime _) {}
    final date = DateTime(2025, 4, 21);
    return Padding(
      padding: EdgeInsets.all(t.spacing.s200),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LooviInputDatePicker(onChanged: noop),
          gap(),
          LooviInputDatePicker(placeholder: 'Selecione a data', onChanged: noop),
          gap(),
          LooviInputDatePicker(value: date, leadingIcon: true, onChanged: noop),
          gap(),
          LooviInputDatePicker(label: 'state=focus (open)', value: date, expanded: true, onTap: () {}),
          gap(),
          LooviInputDatePicker(label: 'state=error', value: date, errorText: 'Data inválida', onChanged: noop),
          gap(),
          LooviInputDatePicker(label: 'state=disabled', value: date, enabled: false),
          gap(),
          ColoredBox(
            color: t.color.backgroundSurfaceInverse3,
            child: Padding(
              padding: EdgeInsets.all(t.spacing.s200),
              child: LooviInputDatePicker(
                label: 'appearance=inverse',
                value: date,
                appearance: LooviInputAppearance.inverse,
                onChanged: noop,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
