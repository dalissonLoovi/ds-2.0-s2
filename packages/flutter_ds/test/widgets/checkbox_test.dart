import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

/// Stateful host so taps flow back into the widget.
class _Host extends StatefulWidget {
  const _Host({super.key, this.initial = LooviCheckboxChecked.unchecked, this.disabled = false, this.showContent = true});
  final LooviCheckboxChecked initial;
  final bool disabled;
  final bool showContent;
  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  late LooviCheckboxChecked value = widget.initial;
  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.topLeft,
        child: LooviCheckbox(
          checked: value,
          onChanged: (v) => setState(() => value = v),
          disabled: widget.disabled,
          showContent: widget.showContent,
          label: 'Aceito os termos',
          description: 'Texto de descrição',
          semanticLabel: 'Aceito os termos',
        ),
      );
}

LooviCheckboxChecked _value(WidgetTester tester) => tester.widget<LooviCheckbox>(find.byType(LooviCheckbox)).checked;

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('paints the Figma control size (20 × 20) and a 48 dp target', (tester) async {
    await pumpLoovi(tester, const _Host(showContent: false));
    expect(tester.getSize(find.byType(LooviCheckboxControl)), const Size(20, 20));
    expect(tester.getSize(find.byType(LooviCheckbox)), const Size(48, 48));
  });

  testWidgets('tap on control toggles; mixed → checked', (tester) async {
    await pumpLoovi(tester, const _Host());
    await tester.tap(find.byType(LooviCheckboxControl));
    await tester.pumpAndSettle();
    expect(_value(tester), LooviCheckboxChecked.checked);
    await tester.tap(find.byType(LooviCheckboxControl));
    await tester.pumpAndSettle();
    expect(_value(tester), LooviCheckboxChecked.unchecked);

    await pumpLoovi(tester, const _Host(initial: LooviCheckboxChecked.mixed, key: ValueKey('m')));
    await tester.tap(find.byType(LooviCheckboxControl));
    await tester.pumpAndSettle();
    expect(_value(tester), LooviCheckboxChecked.checked);
  });

  testWidgets('tap on label toggles', (tester) async {
    await pumpLoovi(tester, const _Host());
    await tester.tap(find.text('Aceito os termos'));
    await tester.pumpAndSettle();
    expect(_value(tester), LooviCheckboxChecked.checked);
  });

  testWidgets('tap in the outer 48 dp area (outside the 20 px paint) toggles', (tester) async {
    await pumpLoovi(tester, const _Host(showContent: false));
    final controlRect = tester.getRect(find.byType(LooviCheckboxControl));
    final target = tester.getRect(find.byType(LooviCheckbox));
    final p = target.topLeft + const Offset(2, 2);
    expect(controlRect.contains(p), isFalse);
    await tester.tapAt(p);
    await tester.pumpAndSettle();
    expect(_value(tester), LooviCheckboxChecked.checked);
  });

  testWidgets('disabled does not change', (tester) async {
    await pumpLoovi(tester, const _Host(disabled: true));
    await tester.tap(find.byType(LooviCheckboxControl), warnIfMissed: false);
    await tester.tap(find.text('Aceito os termos'), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(_value(tester), LooviCheckboxChecked.unchecked);
  });

  testWidgets('keyboard activation (space) toggles when focused', (tester) async {
    final node = FocusNode();
    addTearDown(node.dispose);
    var v = LooviCheckboxChecked.unchecked;
    await pumpLoovi(
      tester,
      StatefulBuilder(
        builder: (c, set) => LooviCheckbox(checked: v, onChanged: (n) => set(() => v = n), focusNode: node, label: 'Teclado'),
      ),
    );
    node.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    expect(v, LooviCheckboxChecked.checked);
  });

  testWidgets('semantics: checked / mixed / enabled / label', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const _Host(initial: LooviCheckboxChecked.checked));
    expect(
      tester.getSemantics(find.byType(LooviCheckbox)),
      isSemantics(label: 'Aceito os termos', hint: 'Texto de descrição', isChecked: true, hasEnabledState: true, isEnabled: true, hasTapAction: true),
    );

    await pumpLoovi(tester, const _Host(initial: LooviCheckboxChecked.mixed, disabled: true, key: ValueKey('d')));
    expect(
      tester.getSemantics(find.byType(LooviCheckbox)),
      isSemantics(isCheckStateMixed: true, hasEnabledState: true, isEnabled: false, hasTapAction: false),
    );
    handle.dispose();
  });

  testWidgets('golden: states (default/focus/disabled × false/true/mixed)', (tester) async {
    Widget row(bool disabled, bool focus) => Row(
          children: [
            for (final c in LooviCheckboxChecked.values)
              Expanded(
                child: LooviCheckbox(
                  checked: c,
                  onChanged: disabled ? null : (_) {},
                  forceFocusRing: focus,
                  label: 'Label',
                  description: c.seedValue,
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
                for (final c in LooviCheckboxChecked.values) LooviCheckbox(checked: c, onChanged: (_) {}, showContent: false, semanticLabel: c.seedValue),
                LooviCheckbox(checked: LooviCheckboxChecked.checked, onChanged: (_) {}, showContent: false, forceFocusRing: true, semanticLabel: 'focus'),
              ],
            ),
          ],
        ),
      ),
      height: 240,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/checkbox_states.png'));
  });
}
