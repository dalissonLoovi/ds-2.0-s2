// Direct src import until lib/loovi_ds.dart exports InputSelect (wave 3 integration).
import 'dart:ui' show Tristate;
import 'package:flutter/semantics.dart' show SemanticsAction, SemanticsValidationResult;
import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;
Finder _field() =>
    find.descendant(of: find.byType(LooviInputSelect<String>), matching: find.byType(FocusableActionDetector)).first;

const _options = [
  LooviInputSelectOption(value: 'sp', label: 'São Paulo'),
  LooviInputSelectOption(value: 'rj', label: 'Rio de Janeiro'),
  LooviInputSelectOption(value: 'mg', label: 'Minas Gerais'),
];

List<String> _icons(WidgetTester tester) =>
    tester.widgetList<LooviIcon>(find.byType(LooviIcon)).map((i) => i.name).toList();

BoxDecoration _fieldDeco(WidgetTester tester) => tester
    .widgetList<DecoratedBox>(find.byType(DecoratedBox))
    .map((d) => d.decoration)
    .whereType<BoxDecoration>()
    .firstWhere((d) => d.border != null);

class _Host extends StatefulWidget {
  const _Host({this.initial, this.onChanged});
  final String? initial;
  final ValueChanged<String>? onChanged;
  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  late String? _value = widget.initial;
  @override
  Widget build(BuildContext context) => LooviInputSelect<String>(
    label: 'Estado',
    placeholder: 'Selecione',
    options: _options,
    value: _value,
    onChanged: (v) {
      setState(() => _value = v);
      widget.onChanged?.call(v);
    },
  );
}

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('renders label + chevron-down; value shows option label', (tester) async {
    await pumpLoovi(tester, const _Host(initial: 'rj'));
    expect(find.text('Estado'), findsOneWidget);
    expect(find.text('Rio de Janeiro'), findsOneWidget);
    expect(_icons(tester), [LooviIcons.chevronDownOutline]);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('tap opens the sheet (chevron-up + focus stroke), selecting updates value', (tester) async {
    final picked = <String>[];
    await pumpLoovi(tester, _Host(onChanged: picked.add));
    expect(find.text('Selecione'), findsOneWidget);

    await tester.tap(find.byType(LooviInputSelect<String>));
    await tester.pumpAndSettle();
    expect(find.byType(LooviBottomSheet), findsOneWidget);
    expect(find.text('Minas Gerais'), findsOneWidget);
    final fieldIcons = tester
        .widgetList<LooviIcon>(
          find.descendant(of: find.byType(LooviInputSelect<String>), matching: find.byType(LooviIcon)),
        )
        .map((i) => i.name);
    expect(fieldIcons, contains(LooviIcons.chevronUpOutline));
    expect(_fieldDeco(tester).border, Border.all(color: _t.interactive.focus, width: _t.borderWidth.s025));

    await tester.tap(find.text('Minas Gerais'));
    await tester.pumpAndSettle();
    expect(find.byType(LooviBottomSheet), findsNothing);
    expect(picked, ['mg']);
    expect(find.text('Minas Gerais'), findsOneWidget);
    expect(_icons(tester), [LooviIcons.chevronDownOutline]);
  });

  testWidgets('selected option carries check-outline and selected semantics', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const _Host(initial: 'sp'));
    await tester.tap(find.byType(LooviInputSelect<String>));
    await tester.pumpAndSettle();
    final sheetIcons = tester
        .widgetList<LooviIcon>(find.descendant(of: find.byType(LooviBottomSheet), matching: find.byType(LooviIcon)))
        .map((i) => i.name);
    expect(sheetIcons, contains(LooviIcons.checkOutline));
    final data = tester.getSemantics(find.text('São Paulo').last).getSemanticsData();
    expect(data.flagsCollection.isSelected, Tristate.isTrue);
    handle.dispose();
  });

  testWidgets('dismissing the sheet keeps the value', (tester) async {
    final picked = <String>[];
    await pumpLoovi(tester, _Host(initial: 'sp', onChanged: picked.add));
    await tester.tap(find.byType(LooviInputSelect<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Fechar'));
    await tester.pumpAndSettle();
    expect(picked, isEmpty);
    expect(find.text('São Paulo'), findsOneWidget);
  });

  testWidgets('semantics: button with label, value, expanded=false, hint', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(
      tester,
      LooviInputSelect<String>(
        label: 'Estado',
        options: _options,
        value: 'sp',
        supportingText: 'Onde o carro circula',
        onChanged: (_) {},
      ),
    );
    final data = tester.getSemantics(_field()).getSemanticsData();
    expect(data.label, 'Estado');
    expect(data.value, 'São Paulo');
    expect(data.hint, contains('Onde o carro circula'));
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.hasAction(SemanticsAction.tap), isTrue);
    handle.dispose();
  });

  testWidgets('error: alert before chevron, danger message, invalid semantics', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(
      tester,
      LooviInputSelect<String>(label: 'Estado', options: _options, errorText: 'Escolha um estado', onChanged: (_) {}),
    );
    expect(_icons(tester), [LooviIcons.alertCircleOutline, LooviIcons.chevronDownOutline]);
    expect(tester.widget<Text>(find.text('Escolha um estado')).style!.color, _t.text.danger);
    final chevron = tester.widgetList<LooviIcon>(find.byType(LooviIcon)).last;
    expect(chevron.color, _t.text.primary);
    final data = tester.getSemantics(_field()).getSemanticsData();
    expect(data.validationResult, SemanticsValidationResult.invalid);
    handle.dispose();
  });

  testWidgets('disabled: no sheet, placeholder colors', (tester) async {
    var taps = 0;
    await pumpLoovi(
      tester,
      LooviInputSelect<String>(
        label: 'Estado',
        options: _options,
        value: 'sp',
        enabled: false,
        onChanged: (_) => taps++,
      ),
    );
    await tester.tap(find.byType(LooviInputSelect<String>));
    await tester.pumpAndSettle();
    expect(find.byType(LooviBottomSheet), findsNothing);
    expect(taps, 0);
    expect(tester.widget<Text>(find.text('São Paulo')).style!.color, _t.text.placeholder);
  });

  testWidgets('custom onTap replaces the sheet and drives expanded', (tester) async {
    var taps = 0;
    await pumpLoovi(tester, LooviInputSelect<String>(label: 'Estado', expanded: true, onTap: () => taps++));
    await tester.tap(find.byType(LooviInputSelect<String>));
    await tester.pumpAndSettle();
    expect(taps, 1);
    expect(find.byType(LooviBottomSheet), findsNothing);
    expect(_icons(tester), [LooviIcons.chevronUpOutline]);
  });

  testWidgets('field: 56 min height, app-cliente full radius, chevron 20', (tester) async {
    await pumpLoovi(tester, LooviInputSelect<String>(label: 'Estado', options: _options, onChanged: (_) {}));
    final deco = _fieldDeco(tester);
    expect(deco.borderRadius, BorderRadius.circular(_t.component.input.fieldRadius));
    expect(tester.getSize(find.byType(LooviIcon)), Size.square(_t.spacing.s250));
    final field = find.ancestor(of: find.byType(LooviIcon), matching: find.byType(DecoratedBox)).first;
    expect(tester.getSize(field).height, greaterThanOrEqualTo(_t.spacing.s700));
  });

  testWidgets('textScaler 2: no overflow', (tester) async {
    await pumpLoovi(tester, const _Host(initial: 'rj'), textScale: 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('golden: InputSelect states (app-cliente)', (tester) async {
    await pumpGolden(tester, const _SelectStates(), height: 640);
    await expectLater(find.byType(_SelectStates), matchesGoldenFile('../goldens/input_select_states.png'));
  });
}

class _SelectStates extends StatelessWidget {
  const _SelectStates();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget gap() => SizedBox(height: t.spacing.s200);
    void noop(String _) {}
    return Padding(
      padding: EdgeInsets.all(t.spacing.s200),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LooviInputSelect<String>(label: 'content=label', options: _options, onChanged: noop),
          gap(),
          LooviInputSelect<String>(
            label: 'content=placeholder',
            placeholder: 'Selecione',
            options: _options,
            onChanged: noop,
          ),
          gap(),
          LooviInputSelect<String>(
            label: 'content=value',
            options: _options,
            value: 'sp',
            leadingIcon: true,
            onChanged: noop,
          ),
          gap(),
          LooviInputSelect<String>(
            label: 'state=focus (open)',
            options: _options,
            value: 'sp',
            expanded: true,
            onTap: () {},
          ),
          gap(),
          LooviInputSelect<String>(
            label: 'state=error',
            options: _options,
            errorText: 'Escolha um estado',
            onChanged: noop,
          ),
          gap(),
          LooviInputSelect<String>(label: 'state=disabled', options: _options, value: 'sp', enabled: false),
          gap(),
          ColoredBox(
            color: t.color.backgroundSurfaceInverse3,
            child: Padding(
              padding: EdgeInsets.all(t.spacing.s200),
              child: LooviInputSelect<String>(
                label: 'appearance=inverse',
                options: _options,
                value: 'rj',
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
