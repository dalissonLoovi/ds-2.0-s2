import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

class _Group extends StatefulWidget {
  const _Group({this.disabled = false});
  final bool disabled;
  @override
  State<_Group> createState() => _GroupState();
}

class _GroupState extends State<_Group> {
  String? value = 'sim';
  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final v in ['sim', 'nao'])
            LooviRadioButtonCard<String>(
              key: ValueKey(v),
              value: v,
              groupValue: value,
              onChanged: (n) => setState(() => value = n),
              disabled: widget.disabled,
              label: v == 'sim' ? 'Sim' : 'Não',
              description: 'Descrição $v',
            ),
        ],
      );
}

String? _group(WidgetTester tester) =>
    tester.widget<LooviRadioButtonCard<String>>(find.byKey(const ValueKey('sim'))).groupValue;

BoxDecoration _shell(WidgetTester tester, String key) => tester
    .widget<Container>(find.descendant(of: find.byKey(ValueKey(key)), matching: find.byType(Container)).first)
    .decoration! as BoxDecoration;

void main() {
  setUpAll(loadGoldenFonts);
  const t = LooviTokens.appCliente;

  testWidgets('fills the width and is ≥ 48 dp tall', (tester) async {
    await pumpLoovi(tester, const _Group());
    final size = tester.getSize(find.byKey(const ValueKey('sim')));
    expect(size.width, 390);
    expect(size.height, greaterThanOrEqualTo(48));
  });

  testWidgets('tap anywhere on the card selects', (tester) async {
    await pumpLoovi(tester, const _Group());
    final card = tester.getRect(find.byKey(const ValueKey('nao')));
    await tester.tapAt(card.centerRight - const Offset(8, 0));
    await tester.pumpAndSettle();
    expect(_group(tester), 'nao');
  });

  testWidgets('checked shell: surface/1 + border-feedback/primary; unchecked: surface/0 + border/1', (tester) async {
    await pumpLoovi(tester, const _Group());
    final on = _shell(tester, 'sim');
    final off = _shell(tester, 'nao');
    expect(on.color, t.color.backgroundSurface1);
    expect((on.border! as Border).top.color, t.color.borderFeedbackPrimary);
    expect(off.color, t.color.backgroundSurface0);
    expect((off.border! as Border).top.color, t.color.border1);
    expect((off.border! as Border).top.width, t.borderWidth.s012);
    expect(on.borderRadius, BorderRadius.circular(t.radius.s400));
  });

  testWidgets('checked radio is a ring only (no center dot)', (tester) async {
    await pumpLoovi(tester, const _Group());
    final control = tester.widget<LooviRadioButtonControl>(
        find.descendant(of: find.byKey(const ValueKey('sim')), matching: find.byType(LooviRadioButtonControl)));
    expect(control.checked, isTrue);
    final box = tester.widget<Container>(find.descendant(of: find.byWidget(control), matching: find.byType(Container)));
    final d = box.decoration! as BoxDecoration;
    expect(d.color, isNull);
    expect((d.border! as Border).top.width, t.borderWidth.s050);
  });

  testWidgets('disabled: no change, border/2 shell, placeholder text', (tester) async {
    await pumpLoovi(tester, const _Group(disabled: true));
    await tester.tap(find.text('Não'));
    await tester.pumpAndSettle();
    expect(_group(tester), 'sim');
    expect((_shell(tester, 'nao').border! as Border).top.color, t.color.border2);
    expect(tester.widget<Text>(find.text('Não')).style!.color, t.text.placeholder);
    expect(tester.widget<Text>(find.text('Descrição nao')).style!.color, t.text.placeholder);
  });

  testWidgets('keyboard activation selects and shows the focus stroke on the shell', (tester) async {
    final node = FocusNode();
    addTearDown(node.dispose);
    int? v = 1;
    await pumpLoovi(
      tester,
      StatefulBuilder(
        builder: (c, set) => LooviRadioButtonCard<int>(
          key: const ValueKey('k'),
          value: 2,
          groupValue: v,
          onChanged: (n) => set(() => v = n),
          focusNode: node,
          label: 'Dois',
        ),
      ),
    );
    FocusManager.instance.highlightStrategy = FocusHighlightStrategy.alwaysTraditional;
    addTearDown(() => FocusManager.instance.highlightStrategy = FocusHighlightStrategy.automatic);
    await tester.pump();
    node.requestFocus();
    await tester.pump();
    await tester.pump(); // focus highlight callback runs post-frame
    expect(node.hasFocus, isTrue);
    expect(FocusManager.instance.highlightMode, FocusHighlightMode.traditional);
    expect((_shell(tester, 'k').border! as Border).top.color, t.interactive.focus);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    expect(v, 2);
  });

  testWidgets('semantics: radio checked / mutually exclusive / description hint', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const _Group());
    expect(
      tester.getSemantics(find.byKey(const ValueKey('sim'))),
      isSemantics(label: 'Sim', hint: 'Descrição sim', isChecked: true, isInMutuallyExclusiveGroup: true, hasEnabledState: true, isEnabled: true),
    );
    expect(
      tester.getSemantics(find.byKey(const ValueKey('nao'))),
      isSemantics(label: 'Não', isChecked: false, isInMutuallyExclusiveGroup: true, isEnabled: true, hasTapAction: true),
    );
    handle.dispose();
  });

  testWidgets('golden: states (default / focus / disabled × checked)', (tester) async {
    Widget card(bool checked, {bool disabled = false, bool focus = false, bool description = true}) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: LooviRadioButtonCard<bool>(
            value: true,
            groupValue: checked,
            onChanged: disabled ? null : (_) {},
            forceFocusRing: focus,
            label: checked ? 'Sim' : 'Não',
            description: 'Texto de descrição abaixo do label do radio',
            showDescription: description,
          ),
        );
    await pumpGolden(
      tester,
      Container(
        key: const Key('golden'),
        color: LooviTokens.appCliente.color.backgroundSurface0,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            card(false),
            card(true),
            card(false, focus: true),
            card(true, focus: true),
            card(false, disabled: true),
            card(true, disabled: true),
            card(true, description: false),
          ],
        ),
      ),
      height: 600,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/radio_button_card_states.png'));
  });
}
