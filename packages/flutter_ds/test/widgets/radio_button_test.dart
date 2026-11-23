import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

class _Group extends StatefulWidget {
  const _Group({super.key, this.disabled = false, this.showContent = true});
  final bool disabled;
  final bool showContent;
  @override
  State<_Group> createState() => _GroupState();
}

class _GroupState extends State<_Group> {
  String? value = 'a';
  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final v in ['a', 'b'])
            LooviRadioButton<String>(
              key: ValueKey(v),
              value: v,
              groupValue: value,
              onChanged: (n) => setState(() => value = n),
              disabled: widget.disabled,
              showContent: widget.showContent,
              label: 'Opção $v',
              description: 'Descrição $v',
              semanticLabel: 'Opção $v',
            ),
        ],
      );
}

String? _group(WidgetTester tester) => tester.widget<LooviRadioButton<String>>(find.byKey(const ValueKey('a'))).groupValue;

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('paints the Figma control size (20 × 20) and a 48 dp target', (tester) async {
    await pumpLoovi(tester, const Align(alignment: Alignment.topLeft, child: _Group(showContent: false)));
    expect(tester.getSize(find.byType(LooviRadioButtonControl).first), const Size(20, 20));
    expect(tester.getSize(find.byKey(const ValueKey('a'))), const Size(48, 48));
  });

  testWidgets('tap on control selects; tapping the selected one keeps it', (tester) async {
    await pumpLoovi(tester, const _Group());
    await tester.tap(find.descendant(of: find.byKey(const ValueKey('b')), matching: find.byType(LooviRadioButtonControl)));
    await tester.pumpAndSettle();
    expect(_group(tester), 'b');
    await tester.tap(find.descendant(of: find.byKey(const ValueKey('b')), matching: find.byType(LooviRadioButtonControl)));
    await tester.pumpAndSettle();
    expect(_group(tester), 'b');
  });

  testWidgets('tap on label selects', (tester) async {
    await pumpLoovi(tester, const _Group());
    await tester.tap(find.text('Opção b'));
    await tester.pumpAndSettle();
    expect(_group(tester), 'b');
  });

  testWidgets('tap in the outer 48 dp area (outside the 20 px paint) selects', (tester) async {
    await pumpLoovi(tester, const Align(alignment: Alignment.topLeft, child: _Group(showContent: false)));
    final b = find.byKey(const ValueKey('b'));
    final control = tester.getRect(find.descendant(of: b, matching: find.byType(LooviRadioButtonControl)));
    final p = tester.getRect(b).bottomRight - const Offset(2, 2);
    expect(control.contains(p), isFalse);
    await tester.tapAt(p);
    await tester.pumpAndSettle();
    expect(_group(tester), 'b');
  });

  testWidgets('disabled does not change', (tester) async {
    await pumpLoovi(tester, const _Group(disabled: true));
    await tester.tap(find.text('Opção b'), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(_group(tester), 'a');
  });

  testWidgets('keyboard activation selects when focused', (tester) async {
    final node = FocusNode();
    addTearDown(node.dispose);
    int? v = 1;
    await pumpLoovi(
      tester,
      StatefulBuilder(
        builder: (c, set) => LooviRadioButton<int>(value: 2, groupValue: v, onChanged: (n) => set(() => v = n), focusNode: node, label: 'Dois'),
      ),
    );
    node.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    expect(v, 2);
  });

  testWidgets('semantics: checked / mutually exclusive / enabled / label', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const _Group());
    expect(
      tester.getSemantics(find.byKey(const ValueKey('a'))),
      isSemantics(label: 'Opção a', hint: 'Descrição a', isChecked: true, isInMutuallyExclusiveGroup: true, hasEnabledState: true, isEnabled: true),
    );
    expect(
      tester.getSemantics(find.byKey(const ValueKey('b'))),
      isSemantics(label: 'Opção b', isChecked: false, isInMutuallyExclusiveGroup: true, isEnabled: true, hasTapAction: true),
    );
    await pumpLoovi(tester, const _Group(disabled: true, key: ValueKey('d')));
    expect(tester.getSemantics(find.byKey(const ValueKey('b'))), isSemantics(hasEnabledState: true, isEnabled: false, hasTapAction: false));
    handle.dispose();
  });

  testWidgets('golden: states (default/focus/disabled × false/true)', (tester) async {
    Widget row(bool disabled, bool focus) => Row(
          children: [
            for (final checked in [false, true])
              Expanded(
                child: LooviRadioButton<bool>(
                  value: true,
                  groupValue: checked,
                  onChanged: disabled ? null : (_) {},
                  forceFocusRing: focus,
                  label: 'Label Radio',
                  description: 'checked=$checked',
                ),
              ),
          ],
        );
    await pumpGolden(
      tester,
      Container(
        key: const Key('golden'),
        color: LooviTokens.appCliente.color.backgroundSurface0,
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            row(false, false),
            const SizedBox(height: 8),
            row(false, true),
            const SizedBox(height: 8),
            row(true, false),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (final checked in [false, true])
                  LooviRadioButton<bool>(value: true, groupValue: checked, onChanged: (_) {}, showContent: false, semanticLabel: '$checked'),
                for (final checked in [false, true])
                  LooviRadioButton<bool>(value: true, groupValue: checked, onChanged: (_) {}, showContent: false, forceFocusRing: true, semanticLabel: 'focus $checked'),
              ],
            ),
          ],
        ),
      ),
      height: 240,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/radio_button_states.png'));
  });
}
