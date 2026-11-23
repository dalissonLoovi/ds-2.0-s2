import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

class _Host extends StatefulWidget {
  const _Host({super.key, this.size = LooviSwitchSize.md, this.disabled = false, this.initial = false});
  final LooviSwitchSize size;
  final bool disabled;
  final bool initial;
  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  late bool value = widget.initial;
  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.topLeft,
        child: LooviSwitch(
          checked: value,
          onChanged: (v) => setState(() => value = v),
          size: widget.size,
          disabled: widget.disabled,
          semanticLabel: 'Notificações',
        ),
      );
}

bool _value(WidgetTester tester) => tester.widget<LooviSwitch>(find.byType(LooviSwitch)).checked;

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('paints Figma sizes (md 56×32, sm 40×20) inside a ≥48 dp target', (tester) async {
    await pumpLoovi(tester, const _Host());
    expect(tester.getSize(find.byType(LooviSwitchControl)), const Size(56, 32));
    expect(tester.getSize(find.byType(LooviSwitch)), const Size(56, 48));

    await pumpLoovi(tester, const _Host(size: LooviSwitchSize.sm, key: ValueKey('sm')));
    expect(tester.getSize(find.byType(LooviSwitchControl)), const Size(40, 20));
    expect(tester.getSize(find.byType(LooviSwitch)), const Size(48, 48));
  });

  testWidgets('thumb geometry: md 24 at inset 4, sm 16 at inset 2', (tester) async {
    await pumpLoovi(tester, const _Host(initial: true));
    final track = tester.getRect(find.byType(LooviSwitchControl));
    final thumb = tester.getRect(find.descendant(of: find.byType(LooviSwitchControl), matching: find.byType(AnimatedContainer)).last);
    expect(thumb.size, const Size(24, 24));
    expect(thumb.left - track.left, 28);
    expect(thumb.top - track.top, 4);

    await pumpLoovi(tester, const _Host(size: LooviSwitchSize.sm, key: ValueKey('sm')));
    final trackSm = tester.getRect(find.byType(LooviSwitchControl));
    final thumbSm = tester.getRect(find.descendant(of: find.byType(LooviSwitchControl), matching: find.byType(AnimatedContainer)).last);
    expect(thumbSm.size, const Size(16, 16));
    expect(thumbSm.left - trackSm.left, 2);
    expect(thumbSm.top - trackSm.top, 2);
  });

  testWidgets('tap toggles; tap in the outer 48 dp area (sm) toggles', (tester) async {
    await pumpLoovi(tester, const _Host());
    await tester.tap(find.byType(LooviSwitchControl));
    await tester.pumpAndSettle();
    expect(_value(tester), isTrue);

    await pumpLoovi(tester, const _Host(size: LooviSwitchSize.sm, key: ValueKey('sm')));
    final paint = tester.getRect(find.byType(LooviSwitchControl));
    final p = tester.getRect(find.byType(LooviSwitch)).topLeft + const Offset(1, 1);
    expect(paint.contains(p), isFalse);
    await tester.tapAt(p);
    await tester.pumpAndSettle();
    expect(_value(tester), isTrue);
  });

  testWidgets('disabled does not change', (tester) async {
    await pumpLoovi(tester, const _Host(disabled: true));
    await tester.tap(find.byType(LooviSwitchControl), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(_value(tester), isFalse);
  });

  testWidgets('keyboard activation toggles when focused', (tester) async {
    final node = FocusNode();
    addTearDown(node.dispose);
    var v = false;
    await pumpLoovi(
      tester,
      StatefulBuilder(builder: (c, set) => LooviSwitch(checked: v, onChanged: (n) => set(() => v = n), focusNode: node, semanticLabel: 'Wi-Fi')),
    );
    node.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    expect(v, isTrue);
  });

  testWidgets('semantics: toggled / enabled / label', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const _Host(initial: true));
    expect(
      tester.getSemantics(find.byType(LooviSwitch)),
      isSemantics(label: 'Notificações', hasToggledState: true, isToggled: true, hasEnabledState: true, isEnabled: true, hasTapAction: true),
    );
    await pumpLoovi(tester, const _Host(disabled: true, key: ValueKey('d')));
    expect(
      tester.getSemantics(find.byType(LooviSwitch)),
      isSemantics(hasToggledState: true, isToggled: false, isEnabled: false, hasTapAction: false),
    );
    handle.dispose();
  });

  testWidgets('golden: states (size × default/focus/disabled × off/on, md with icon)', (tester) async {
    Widget row(LooviSwitchSize size, {bool icon = false}) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (final (disabled, focus) in [(false, false), (false, true), (true, false)])
              for (final checked in [false, true])
                LooviSwitch(
                  checked: checked,
                  onChanged: disabled ? null : (_) {},
                  size: size,
                  showIcon: icon,
                  forceFocusRing: focus,
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
            row(LooviSwitchSize.md),
            row(LooviSwitchSize.md, icon: true),
            row(LooviSwitchSize.sm),
          ],
        ),
      ),
      height: 170,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/switch_states.png'));
  });
}
